// Package main provides a CUE-validated greeting command.
package main

import (
	"fmt"
	"io/fs"
	"os"
	"strings"

	"github.com/samber/lo"
	"go.uber.org/zap"
	"gopkg.in/yaml.v3"

	"github.com/defn/dev/m/cue"
)

// Greet formats a greeting with the given name.
func Greet(name string) string {
	return "Hello, " + name
}

// Uppercase returns the string in uppercase.
func Uppercase(s string) string {
	return strings.ToUpper(s)
}

// Decorate adds decoration around a greeting.
func Decorate(greeting string) string {
	return "*** " + greeting + " ***"
}

// GreetingConfig represents the greeting configuration through the pipeline.
type GreetingConfig struct {
	ViperGreeting       string
	TransformedGreeting string // Capitalized greeting for YAML (without "Hello, ")
	FormattedGreeting   string // Final output with "Hello, " prefix
	MergedConfigPath    string
	Validated           bool
}

// GreetingConfigBuilder implements a fluent builder pattern for greeting configuration.
type GreetingConfigBuilder struct {
	config GreetingConfig
	err    error
	logger *zap.Logger
}

// NewGreetingBuilder creates a new GreetingConfigBuilder with the given logger.
func NewGreetingBuilder(logger *zap.Logger) *GreetingConfigBuilder {
	return &GreetingConfigBuilder{logger: logger}
}

// WithViperGreeting sets the initial greeting from viper configuration.
func (b *GreetingConfigBuilder) WithViperGreeting(greeting string) *GreetingConfigBuilder {
	if b.err != nil {
		return b
	}
	b.config.ViperGreeting = greeting
	return b
}

// WithTransform transforms the greeting by capitalizing each word.
func (b *GreetingConfigBuilder) WithTransform() *GreetingConfigBuilder {
	if b.err != nil {
		return b
	}
	// Use lo to transform greeting - capitalize each word
	words := strings.Fields(b.config.ViperGreeting)
	transformed_words := lo.Map(words, func(word string, _ int) string {
		if len(word) > 0 {
			return strings.ToUpper(word[:1]) + word[1:]
		}
		return word
	})
	b.config.TransformedGreeting = strings.Join(transformed_words, " ")
	// Add "Hello, " prefix for final formatted output
	b.config.FormattedGreeting = "Hello, " + b.config.TransformedGreeting

	b.logger.Debug("transformed greeting",
		zap.String("original", b.config.ViperGreeting),
		zap.String("transformed", b.config.TransformedGreeting),
		zap.String("formatted", b.config.FormattedGreeting))

	return b
}

// WithMergedConfig reads a YAML config file and merges it with the transformed greeting.
func (b *GreetingConfigBuilder) WithMergedConfig(config_path string) *GreetingConfigBuilder {
	if b.err != nil {
		return b
	}
	merged_path, err := MergeConfigWithGreeting(config_path, b.config.TransformedGreeting)
	if err != nil {
		b.err = fmt.Errorf("failed to merge config: %w", err)
		return b
	}
	b.config.MergedConfigPath = merged_path
	return b
}

// WithValidation validates the merged config against a CUE schema.
func (b *GreetingConfigBuilder) WithValidation(overlay cue.CueOverlayFS, module string, package_name string, schema_label string, cue_content string, schema_files fs.FS) *GreetingConfigBuilder {
	if b.err != nil {
		return b
	}
	if err := overlay.ValidateConfig(
		module,
		package_name,
		b.config.MergedConfigPath,
		schema_label,
		cue_content,
		schema_files,
	); err != nil {
		b.err = fmt.Errorf("config validation failed: %w", err)
		return b
	}
	b.config.Validated = true
	return b
}

// Build returns the final GreetingConfig and any error encountered.
func (b *GreetingConfigBuilder) Build() (GreetingConfig, error) {
	return b.config, b.err
}

// MergeConfigWithGreeting reads a YAML config file, merges it with the provided greeting,
// and returns the path to a temporary file containing the merged configuration.
func MergeConfigWithGreeting(config_path string, greeting string) (string, error) {
	// Read the YAML config file
	config_data, err := os.ReadFile(config_path)
	if err != nil {
		return "", err
	}

	// Parse YAML into a map
	var config_map map[string]any
	if err := yaml.Unmarshal(config_data, &config_map); err != nil {
		return "", err
	}

	// Add greeting from parameter if not present in YAML
	if _, exists := config_map["greeting"]; !exists {
		config_map["greeting"] = greeting
	}

	// Marshal back to YAML
	merged_data, err := yaml.Marshal(config_map)
	if err != nil {
		return "", err
	}

	// Write to temporary file
	tmp_file, err := os.CreateTemp("", "hello-config-*.yaml")
	if err != nil {
		return "", err
	}
	defer tmp_file.Close()

	if _, err := tmp_file.Write(merged_data); err != nil {
		os.Remove(tmp_file.Name())
		return "", err
	}

	return tmp_file.Name(), nil
}
