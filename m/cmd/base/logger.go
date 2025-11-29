package base

import (
	"os"

	"github.com/charmbracelet/log"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var logger *zap.Logger
var atomicLevel zap.AtomicLevel

var fx_logger *zap.Logger
var fx_atomic_level zap.AtomicLevel

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

// InitFxLogger initializes the fx logger at DEBUG level
func InitFxLogger() error {
	// If fx logger already exists, just ensure it's at DEBUG level
	if fx_logger != nil && fx_atomic_level != (zap.AtomicLevel{}) {
		fx_atomic_level.SetLevel(zapcore.DebugLevel)
		return nil
	}

	// Create new fx logger with DEBUG level
	fx_atomic_level = zap.NewAtomicLevelAt(zapcore.DebugLevel)
	config := zap.NewProductionConfig()
	config.Level = fx_atomic_level
	config.Encoding = "console"
	config.EncoderConfig.TimeKey = "time"
	config.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	config.EncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
	config.DisableStacktrace = true

	var err error
	fx_logger, err = config.Build()
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

// FxLogger returns the fx-specific logger instance at DEBUG level
func FxLogger() *zap.Logger {
	if fx_logger == nil {
		// Fallback: initialize fx logger at DEBUG level
		InitFxLogger()
	}
	return fx_logger
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
