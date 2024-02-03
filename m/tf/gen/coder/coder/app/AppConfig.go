package app

import (
	"github.com/hashicorp/terraform-cdk-go/cdktf"
)

type AppConfig struct {
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
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#agent_id App#agent_id}
	AgentId *string `field:"required" json:"agentId" yaml:"agentId"`
	// A hostname-friendly name for the app.
	//
	// This is used in URLs to access the app. May contain alphanumerics and hyphens. Cannot start/end with a hyphen or contain two consecutive hyphens.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#slug App#slug}
	Slug *string `field:"required" json:"slug" yaml:"slug"`
	// A command to run in a terminal opening this app.
	//
	// In the web, this will open in a new tab. In the CLI, this will SSH and execute the command. Either "command" or "url" may be specified, but not both.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#command App#command}
	Command *string `field:"optional" json:"command" yaml:"command"`
	// A display name to identify the app. Defaults to the slug.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#display_name App#display_name}
	DisplayName *string `field:"optional" json:"displayName" yaml:"displayName"`
	// Specifies whether "url" is opened on the client machine instead of proxied through the workspace.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#external App#external}
	External interface{} `field:"optional" json:"external" yaml:"external"`
	// healthcheck block.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#healthcheck App#healthcheck}
	Healthcheck *AppHealthcheck `field:"optional" json:"healthcheck" yaml:"healthcheck"`
	// A URL to an icon that will display in the dashboard.
	//
	// View built-in icons here: https://github.com/coder/coder/tree/main/site/static/icon. Use a built-in icon with `data.coder_workspace.me.access_url + "/icon/<path>"`.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#icon App#icon}
	Icon *string `field:"optional" json:"icon" yaml:"icon"`
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#id App#id}.
	//
	// Please be aware that the id field is automatically added to all resources in Terraform providers using a Terraform provider SDK version below 2.
	// If you experience problems setting this value it might not be settable. Please take a look at the provider documentation to ensure it should be settable.
	Id *string `field:"optional" json:"id" yaml:"id"`
	// A display name to identify the app.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#name App#name}
	Name *string `field:"optional" json:"name" yaml:"name"`
	// Specifies whether the URL will be accessed via a relative path or wildcard.
	//
	// Use if wildcard routing is unavailable. Defaults to true.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#relative_path App#relative_path}
	RelativePath interface{} `field:"optional" json:"relativePath" yaml:"relativePath"`
	// Determines the "level" which the application is shared at.
	//
	// Valid levels are "owner" (default), "authenticated" and "public". Level "owner" disables sharing on the app, so only the workspace owner can access it. Level "authenticated" shares the app with all authenticated users. Level "public" shares it with any user, including unauthenticated users. Permitted application sharing levels can be configured site-wide via a flag on `coder server` (Enterprise only).
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#share App#share}
	Share *string `field:"optional" json:"share" yaml:"share"`
	// Determines whether the app will be accessed via it's own subdomain or whether it will be accessed via a path on Coder.
	//
	// If wildcards have not been setup by the administrator then apps with "subdomain" set to true will not be accessible. Defaults to false.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#subdomain App#subdomain}
	Subdomain interface{} `field:"optional" json:"subdomain" yaml:"subdomain"`
	// A URL to be proxied to from inside the workspace.
	//
	// This should be of the form "http://localhost:PORT[/SUBPATH]". Either "command" or "url" may be specified, but not both.
	//
	// Docs at Terraform Registry: {@link https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app#url App#url}
	Url *string `field:"optional" json:"url" yaml:"url"`
}
