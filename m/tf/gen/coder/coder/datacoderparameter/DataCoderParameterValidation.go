package datacoderparameter

type DataCoderParameterValidation struct {
	// An error message to display if the value doesn't match the provided regex.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#error DataCoderParameter#error}
	Error *string `field:"optional" json:"error" yaml:"error"`
	// The maximum of a number parameter.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#max DataCoderParameter#max}
	Max *float64 `field:"optional" json:"max" yaml:"max"`
	// The minimum of a number parameter.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#min DataCoderParameter#min}
	Min *float64 `field:"optional" json:"min" yaml:"min"`
	// Number monotonicity, either increasing or decreasing.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#monotonic DataCoderParameter#monotonic}
	Monotonic *string `field:"optional" json:"monotonic" yaml:"monotonic"`
	// A regex for the input parameter to match against.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter#regex DataCoderParameter#regex}
	Regex *string `field:"optional" json:"regex" yaml:"regex"`
}
