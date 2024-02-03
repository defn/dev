package script

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type ScriptConfig struct {
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
	// The "id" property of a "coder_agent" resource to associate with.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#agent_id Script#agent_id}
	AgentId *string `field:"required" json:"agentId" yaml:"agentId"`
	// The display name of the script to display logs in the dashboard.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#display_name Script#display_name}
	DisplayName *string `field:"required" json:"displayName" yaml:"displayName"`
	// The script to run.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#script Script#script}
	Script *string `field:"required" json:"script" yaml:"script"`
	// The cron schedule to run the script on. This is a cron expression.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#cron Script#cron}
	Cron *string `field:"optional" json:"cron" yaml:"cron"`
	// A URL to an icon that will display in the dashboard.
	//
	// View built-in icons here: https://github.com/coder/coder/tree/main/site/static/icon. Use a built-in icon with `data.coder_workspace.me.access_url + "/icon/<path>"`.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#icon Script#icon}
	Icon *string `field:"optional" json:"icon" yaml:"icon"`
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#id Script#id}.
	//
	// Please be aware that the id field is automatically added to all resources in Terraform providers using a Terraform provider SDK version below 2.
	// If you experience problems setting this value it might not be settable. Please take a look at the provider documentation to ensure it should be settable.
	Id *string `field:"optional" json:"id" yaml:"id"`
	// The path of a file to write the logs to. If relative, it will be appended to tmp.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#log_path Script#log_path}
	LogPath *string `field:"optional" json:"logPath" yaml:"logPath"`
	// This option defines whether or not the script should run when the agent starts.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#run_on_start Script#run_on_start}
	RunOnStart interface{} `field:"optional" json:"runOnStart" yaml:"runOnStart"`
	// This option defines whether or not the script should run when the agent stops.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#run_on_stop Script#run_on_stop}
	RunOnStop interface{} `field:"optional" json:"runOnStop" yaml:"runOnStop"`
	// This option defines whether or not the user can (by default) login to the workspace before this script completes running on start.
	//
	// When enabled, users may see an incomplete workspace when logging in.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#start_blocks_login Script#start_blocks_login}
	StartBlocksLogin interface{} `field:"optional" json:"startBlocksLogin" yaml:"startBlocksLogin"`
	// Time in seconds until the agent lifecycle status is marked as timed out, this happens when the script has not completed (exited) in the given time.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/script#timeout Script#timeout}
	Timeout *float64 `field:"optional" json:"timeout" yaml:"timeout"`
}
