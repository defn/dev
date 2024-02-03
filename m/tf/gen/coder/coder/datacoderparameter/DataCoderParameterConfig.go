package datacoderparameter

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type DataCoderParameterConfig struct {
	// Experimental.
	Connection interface{} `field:"optional" json:"connection" yaml:"connection"`
	// Experimental.
	Count interface{} `field:"optional" json:"count" yaml:"count"`
	// Experimental.
	DependsOn *[]cdktf.ITerraformDependable `field:"optional" json:"dependsOn" yaml:"dependsOn"`
	// Experimental.
	ForEach cdktf.ITerraformIterator `field:"optional" json:"forEach" yaml:"forEach"`
	// Experimental.
	Lifecycle *cdktf.TerraformResourceLifecycle `field:"optional" json:"lifecycle" yaml:"lifecycle"`
	// Experimental.
	Provider cdktf.TerraformProvider `field:"optional" json:"provider" yaml:"provider"`
	// Experimental.
	Provisioners *[]interface{} `field:"optional" json:"provisioners" yaml:"provisioners"`
	// The name of the parameter. If this is changed, developers will be re-prompted for a new value.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#name DataCoderParameter#name}
	Name *string `field:"required" json:"name" yaml:"name"`
	// A default value for the parameter.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#default DataCoderParameter#default}
	Default *string `field:"optional" json:"default" yaml:"default"`
	// Describe what this parameter does.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#description DataCoderParameter#description}
	Description *string `field:"optional" json:"description" yaml:"description"`
	// The displayed name of the parameter as it will appear in the interface.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#display_name DataCoderParameter#display_name}
	DisplayName *string `field:"optional" json:"displayName" yaml:"displayName"`
	// The value of an ephemeral parameter will not be preserved between consecutive workspace builds.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#ephemeral DataCoderParameter#ephemeral}
	Ephemeral interface{} `field:"optional" json:"ephemeral" yaml:"ephemeral"`
	// A URL to an icon that will display in the dashboard.
	//
	// View built-in icons here: https://github.com/coder/coder/tree/main/site/static/icon. Use a built-in icon with `data.coder_workspace.me.access_url + "/icon/<path>"`.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#icon DataCoderParameter#icon}
	Icon *string `field:"optional" json:"icon" yaml:"icon"`
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#id DataCoderParameter#id}.
	//
	// Please be aware that the id field is automatically added to all resources in Terraform providers using a Terraform provider SDK version below 2.
	// If you experience problems setting this value it might not be settable. Please take a look at the provider documentation to ensure it should be settable.
	Id *string `field:"optional" json:"id" yaml:"id"`
	// Whether this value can be changed after workspace creation.
	//
	// This can be destructive for values like region, so use with caution!
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#mutable DataCoderParameter#mutable}
	Mutable interface{} `field:"optional" json:"mutable" yaml:"mutable"`
	// option block.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#option DataCoderParameter#option}
	Option interface{} `field:"optional" json:"option" yaml:"option"`
	// The order determines the position of a template parameter in the UI/CLI presentation.
	//
	// The lowest order is shown first and parameters with equal order are sorted by name (ascending order).
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#order DataCoderParameter#order}
	Order *float64 `field:"optional" json:"order" yaml:"order"`
	// The type of this parameter. Must be one of: "number", "string", "bool", or "list(string)".
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#type DataCoderParameter#type}
	Type *string `field:"optional" json:"type" yaml:"type"`
	// validation block.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#validation DataCoderParameter#validation}
	Validation *DataCoderParameterValidation `field:"optional" json:"validation" yaml:"validation"`
}
