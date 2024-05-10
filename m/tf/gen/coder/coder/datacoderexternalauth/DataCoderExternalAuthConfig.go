package datacoderexternalauth

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type DataCoderExternalAuthConfig struct {
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
	// The ID of a configured external auth provider set up in your Coder deployment.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/data-sources/external_auth#id DataCoderExternalAuth#id}
	//
	// Please be aware that the id field is automatically added to all resources in Terraform providers using a Terraform provider SDK version below 2.
	// If you experience problems setting this value it might not be settable. Please take a look at the provider documentation to ensure it should be settable.
	Id *string `field:"required" json:"id" yaml:"id"`
	// Authenticating with the external auth provider is not required, and can be skipped by users when creating or updating workspaces.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/data-sources/external_auth#optional DataCoderExternalAuth#optional}
	Optional interface{} `field:"optional" json:"optional" yaml:"optional"`
}

