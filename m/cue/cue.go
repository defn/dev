// Package cue provides utilities for validating configuration files (YAML/JSON)
// against CUE schemas using an in-memory overlay filesystem.
//
// CUE (Configure Unify Execute) is a data validation language. This package allows
// you to validate YAML/JSON config files against CUE schema definitions without
// needing files on disk - everything happens in memory.
//
// # Basic Usage Example
//
//	// Create an overlay filesystem
//	overlay := cue.NewOverlay()
//
//	// Validate a config file against a schema
//	err := overlay.ValidateConfig(
//	    "module: \"example.com/config\"",  // Module definition
//	    "myschema",                         // Package name
//	    "/path/to/config.yaml",             // Config file to validate
//	    "#ConfigSchema",                    // Schema definition path in CUE
//	    "import \"myschema\"",              // CUE import statement
//	    schemaFilesFS,                      // fs.FS with schema files
//	)
//
// # Key Concepts
//
//   - Overlay: An in-memory filesystem that holds CUE files
//   - Schema: CUE definitions that describe valid configuration structure
//   - Unify: CUE's operation to merge and validate values against schemas
//   - Concrete: A CUE value with all required fields filled (no type-only constraints)
package cue

import (
	"fmt"
	"io"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"strings"
	"testing/fstest"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
	"cuelang.org/go/encoding/json"
	"cuelang.org/go/encoding/yaml"
)

const (
	// Standard CUE module paths following CUE's filesystem layout conventions
	config_prefix = "/config"             // Prefix for config file paths
	module_path   = "/cue.mod/module.cue" // Path to the CUE module definition file
	pkg_prefix    = "/cue.mod/pkg"        // Prefix for CUE package installations
)

// CueOverlayFS provides an in-memory overlay filesystem for CUE schema validation.
// It manages CUE schemas and configuration files in memory, allowing validation
// without requiring files to exist on disk.
//
// # Fields
//
//   - CueContext: The CUE runtime context used for building and evaluating CUE values
//   - ContentFS: Map of virtual file paths to file contents (path -> bytes)
//
// This allows you to create a virtual CUE workspace entirely in memory, which is
// useful for testing, dynamic schema validation, and avoiding filesystem I/O.
type CueOverlayFS struct {
	CueContext *cue.Context      // CUE runtime for building/evaluating values
	ContentFS  map[string][]byte // Virtual filesystem: path -> file contents
}

// NewOverlay creates a new CueOverlayFS with an empty content map and fresh CUE context.
func NewOverlay() CueOverlayFS {
	return CueOverlayFS{
		CueContext: cuecontext.New(),
		ContentFS:  make(map[string][]byte),
	}
}

// ValidateConfig validates a configuration file against a CUE schema.
// It loads the schema from the provided fs.FS, reads the config file from disk,
// and validates that the config conforms to the schema at the specified label path.
//
// Parameters:
//   - module: CUE module definition content
//   - package_name: package name for the schema (installed at cue.mod/pkg/{package_name})
//   - config_file_path: path to the configuration file to validate (YAML or JSON)
//   - schema_label: CUE path to the schema definition (e.g., "#Config")
//   - config: CUE config content
//   - schema_files: filesystem containing the CUE schema files
func (overlay CueOverlayFS) ValidateConfig(module string, package_name string, config_file_path string, schema_label string, config string, schema_files fs.FS) error {
	// Step 1: Build the CUE schema from the overlay filesystem
	built_schema, err := overlay.BuildSchema(package_name, module, config, schema_files)
	if err != nil {
		return err
	}

	// Step 2: Look up the schema definition at the specified path (e.g., "#Config")
	// and validate that the schema itself is well-formed
	schema_definition := built_schema.LookupPath(cue.ParsePath(schema_label))
	if err := schema_definition.Validate(); err != nil {
		return err
	}

	// Step 3: Read the actual config file (YAML/JSON) from disk
	file_extension := filepath.Ext(config_file_path)
	// Example: config_prefix + ".yaml" → "/config.yaml"
	//          config_prefix + ".json" → "/config.json"
	input_config_path := config_prefix + file_extension
	config_data, err := os.ReadFile(config_file_path)
	if err != nil {
		return err
	}
	overlay.ContentFS[input_config_path] = config_data

	// Step 4: Parse the config file into a CUE value
	config_value, err := overlay.ParseConfigData(input_config_path, config_data)
	if err != nil {
		return err
	}
	if err := config_value.Err(); err != nil {
		return err
	}

	// Step 5: Unify (merge) the config with the schema definition
	// In CUE, "unify" means combining values and checking they're compatible
	unified_config := config_value.Unify(schema_definition)

	// Step 6: Validate the unified result is "concrete" (has all required values filled in)
	// Concrete(true) ensures all fields have actual values, not just type constraints
	if err := unified_config.Validate(cue.Concrete(true)); err != nil {
		return err
	}

	return nil
}

