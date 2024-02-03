package datacoderparameter

type DataCoderParameterOption struct {
	// The display name of this value in the UI.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#name DataCoderParameter#name}
	Name *string `field:"required" json:"name" yaml:"name"`
	// The value of this option set on the parameter if selected.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#value DataCoderParameter#value}
	Value *string `field:"required" json:"value" yaml:"value"`
	// Describe what selecting this value does.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#description DataCoderParameter#description}
	Description *string `field:"optional" json:"description" yaml:"description"`
	// A URL to an icon that will display in the dashboard.
	//
	// View built-in icons here: https://github.com/coder/coder/tree/main/site/static/icon. Use a built-in icon with `data.coder_workspace.me.access_url + "/icon/<path>"`.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#icon DataCoderParameter#icon}
	Icon *string `field:"optional" json:"icon" yaml:"icon"`
}
