package tf

import (
	_ "embed"

	"fmt"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	null_provider "github.com/cdktf/cdktf-provider-null-go/null/v10/provider"
	null_resource "github.com/cdktf/cdktf-provider-null-go/null/v10/resource"

	coder_provider "github.com/defn/dev/m/tf/gen/coder/coder/provider"

	"github.com/defn/dev/m/tf/gen/coder/coder/agent"
	"github.com/defn/dev/m/tf/gen/coder/coder/app"
	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderparameter"
	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderworkspace"

	"github.com/defn/dev/m/tf/gen/coderlogin"

	infra "github.com/defn/dev/m/command/infra"
)

func CoderDefnSshStack(scope constructs.Construct, site *infra.AwsProps, name string) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, infra.Js(name))

	cdktf.NewLocalBackend(stack, &cdktf.LocalBackendConfig{})

	paramHomedir := datacoderparameter.NewDataCoderParameter(stack, infra.Js("homedir"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("/home/ubuntu/m"),
		Description: infra.Js("home directory"),
		DisplayName: infra.Js("HOME dir"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("homedir"),
		Type:        infra.Js("string"),
		Mutable:     infra.Jstrue(),
	})

	paramCommand := datacoderparameter.NewDataCoderParameter(stack, infra.Js("command"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("make coder-ssh-linux"),
		Description: infra.Js("Remote command"),
		DisplayName: infra.Js("Remote command"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("command"),
		Type:        infra.Js("string"),
		Mutable:     infra.Jstrue(),
	})

	paramRemote := datacoderparameter.NewDataCoderParameter(stack, infra.Js("remote"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js(""),
		Description: infra.Js("Remote ssh"),
		DisplayName: infra.Js("Remote ssh"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("remote"),
		Type:        infra.Js("string"),
		Mutable:     infra.Jstrue(),
	})

	paramOs := datacoderparameter.NewDataCoderParameter(stack, infra.Js("os"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("linux"),
		Description: infra.Js("Operating system"),
		DisplayName: infra.Js("Operation system"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("os"),
		Type:        infra.Js("string"),
		Mutable:     infra.Jstrue(),
	})

	paramArch := datacoderparameter.NewDataCoderParameter(stack, infra.Js("arch"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("amd64"),
		Description: infra.Js("CPU arch"),
		DisplayName: infra.Js("CPU arch"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("arch"),
		Type:        infra.Js("string"),
		Mutable:     infra.Jstrue(),
	})

	devCoderWorkspace := datacoderworkspace.NewDataCoderWorkspace(stack, infra.Js("me"), &datacoderworkspace.DataCoderWorkspaceConfig{})

	devCoderAgent := agent.NewAgent(stack, infra.Js("main"), &agent.AgentConfig{
		Arch: paramArch.Value(),
		Auth: infra.Js("token"),
		DisplayApps: &agent.AgentDisplayApps{
			SshHelper:      infra.Jsbool(false),
			Vscode:         infra.Jsbool(false),
			VscodeInsiders: infra.Jsbool(false),
		},
		Env: &map[string]*string{
			"GIT_AUTHOR_EMAIL":    devCoderWorkspace.OwnerEmail(),
			"GIT_AUTHOR_NAME":     devCoderWorkspace.Owner(),
			"GIT_COMMITTER_EMAIL": devCoderWorkspace.OwnerEmail(),
			"GIT_COMMITTER_NAME":  devCoderWorkspace.Owner(),
		},
		Os:                   paramOs.Value(),
		StartupScript:        infra.Js(`export STARSHIP_NO= && while true; do source .bash_profile; code-server --auth none; sleep 1; done`),
		StartupScriptTimeout: infra.Jsn(180),
	})

	null_provider.NewNullProvider(stack, infra.Js("null"), &null_provider.NullProviderConfig{})

	deploy := null_resource.NewResource(stack, infra.Js("deploy"), &null_resource.ResourceConfig{
		Triggers: &map[string]*string{
			"always_run": devCoderAgent.Token(),
		},
	})

	deploy.AddOverride(infra.Js("provisioner"), []map[string]map[string]string{
		{"local-exec": {
			"when": "create",
			"command": fmt.Sprintf(
				"( (echo cd; echo exec env CODER_AGENT_TOKEN=%s CODER_NAME=%s CODER_HOMEDIR=%s CODER_INIT_SCRIPT_BASE64=%s %s) | ssh %s bash -x - >>/tmp/startup-%s-%s.log 2>&1 &) &",
				*devCoderAgent.Token(),
				*devCoderWorkspace.Name(),
				*paramHomedir.Value(),
				*cdktf.Fn_Base64encode(devCoderAgent.InitScript()),
				*paramCommand.Value(),
				*paramRemote.Value(),
				*devCoderWorkspace.Owner(),
				*devCoderWorkspace.Name(),
			),
		}},
	})

	coder_provider.NewCoderProvider(stack, infra.Js("coder"), &coder_provider.CoderProviderConfig{})

	coderlogin.NewCoderlogin(stack, infra.Js("coder_login"), &coderlogin.CoderloginConfig{
		AgentId: devCoderAgent.Id(),
	})

	app.NewApp(stack, infra.Js("code-server"), &app.AppConfig{
		AgentId:     devCoderAgent.Id(),
		DisplayName: infra.Js("code-server"),
		Healthcheck: &app.AppHealthcheck{
			Interval:  infra.Jsn(5),
			Threshold: infra.Jsn(6),
			Url:       infra.Js("http://localhost:8080/healthz"),
		},
		Icon:      infra.Js("/icon/code.svg"),
		Share:     infra.Js("owner"),
		Slug:      infra.Js("cs"),
		Subdomain: infra.Jsbool(false),
		Url:       infra.Js(fmt.Sprintf("http://localhost:8080/?folder=%s", *paramHomedir.Value())),
	})

	return stack
}
