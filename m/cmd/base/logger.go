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

// InitFxLogger initializes the fx logger based on app log level
// fx logs at INFO level, so we adjust fx logger to hide them appropriately:
// - app DEBUG: fx logger at DEBUG (show all fx logs)
// - app INFO: fx logger at WARN (hide fx INFO logs)
// - app WARN: fx logger at ERROR (hide fx INFO and WARN logs)
func InitFxLogger(app_level string) error {
	var fx_level zapcore.Level

	// Parse app level
	var app_zap_level zapcore.Level
	if err := app_zap_level.UnmarshalText([]byte(app_level)); err != nil {
		app_zap_level = zapcore.InfoLevel
	}

	// Set fx level based on app level
	switch app_zap_level {
	case zapcore.DebugLevel:
		fx_level = zapcore.DebugLevel // Show all fx logs
	case zapcore.InfoLevel:
		fx_level = zapcore.WarnLevel // Hide fx INFO logs
	default: // WARN or higher
		fx_level = zapcore.ErrorLevel // Hide fx INFO and WARN logs
	}

	// If fx logger already exists, just update the level
	if fx_logger != nil && fx_atomic_level != (zap.AtomicLevel{}) {
		fx_atomic_level.SetLevel(fx_level)
		return nil
	}

	// Create new fx logger
	fx_atomic_level = zap.NewAtomicLevelAt(fx_level)
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

// FxLogger returns the fx-specific logger instance
func FxLogger() *zap.Logger {
	if fx_logger == nil {
		// Fallback: initialize fx logger with default level
		InitFxLogger("warn")
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
