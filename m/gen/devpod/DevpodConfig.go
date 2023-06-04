package devpod

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type DevpodConfig struct {
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Providers *[]interface{} `field:"optional" json:"providers" yaml:"providers"`
	// Experimental.
	SkipAssetCreationFromLocalModules *bool `field:"optional" json:"skipAssetCreationFromLocalModules" yaml:"skipAssetCreationFromLocalModules"`
	// undefined.
	Envs interface{} `field:"optional" json:"envs" yaml:"envs"`
	// undefined.
	Repo interface{} `field:"optional" json:"repo" yaml:"repo"`
}

