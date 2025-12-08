package tiltfile

import (
	"bytes"
	"fmt"
	"io"
	"strings"

	"github.com/pkg/errors"
	"go.starlark.net/starlark"

	"github.com/defn/dev/m/tilt/internal/localexec"
	tiltfile_io "github.com/defn/dev/m/tilt/internal/tiltfile/io"
	"github.com/defn/dev/m/tilt/internal/tiltfile/starkit"
	"github.com/defn/dev/m/tilt/internal/tiltfile/value"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

const localLogPrefix = " → "

type execCommandOptions struct {
	// logOutput writes stdout and stderr to logs if true.
	logOutput bool
	// logCommand writes the command being executed to logs if true.
	logCommand bool
	// logCommandPrefix is a custom prefix before the command (default: "Running: ") used if logCommand is true.
	logCommandPrefix string
	// stdin, if non-nil, will be written to the command's stdin
	stdin *string
}

func (s *tiltfileState) local(thread *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var commandValue, commandBatValue, commandDirValue starlark.Value
	var commandEnv value.StringStringMap
	var stdin value.Stringable
	quiet := false
	echoOff := false
	err := s.unpackArgs(fn.Name(), args, kwargs,
		"command", &commandValue,
		"quiet?", &quiet,
		"command_bat", &commandBatValue,
		"echo_off", &echoOff,
		"env", &commandEnv,
		"dir?", &commandDirValue,
		"stdin?", &stdin,
	)
	if err != nil {
		return nil, err
	}

	cmd, err := value.ValueGroupToCmdHelper(thread, commandValue, commandBatValue, commandDirValue, commandEnv)
	if err != nil {
		return nil, err
	}

	execOptions := execCommandOptions{
		logOutput:        !quiet,
		logCommand:       !echoOff,
		logCommandPrefix: "local:",
	}
	if stdin.IsSet {
		s := stdin.Value
		execOptions.stdin = &s
	}
	out, err := s.execLocalCmd(thread, cmd, execOptions)
	if err != nil {
		return nil, err
	}

	return tiltfile_io.NewBlob(out, fmt.Sprintf("local: %s", cmd)), nil
}

func (s *tiltfileState) execLocalCmd(t *starlark.Thread, cmd model.Cmd, options execCommandOptions) (string, error) {
	var stdoutBuf, stderrBuf bytes.Buffer
	ctx, err := starkit.ContextFromThread(t)
	if err != nil {
		return "", err
	}

	if options.logCommand {
		prefix := options.logCommandPrefix
		if prefix == "" {
			prefix = "Running:"
		}
		s.logger.Infof("%s %s", prefix, cmd)
	}

	var runIO localexec.RunIO
	if options.logOutput {
		logOutput := logger.NewMutexWriter(logger.NewPrefixedLogger(localLogPrefix, s.logger).Writer(logger.InfoLvl))
		runIO.Stdout = io.MultiWriter(&stdoutBuf, logOutput)
		runIO.Stderr = io.MultiWriter(&stderrBuf, logOutput)
	} else {
		runIO.Stdout = &stdoutBuf
		runIO.Stderr = &stderrBuf
	}

	if options.stdin != nil {
		runIO.Stdin = strings.NewReader(*options.stdin)
	}

	// TODO(nick): Should this also inject any docker.Env overrides?
	exitCode, err := s.execer.Run(ctx, cmd, runIO)
	if err != nil || exitCode != 0 {
		var errMessage strings.Builder
		errMessage.WriteString(fmt.Sprintf("command %q failed.", cmd))
		if err != nil {
			errMessage.WriteString(fmt.Sprintf("\nerror: %v", err))
		} else {
			errMessage.WriteString(fmt.Sprintf("\nerror: exit status %d", exitCode))
		}

		if !options.logOutput {
			// if we already logged the output, don't include it in the error message to prevent it from
			// getting output 2x

			stdout, stderr := stdoutBuf.String(), stderrBuf.String()
			fmt.Fprintf(&errMessage, "\nstdout:\n%v\nstderr:\n%v\n", stdout, stderr)
		}

		return "", errors.New(errMessage.String())
	}

	// only show that there was no output if the command was echoed AND we wanted output logged
	// otherwise, it's confusing to get "[no output]" without context of _what_ didn't have output
	if options.logCommand && options.logOutput && stdoutBuf.Len() == 0 && stderrBuf.Len() == 0 {
		s.logger.Infof("%s[no output]", localLogPrefix)
	}

	return stdoutBuf.String(), nil
}

