package base

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/viper"
)

// Config represents the application configuration structure
type Config struct {
	Global GlobalConfig
	Root   RootConfig
	Api    ApiConfig
	Tui    TuiConfig
	Hello  HelloConfig
}

type GlobalConfig struct {
	// Global configuration accessible to all commands
}

type RootConfig struct {
	// Root command specific configuration
}

type ApiConfig struct {
	Port int `mapstructure:"port"`
}

type TuiConfig struct {
	// TUI command specific configuration
}

type HelloConfig struct {
	// Hello command specific configuration
}

// InitConfig initializes Viper configuration
// Loads configuration from:
// 1. Environment variables with DEFN_ prefix
// 2. $HOME/.defn.yaml (global config)
// 3. ./defn.yaml (current directory config)
// Priority: ENV > ./defn.yaml > $HOME/.defn.yaml
func InitConfig() error {
	// Set environment variable prefix and key replacer
	// DEFN_API_PORT maps to api.port
	viper.SetEnvPrefix("DEFN")
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	viper.AutomaticEnv()

	// Set config file name (without extension)
	viper.SetConfigName("defn")
	viper.SetConfigType("yaml")

	// Add config paths
	// Current directory has higher priority (added last)
	home_dir, err := os.UserHomeDir()
	if err == nil {
		viper.AddConfigPath(home_dir)
	}
	viper.AddConfigPath(".")

	// Read global config from $HOME/.defn.yaml if it exists
	if home_dir != "" {
		global_config := filepath.Join(home_dir, ".defn.yaml")
		if _, err := os.Stat(global_config); err == nil {
			viper.SetConfigFile(global_config)
			if err := viper.ReadInConfig(); err != nil {
				return fmt.Errorf("error reading global config %s: %w", global_config, err)
			}
		}
	}

	// Merge with local config from ./defn.yaml if it exists
	if _, err := os.Stat("defn.yaml"); err == nil {
		viper.SetConfigFile("defn.yaml")
		if err := viper.MergeInConfig(); err != nil {
			return fmt.Errorf("error merging local config: %w", err)
		}
	}

	return nil
}

// GetConfig returns the parsed configuration
func GetConfig() (*Config, error) {
	var config Config
	if err := viper.Unmarshal(&config); err != nil {
		return nil, fmt.Errorf("error unmarshaling config: %w", err)
	}
	return &config, nil
}
