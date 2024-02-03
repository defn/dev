package provider

type CoderProviderConfig struct {
	// Alias name.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs#alias CoderProvider#alias}
	Alias *string `field:"optional" json:"alias" yaml:"alias"`
	// Feature: use managed Terraform variables.
	//
	// The feature flag is not used anymore as Terraform variables are now exclusively utilized for template-wide variables.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs#feature_use_managed_variables CoderProvider#feature_use_managed_variables}
	FeatureUseManagedVariables interface{} `field:"optional" json:"featureUseManagedVariables" yaml:"featureUseManagedVariables"`
	// The URL to access Coder.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs#url CoderProvider#url}
	Url *string `field:"optional" json:"url" yaml:"url"`
}
