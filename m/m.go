package main

import (
	"embed"
	"fmt"
	"io"
	"io/fs"
	"strings"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
)

//go:embed use/*
var defn_dev_use embed.FS

func main() {
	overlay := make(map[string]load.Source)

	if err := BuildOverlayFromFS(&overlay, defn_dev_use, "/use"); err != nil {
		panic(err)
	}

	val, err := BuildValueFromOverlay(&overlay, []string{"."})
	if err != nil {
		panic(err)
	}

	fmt.Printf("%s\n", val)
}

func BuildValueFromOverlay(overlay *map[string]load.Source, instanceNames []string) (cue.Value, error) {
	cfg := &load.Config{
		Overlay: *overlay,
		Dir:     "/",
	}

	instances := load.Instances(instanceNames, cfg)

	if len(instances) == 0 {
		return cue.Value{}, fmt.Errorf("no instances loaded")
	}
	inst := instances[0]

	if inst.Err != nil {
		return cue.Value{}, inst.Err
	}

	ctx := cuecontext.New()

	value := ctx.BuildInstance(inst)

	if value.Err() != nil {
		return cue.Value{}, value.Err()
	}

	return value, nil
}

func BuildOverlayFromFS(overlay *map[string]load.Source, fsys fs.FS, prefix string) error {
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
		relPath := strings.TrimPrefix(absPath, prefix)
		src := load.FromBytes(content)

		(*overlay)[relPath] = src

		return nil
	})

	return err
}