// BuildSchema sets up a CUE module structure in the overlay filesystem and builds it.
// It installs the schema package, module definition, and config, then returns
// the unified CUE value.
//
// Parameters:
//   - package_name: package name for the schema
//   - module: CUE module definition content
//   - config: CUE config content
//   - schema_files: filesystem containing the CUE schema files
func (overlay CueOverlayFS) BuildSchema(package_name string, module string, config string, schema_files fs.FS) (cue.Value, error) {
	// Install schema files into the virtual CUE package directory (if provided)
	// Example: pkg_prefix + "/" + "myschema" → "/cue.mod/pkg/myschema"
	if schema_files != nil {
		overlay.AddSchema(pkg_prefix+"/"+package_name, schema_files)
	}

	// Add the module definition (declares the CUE module name and dependencies)
	// Example: module_path = "/cue.mod/module.cue"
	overlay.AddFile(module_path, module)

	// Add the config CUE file (may import and use the schema)
	// Example: config_prefix + ".cue" → "/config.cue"
	overlay.AddFile(config_prefix+".cue", config)

	// Load the CUE instance from the current directory (".") using our overlay filesystem
	load_expressions := []string{"."}
	loaded_instance := load.Instances(load_expressions, overlay.CreateLoadConfig())[0]
	if loaded_instance.Err != nil {
		return cue.Value{}, loaded_instance.Err
	}

	// Build a CUE value from the loaded instance
	// This compiles and evaluates all CUE files in the overlay
	built_value := overlay.CueContext.BuildInstance(loaded_instance)
	if built_value.Err() != nil {
		return cue.Value{}, built_value.Err()
	}

	return built_value, nil
}

// ParseConfigData parses configuration data (YAML or JSON) and returns a CUE value.
// The file extension of the config_path determines which parser to use.
func (overlay CueOverlayFS) ParseConfigData(config_path string, data []byte) (cue.Value, error) {
	ext := filepath.Ext(config_path)
	switch ext {
	case ".yaml":
		config_file, err := yaml.Extract(filepath.Base(config_path), data)
		if err != nil {
			return cue.Value{}, err
		}
		return overlay.CueContext.BuildFile(config_file), nil
	case ".json":
		config_file, err := json.Extract(filepath.Base(config_path), data)
		if err != nil {
			return cue.Value{}, err
		}
		return overlay.CueContext.BuildExpr(config_file), nil
	default:
		return cue.Value{}, fmt.Errorf("unknown extension: %s", ext)
	}
}

// CreateLoadConfig creates a load.Config for the CUE loader with the overlay filesystem.
// It converts the in-memory ContentFS map into load.Source entries that CUE can read.
// This allows CUE to load files from memory instead of disk.
func (overlay CueOverlayFS) CreateLoadConfig() *load.Config {
	// Convert our byte map to CUE's load.Source format
	overlay_sources := make(map[string]load.Source)
	for file_path, file_data := range overlay.ContentFS {
		overlay_sources[file_path] = load.FromBytes(file_data)
	}

	// Return a load.Config that uses our virtual filesystem overlay
	// Dir: "/" means the root of our virtual filesystem
	return &load.Config{Overlay: overlay_sources, Dir: "/"}
}

