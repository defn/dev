package main

import (
	"embed"
	"fmt"
	"io"
	"io/fs"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/load"
)

// utilities
func BuildValueFromOverlay(ctx *cue.Context, overfs embed.FS, prefix string) (cue.Value, error) {
	overlay := make(map[string]load.Source)

	if err := BuildOverlayFromFS(&overlay, overfs); err != nil {
		panic(err)
	}

	cfg := &load.Config{
		Overlay: overlay,
		Dir:     prefix,
	}

	instanceNames := []string{"."}

	instances := load.Instances(instanceNames, cfg)

	if len(instances) == 0 {
		return cue.Value{}, fmt.Errorf("no instances loaded")
	}
	inst := instances[0]

	if inst.Err != nil {
		return cue.Value{}, inst.Err
	}

	value := ctx.BuildInstance(inst)

	if value.Err() != nil {
		return cue.Value{}, value.Err()
	}

	return value, nil
}

func BuildOverlayFromFS(overlay *map[string]load.Source, fsys fs.FS) error {
	err := fs.WalkDir(fsys, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.Type().IsRegular() {
			return nil
		}

		file, err := fsys.Open(path)
		if err != nil {
			return fmt.Errorf("open %s: %w", path, err)
		}
		defer file.Close()

		content, err := io.ReadAll(file)
		if err != nil {
			return fmt.Errorf("read %s: %w", path, err)
		}

		absPath := "/" + path
		src := load.FromBytes(content)

		(*overlay)[absPath] = src

		return nil
	})

	return err
}
