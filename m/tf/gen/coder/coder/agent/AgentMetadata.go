package agent


type AgentMetadata struct {
	// The interval in seconds at which to refresh this metadata item.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/resources/agent#interval Agent#interval}
	Interval *float64 `field:"required" json:"interval" yaml:"interval"`
	// The key of this metadata item.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/resources/agent#key Agent#key}
	Key *string `field:"required" json:"key" yaml:"key"`
	// The script that retrieves the value of this metadata item.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/resources/agent#script Agent#script}
	Script *string `field:"required" json:"script" yaml:"script"`
	// The user-facing name of this value.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/resources/agent#display_name Agent#display_name}
	DisplayName *string `field:"optional" json:"displayName" yaml:"displayName"`
	// The order determines the position of agent metadata in the UI presentation.
	//
	// The lowest order is shown first and metadata with equal order are sorted by key (ascending order).
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/resources/agent#order Agent#order}
	Order *float64 `field:"optional" json:"order" yaml:"order"`
	// The maximum time the command is allowed to run in seconds.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.21.0/docs/resources/agent#timeout Agent#timeout}
	Timeout *float64 `field:"optional" json:"timeout" yaml:"timeout"`
}