// AddSchema adds all files from the provided filesystem to the overlay at the given prefix.
// Files are read from the schema filesystem and stored in memory with their paths
// prefixed by the specified prefix string. All regular files are normalized to mode 0600.
//
// This method creates an intermediate MapFS to normalize file modes before adding to the overlay.
// Use this for adding CUE schema packages to the overlay filesystem.
func (overlay CueOverlayFS) AddSchema(path_prefix string, schema_filesystem fs.FS) error {
	// Create a temporary MapFS to normalize file modes to 0600
	temp_filesystem := fstest.MapFS{}

	err := fs.WalkDir(schema_filesystem, ".", func(entry_path string, dir_entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		// Skip directories, only process files
		if dir_entry.IsDir() {
			return nil
		}

		// Read file content
		file_data, err := fs.ReadFile(schema_filesystem, entry_path)
		if err != nil {
			return err
		}

		// Build the full path with prefix
		// Example: path.Join("/cue.mod/pkg/myschema", "schema.cue") → "/cue.mod/pkg/myschema/schema.cue"
		full_path := path.Join(path_prefix, entry_path)

		// Strip leading "/" for MapFS (expects relative paths, not absolute)
		// This prevents a stack overflow: MapFS with absolute paths can't resolve "."
		// which causes fs.WalkDir to enter an infinite loop
		// Example: "/cue.mod/pkg/myschema/schema.cue" → "cue.mod/pkg/myschema/schema.cue"
		map_path := strings.TrimPrefix(full_path, "/")

		// Normalize all files to 0600 mode in the overlay
		temp_filesystem[map_path] = &fstest.MapFile{
			Data: file_data,
			Mode: fs.FileMode(0o600),
		}
		return nil
	})

	if err != nil {
		return err
	}

	// Add the temp filesystem to our overlay
	overlay.AddFilesystem("", temp_filesystem)
	return nil
}

// AddFile adds a single file with the given path and string content to the overlay.
// This is useful for adding individual CUE configuration files or module definitions.
//
// Example: overlay.AddFile("/config.cue", "package main\nvalue: 42")
//
//	→ ContentFS["/config.cue"] = []byte("package main\nvalue: 42")
func (overlay CueOverlayFS) AddFile(file_path string, content string) {
	overlay.ContentFS[file_path] = []byte(content)
}

// AddFilesystem adds all files from the provided filesystem directly to the overlay at the given prefix.
// This is a lower-level method that directly populates ContentFS without intermediate steps.
// Files are added as raw byte content without mode information (ContentFS doesn't store modes).
//
// Use this for direct bulk copying of files. AddSchema() is a higher-level wrapper that
// creates a MapFS intermediate before calling this method.
func (overlay CueOverlayFS) AddFilesystem(path_prefix string, source_filesystem fs.FS) error {
	err := fs.WalkDir(source_filesystem, ".", func(entry_path string, dir_entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		// Skip non-regular files (directories, symlinks, etc.)
		if !dir_entry.Type().IsRegular() {
			return nil
		}

		// Open and read the file
		file_handle, err := source_filesystem.Open(entry_path)
		if err != nil {
			return err
		}
		defer file_handle.Close()

		file_data, err := io.ReadAll(file_handle)
		if err != nil {
			return err
		}

		// Build full path and ensure it starts with "/"
		// Example: path.Join("", "file.cue") → "file.cue" then "/" + "file.cue" → "/file.cue"
		//          path.Join("/schemas", "types.cue") → "/schemas/types.cue"
		full_path := path.Join(path_prefix, entry_path)
		if !strings.HasPrefix(full_path, "/") {
			full_path = "/" + full_path
		}

		// Store in the overlay
		overlay.ContentFS[full_path] = file_data

		return nil
	})

	return err
}
