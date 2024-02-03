package metadata

type MetadataItem struct {
	// The key of this metadata item.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/metadata#key Metadata#key}
	Key *string `field:"required" json:"key" yaml:"key"`
	// Set to "true" to for items such as API keys whose values should be hidden from view by default.
	//
	// Note that this does not prevent metadata from being retrieved using the API, so it is not suitable for secrets that should not be exposed to workspace users.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/metadata#sensitive Metadata#sensitive}
	Sensitive interface{} `field:"optional" json:"sensitive" yaml:"sensitive"`
	// The value of this metadata item.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/metadata#value Metadata#value}
	Value *string `field:"optional" json:"value" yaml:"value"`
}
