package agent

type AgentDisplayApps struct {
	// Display the port-forwarding helper button in the agent bar.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#port_forwarding_helper Agent#port_forwarding_helper}
	PortForwardingHelper interface{} `field:"optional" json:"portForwardingHelper" yaml:"portForwardingHelper"`
	// Display the SSH helper button in the agent bar.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#ssh_helper Agent#ssh_helper}
	SshHelper interface{} `field:"optional" json:"sshHelper" yaml:"sshHelper"`
	// Display the VSCode Desktop app in the agent bar.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#vscode Agent#vscode}
	Vscode interface{} `field:"optional" json:"vscode" yaml:"vscode"`
	// Display the VSCode Insiders app in the agent bar.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#vscode_insiders Agent#vscode_insiders}
	VscodeInsiders interface{} `field:"optional" json:"vscodeInsiders" yaml:"vscodeInsiders"`
	// Display the web terminal app in the agent bar.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#web_terminal Agent#web_terminal}
	WebTerminal interface{} `field:"optional" json:"webTerminal" yaml:"webTerminal"`
}
