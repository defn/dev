package agent

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type AgentConfig struct {
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
	// The architecture the agent will run on. Must be one of: "amd64", "armv7", "arm64".
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#arch Agent#arch}
	Arch *string `field:"required" json:"arch" yaml:"arch"`
	// The operating system the agent will run on. Must be one of: "linux", "darwin", or "windows".
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#os Agent#os}
	Os *string `field:"required" json:"os" yaml:"os"`
	// The authentication type the agent will use. Must be one of: "token", "google-instance-identity", "aws-instance-identity", "azure-instance-identity".
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#auth Agent#auth}
	Auth *string `field:"optional" json:"auth" yaml:"auth"`
	// Time in seconds until the agent is marked as timed out when a connection with the server cannot be established.
	//
	// A value of zero never marks the agent as timed out.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#connection_timeout Agent#connection_timeout}
	ConnectionTimeout *float64 `field:"optional" json:"connectionTimeout" yaml:"connectionTimeout"`
	// The starting directory when a user creates a shell session. Defaults to $HOME.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#dir Agent#dir}
	Dir *string `field:"optional" json:"dir" yaml:"dir"`
	// display_apps block.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#display_apps Agent#display_apps}
	DisplayApps *AgentDisplayApps `field:"optional" json:"displayApps" yaml:"displayApps"`
	// A mapping of environment variables to set inside the workspace.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#env Agent#env}
	Env *map[string]*string `field:"optional" json:"env" yaml:"env"`
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#id Agent#id}.
	//
	// Please be aware that the id field is automatically added to all resources in Terraform providers using a Terraform provider SDK version below 2.
	// If you experience problems setting this value it might not be settable. Please take a look at the provider documentation to ensure it should be settable.
	Id *string `field:"optional" json:"id" yaml:"id"`
	// This option defines whether or not the user can (by default) login to the workspace before it is ready.
	//
	// Ready means that e.g. the startup_script is done and has exited. When enabled, users may see an incomplete workspace when logging in.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#login_before_ready Agent#login_before_ready}
	LoginBeforeReady interface{} `field:"optional" json:"loginBeforeReady" yaml:"loginBeforeReady"`
	// metadata block.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#metadata Agent#metadata}
	Metadata interface{} `field:"optional" json:"metadata" yaml:"metadata"`
	// The path to a file within the workspace containing a message to display to users when they login via SSH.
	//
	// A typical value would be /etc/motd.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#motd_file Agent#motd_file}
	MotdFile *string `field:"optional" json:"motdFile" yaml:"motdFile"`
	// A script to run before the agent is stopped.
	//
	// The script should exit when it is done to signal that the workspace can be stopped.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#shutdown_script Agent#shutdown_script}
	ShutdownScript *string `field:"optional" json:"shutdownScript" yaml:"shutdownScript"`
	// Time in seconds until the agent lifecycle status is marked as timed out during shutdown, this happens when the shutdown script has not completed (exited) in the given time.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#shutdown_script_timeout Agent#shutdown_script_timeout}
	ShutdownScriptTimeout *float64 `field:"optional" json:"shutdownScriptTimeout" yaml:"shutdownScriptTimeout"`
	// A script to run after the agent starts.
	//
	// The script should exit when it is done to signal that the agent is ready.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#startup_script Agent#startup_script}
	StartupScript *string `field:"optional" json:"startupScript" yaml:"startupScript"`
	// This option sets the behavior of the `startup_script`.
	//
	// When set to "blocking", the startup_script must exit before the workspace is ready. When set to "non-blocking", the startup_script may run in the background and the workspace will be ready immediately. Default is "non-blocking", although "blocking" is recommended.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#startup_script_behavior Agent#startup_script_behavior}
	StartupScriptBehavior *string `field:"optional" json:"startupScriptBehavior" yaml:"startupScriptBehavior"`
	// Time in seconds until the agent lifecycle status is marked as timed out during start, this happens when the startup script has not completed (exited) in the given time.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#startup_script_timeout Agent#startup_script_timeout}
	StartupScriptTimeout *float64 `field:"optional" json:"startupScriptTimeout" yaml:"startupScriptTimeout"`
	// A URL to a document with instructions for troubleshooting problems with the agent.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent#troubleshooting_url Agent#troubleshooting_url}
	TroubleshootingUrl *string `field:"optional" json:"troubleshootingUrl" yaml:"troubleshootingUrl"`
}
