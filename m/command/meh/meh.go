package command

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sync"

	"github.com/spf13/cobra"

	root "github.com/defn/dev/m/command/root"
)

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "meh [regions...]",
		Short: "Query AWS resources across regions",
		Long: `Query AWS EC2 instances and EBS volumes across multiple regions.
If no regions are specified, all AWS regions are queried.`,
		Run: func(cmd *cobra.Command, args []string) {
			if err := runMeh(args); err != nil {
				fmt.Fprintf(os.Stderr, "Error: %v\n", err)
				os.Exit(1)
			}
		},
	})
}

type queryResult struct {
	region string
	typ    string
	data   []byte
	err    error
}

func runMeh(regions []string) error {
	// Get regions if not specified
	if len(regions) == 0 {
		var err error
		regions, err = getAllRegions()
		if err != nil {
			return fmt.Errorf("failed to get regions: %w", err)
		}
	}

	// Calculate concurrency limit
	n := runtime.NumCPU() * 2
	if n < 16 {
		n = 16
	}

	// Create temporary directory
	tmpDir, err := os.MkdirTemp(os.Getenv("TEMPDIR"), "meh-*")
	if err != nil {
		tmpDir, err = os.MkdirTemp("/tmp", "meh-*")
		if err != nil {
			return fmt.Errorf("failed to create temp dir: %w", err)
		}
	}
	defer os.RemoveAll(tmpDir)

	// Query resources with concurrency control
	results := make(chan queryResult, len(regions)*2)
	semaphore := make(chan struct{}, n)
	var wg sync.WaitGroup

	for _, region := range regions {
		// Query EC2 instances
		wg.Add(1)
		go func(r string) {
			defer wg.Done()
			semaphore <- struct{}{}
			defer func() { <-semaphore }()
			queryEC2Instances(r, results)
		}(region)

		// Query EBS volumes
		wg.Add(1)
		go func(r string) {
			defer wg.Done()
			semaphore <- struct{}{}
			defer func() { <-semaphore }()
			queryEBSVolumes(r, results)
		}(region)
	}

	// Close results channel when all queries complete
	go func() {
		wg.Wait()
		close(results)
	}()

	// Write results to temporary files
	for result := range results {
		if result.err != nil {
			fmt.Fprintf(os.Stderr, "Warning: %v\n", result.err)
			continue
		}

		filename := filepath.Join(tmpDir, fmt.Sprintf("%s-%s.json", result.typ, result.region))
		if err := os.WriteFile(filename, result.data, 0644); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: failed to write %s: %v\n", filename, err)
		}
	}

	// Merge all JSON files
	if err := mergeResults(tmpDir); err != nil {
		// On error, drop into interactive shell for debugging
		fmt.Fprintf(os.Stderr, "Error merging results: %v\n", err)
		fmt.Fprintf(os.Stderr, "Dropping into shell in %s for debugging...\n", tmpDir)
		shell := exec.Command("bash", "-il")
		shell.Dir = tmpDir
		shell.Stdin = os.Stdin
		shell.Stdout = os.Stdout
		shell.Stderr = os.Stderr
		return shell.Run()
	}

	return nil
}

func getAllRegions() ([]string, error) {
	cmd := exec.Command("aws", "ec2", "describe-regions", "--query", "Regions[].RegionName", "--output", "json")
	output, err := cmd.Output()
	if err != nil {
		return nil, fmt.Errorf("failed to describe regions: %w", err)
	}

	var regions []string
	if err := json.Unmarshal(output, &regions); err != nil {
		return nil, fmt.Errorf("failed to parse regions: %w", err)
	}

	return regions, nil
}

func queryEC2Instances(region string, results chan<- queryResult) {
	ctx := context.Background()
	cmd := exec.CommandContext(ctx, "aws", "--region", region, "ec2", "describe-instances")
	output, err := cmd.Output()
	if err != nil {
		results <- queryResult{region: region, typ: "ec2-instance", err: fmt.Errorf("failed to query EC2 instances in %s: %w", region, err)}
		return
	}

	// Parse and transform the output
	var data map[string]interface{}
	if err := json.Unmarshal(output, &data); err != nil {
		results <- queryResult{region: region, typ: "ec2-instance", err: fmt.Errorf("failed to parse EC2 data from %s: %w", region, err)}
		return
	}

	transformed := transformEC2Instances(data, region, "ec2-instance")
	jsonData, err := json.Marshal(transformed)
	if err != nil {
		results <- queryResult{region: region, typ: "ec2-instance", err: fmt.Errorf("failed to marshal EC2 data from %s: %w", region, err)}
		return
	}

	results <- queryResult{region: region, typ: "ec2-instance", data: jsonData}
}

