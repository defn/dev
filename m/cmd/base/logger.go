package base

import (
	"os"

	"github.com/charmbracelet/log"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var logger *zap.Logger
var atomicLevel zap.AtomicLevel

// InitLogger initializes the global logger with the specified level
func InitLogger(level string) error {
	var zap_level zapcore.Level
	if err := zap_level.UnmarshalText([]byte(level)); err != nil {
		zap_level = zapcore.WarnLevel
	}

	// If logger already exists, just update the level
	if logger != nil && atomicLevel != (zap.AtomicLevel{}) {
		atomicLevel.SetLevel(zap_level)
		return nil
	}

	// Create new logger with atomic level
	atomicLevel = zap.NewAtomicLevelAt(zap_level)
	config := zap.NewProductionConfig()
	config.Level = atomicLevel
	config.Encoding = "console"
	config.EncoderConfig.TimeKey = "time"
	config.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	config.EncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
	config.DisableStacktrace = true // Disable automatic stack traces on error logs

	var err error
	logger, err = config.Build()
	if err != nil {
		return err
	}

	return nil
}

// Logger returns the global logger instance
func Logger() *zap.Logger {
	if logger == nil {
		// Fallback to a default logger if not initialized
		logger, _ = zap.NewProduction()
	}
	return logger
}

// CommandLogger returns a logger with the command name pre-populated
func CommandLogger(cmdName string) *zap.Logger {
	return Logger().With(zap.String("cmd", cmdName))
}

// WorkerLogger returns a logger with the worker name pre-populated
func WorkerLogger(workerName string) *zap.Logger {
	return Logger().With(zap.String("worker", workerName))
}

// CharmLogger returns a charmbracelet logger instance
func CharmLogger() *log.Logger {
	return log.New(os.Stdout)
}