func queryEBSVolumes(region string, results chan<- queryResult) {
	ctx := context.Background()
	cmd := exec.CommandContext(ctx, "aws", "--region", region, "ec2", "describe-volumes")
	output, err := cmd.Output()
	if err != nil {
		results <- queryResult{region: region, typ: "ec2-volume", err: fmt.Errorf("failed to query EBS volumes in %s: %w", region, err)}
		return
	}

	// Parse and transform the output
	var data map[string]interface{}
	if err := json.Unmarshal(output, &data); err != nil {
		results <- queryResult{region: region, typ: "ec2-volume", err: fmt.Errorf("failed to parse EBS data from %s: %w", region, err)}
		return
	}

	transformed := transformEBSVolumes(data, region, "ec2-volume")
	jsonData, err := json.Marshal(transformed)
	if err != nil {
		results <- queryResult{region: region, typ: "ec2-volume", err: fmt.Errorf("failed to marshal EBS data from %s: %w", region, err)}
		return
	}

	results <- queryResult{region: region, typ: "ec2-volume", data: jsonData}
}

func transformEC2Instances(data map[string]interface{}, region, typ string) map[string]interface{} {
	result := make(map[string]interface{})
	regionData := make(map[string]interface{})
	typeData := make(map[string]interface{})

	if reservations, ok := data["Reservations"].([]interface{}); ok {
		for _, reservation := range reservations {
			if resMap, ok := reservation.(map[string]interface{}); ok {
				if instances, ok := resMap["Instances"].([]interface{}); ok {
					for _, instance := range instances {
						if instMap, ok := instance.(map[string]interface{}); ok {
							if instanceID, ok := instMap["InstanceId"].(string); ok {
								typeData[instanceID] = instMap
							}
						}
					}
				}
			}
		}
	}

	regionData[typ] = typeData
	result[region] = regionData
	return result
}

func transformEBSVolumes(data map[string]interface{}, region, typ string) map[string]interface{} {
	result := make(map[string]interface{})
	regionData := make(map[string]interface{})
	typeData := make(map[string]interface{})

	if volumes, ok := data["Volumes"].([]interface{}); ok {
		for _, volume := range volumes {
			if volMap, ok := volume.(map[string]interface{}); ok {
				if volumeID, ok := volMap["VolumeId"].(string); ok {
					typeData[volumeID] = volMap
				}
			}
		}
	}

	regionData[typ] = typeData
	result[region] = regionData
	return result
}

func mergeResults(tmpDir string) error {
	// Find all JSON files
	pattern := filepath.Join(tmpDir, "*.json")
	files, err := filepath.Glob(pattern)
	if err != nil {
		return fmt.Errorf("failed to glob files: %w", err)
	}

	if len(files) == 0 {
		return fmt.Errorf("no result files found")
	}

	// Merge all results
	merged := make(map[string]interface{})

	for _, file := range files {
		data, err := os.ReadFile(file)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Warning: failed to read %s: %v\n", file, err)
			continue
		}

		var fileData map[string]interface{}
		if err := json.Unmarshal(data, &fileData); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: failed to parse %s: %v\n", file, err)
			continue
		}

		// Deep merge
		for region, regionData := range fileData {
			if _, exists := merged[region]; !exists {
				merged[region] = make(map[string]interface{})
			}

			mergedRegion := merged[region].(map[string]interface{})
			if regionMap, ok := regionData.(map[string]interface{}); ok {
				for typ, typeData := range regionMap {
					if _, exists := mergedRegion[typ]; !exists {
						mergedRegion[typ] = make(map[string]interface{})
					}

					mergedType := mergedRegion[typ].(map[string]interface{})
					if typeMap, ok := typeData.(map[string]interface{}); ok {
						for id, resource := range typeMap {
							mergedType[id] = resource
						}
					}
				}
			}
		}
	}

	// Output final result
	output := map[string]interface{}{
		"aws": merged,
	}

	jsonOutput, err := json.MarshalIndent(output, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal output: %w", err)
	}

	fmt.Println(string(jsonOutput))
	return nil
}
