package main

import (
	"fmt"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	aws_provider "github.com/cdktf/cdktf-provider-aws-go/aws/v19/provider"

	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/dataawsami"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/defaultvpc"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/ec2instancestate"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/iaminstanceprofile"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/iamrole"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/iamrolepolicyattachment"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/instance"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/securitygroup"

	coder_provider "github.com/defn/dev/m/tf/gen/coder/coder/provider"

	"github.com/defn/dev/m/tf/gen/coder/coder/agent"
	"github.com/defn/dev/m/tf/gen/coder/coder/app"
	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderparameter"
	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderworkspace"
	"github.com/defn/dev/m/tf/gen/coder/coder/metadata"

	"github.com/defn/dev/m/tf/gen/coderlogin"
	"github.com/defn/dev/m/tf/gen/terraform_aws_s3_bucket"

	infra "github.com/defn/dev/m/command/infra"
)

func CoderDefnEc2Stack(scope constructs.Construct, site *infra.AwsProps, name string) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, infra.Js(fmt.Sprintf("coder-defn-ec2-%s", name)))

	cdktf.NewLocalBackend(stack, &cdktf.LocalBackendConfig{})

	paramUsername := datacoderparameter.NewDataCoderParameter(stack, infra.Js("username"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("ubuntu"),
		Description: infra.Js("Linux accoount name"),
		DisplayName: infra.Js("Username"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("username"),
		Type:        infra.Js("string"),
	})

	paramRegion := datacoderparameter.NewDataCoderParameter(stack, infra.Js("region"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("us-west-2"),
		Description: infra.Js("Cloud region"),
		DisplayName: infra.Js("Cloud region"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("region"),
		Type:        infra.Js("string"),
	})

	paramAvailablityZone := datacoderparameter.NewDataCoderParameter(stack, infra.Js("az"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("a"),
		Description: infra.Js("Cloud availability zone"),
		DisplayName: infra.Js("Cloud availability zone"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Name:        infra.Js("az"),
		Type:        infra.Js("string"),
	})

	paramInstanceType := datacoderparameter.NewDataCoderParameter(stack, infra.Js("instance_type"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("m6id.large"),
		Description: infra.Js("The number of CPUs to allocate to the workspace"),
		DisplayName: infra.Js("CPU"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Mutable:     infra.Jsbool(true),
		Name:        infra.Js("instance_type"),
		Option: []*datacoderparameter.DataCoderParameterOption{{
			Name:  infra.Js("2"),
			Value: infra.Js("m6id.large"),
		}, {
			Name:  infra.Js("4"),
			Value: infra.Js("m6id.xlarge"),
		}, {
			Name:  infra.Js("8"),
			Value: infra.Js("m6id.2xlarge"),
		}, {
			Name:  infra.Js("16"),
			Value: infra.Js("m6id.4xlarge"),
		}},
		Type: infra.Js("string"),
	})

	paramNixVolumeSize := datacoderparameter.NewDataCoderParameter(stack, infra.Js("nix_volume_size"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("100"),
		Description: infra.Js("The size of the nix volume to create for the workspace in GB"),
		DisplayName: infra.Js("nix volume size"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/database.svg"),
		Mutable:     infra.Jsbool(true),
		Name:        infra.Js("nix_volume_size"),
		Type:        infra.Js("number"),
		Validation: &datacoderparameter.DataCoderParameterValidation{
			Max: infra.Jsn(300),
			Min: infra.Jsn(100),
		},
	})

	paramServiceProvider := datacoderparameter.NewDataCoderParameter(stack, infra.Js("provider"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("aws-ec2"),
		Description: infra.Js("The service provider to deploy the workspace in"),
		DisplayName: infra.Js("Provider"),
		Icon:        infra.Js("/emojis/1f30e.png"),
		Name:        infra.Js("provider"),
		Option: []*datacoderparameter.DataCoderParameterOption{{
			Name:  infra.Js("Amazon Web Services VM"),
			Value: infra.Js("aws-ec2"),
		}},
	})

	paramTailscaleAuthKey := datacoderparameter.NewDataCoderParameter(stack, infra.Js("tsauthkey"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("TODO"),
		Description: infra.Js("Tailscale node authorization key"),
		DisplayName: infra.Js("Tailscale auth key"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Mutable:     infra.Jsbool(true),
		Name:        infra.Js("tsauthkey"),
		Type:        infra.Js("string"),
	})

	devCoderWorkspace := datacoderworkspace.NewDataCoderWorkspace(stack, infra.Js("me"), &datacoderworkspace.DataCoderWorkspaceConfig{})

	devCoderAgent := agent.NewAgent(stack, infra.Js("main"), &agent.AgentConfig{
		Arch: infra.Js("amd64"),
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
			"LC_ALL":              infra.Js("C.UTF-8"),
			"LOCAL_ARCHIVE":       infra.Js("/usr/lib/locale/locale-archive"),
		},
		Os:                   infra.Js("linux"),
		StartupScript:        infra.Js(`cd ~/m && bin/startup.sh`),
		StartupScriptTimeout: infra.Jsn(180),
	})

	devWorkspaceName := infra.Js("coder-${" + *devCoderWorkspace.Owner() + "}-${" + *devCoderWorkspace.Name() + "}")

	devUserData := fmt.Sprintf(`Content-type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
hostname: coder-${%s}-${%s}
cloud_final_modules:
- [scripts-user, always]

--//
Content-type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

set -x

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'fs.inotify.max_user_instances = 10000' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/99-dfd.conf
sudo sysctl -p /etc/sysctl.d/99-dfd.conf

while true; do
  if test -n "$(dig +short "cache.nixos.org" || true)"; then
    break
  fi
  sleep 5
done

if ! tailscale ip -4 | grep ^100; then
  sudo tailscale up --accept-dns --accept-routes --authkey="%s" --operator=ubuntu --ssh --timeout 60s # missing --advertise-routes= on reboot
fi

nohup sudo -H -E -u %s bash -c 'cd && (git pull || true) && cd m && exec bin/user-data.sh ${%s} coder-${%s}-${%s} ${%s}' >>/tmp/user-data.log 2>&1 &
disown
--//--`,
		*devCoderWorkspace.Owner(), *devCoderWorkspace.Name(),
		*paramTailscaleAuthKey.Value(), *paramUsername.Value(),
		*devCoderWorkspace.AccessUrl(), *devCoderWorkspace.Owner(), *devCoderWorkspace.Name(), *devCoderAgent.Token())

	devVpc := defaultvpc.NewDefaultVpc(stack, infra.Js("default"), &defaultvpc.DefaultVpcConfig{})

	devAmi := dataawsami.NewDataAwsAmi(stack, infra.Js("ubuntu"), &dataawsami.DataAwsAmiConfig{
		Filter: []map[string]interface{}{{
			"name": infra.Js("name"),
			"values": []*string{
				infra.Js("coder-*"),
			},
		}, {
			"name": infra.Js("architecture"),
			"values": []*string{
				infra.Js("x86_64"),
			},
		}},
		MostRecent: infra.Jsbool(true),
		Owners: &[]*string{
			infra.Js("self"),
		},
	})

	devIamRole := iamrole.NewIamRole(stack, infra.Js("dev"), &iamrole.IamRoleConfig{
		AssumeRolePolicy: cdktf.Token_AsString(cdktf.FnGenerated_Jsonencode(map[string]interface{}{
			"Statement": []map[string]interface{}{{
				"Action": infra.Js("sts:AssumeRole"),
				"Effect": infra.Js("Allow"),
				"Principal": map[string]*string{
					"Service": infra.Js("ec2.amazonaws.com"),
				},
				"Sid": infra.Js(""),
			}},
			"Version": infra.Js("2012-10-17"),
		}), &cdktf.EncodingOptions{}),
		Name: devWorkspaceName,
	})

	iamrolepolicyattachment.NewIamRolePolicyAttachment(stack, infra.Js("admin"), &iamrolepolicyattachment.IamRolePolicyAttachmentConfig{
		PolicyArn: infra.Js("arn:aws:iam::aws:policy/AdministratorAccess"),
		Role:      devIamRole.Name(),
	})

	iamrolepolicyattachment.NewIamRolePolicyAttachment(stack, infra.Js("secretsmanager"), &iamrolepolicyattachment.IamRolePolicyAttachmentConfig{
		PolicyArn: infra.Js("arn:aws:iam::aws:policy/SecretsManagerReadWrite"),
		Role:      devIamRole.Name(),
	})

	iamrolepolicyattachment.NewIamRolePolicyAttachment(stack, infra.Js("ssm"), &iamrolepolicyattachment.IamRolePolicyAttachmentConfig{
		PolicyArn: infra.Js("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"),
		Role:      devIamRole.Name(),
	})

	devSecurityGroup := securitygroup.NewSecurityGroup(stack, infra.Js("dev_security_group"), &securitygroup.SecurityGroupConfig{
		Description: devWorkspaceName,
		Egress: []map[string]interface{}{{
			"cidrBlocks": []*string{
				infra.Js("0.0.0.0/0"),
			},
			"description": infra.Js("allow all egress"),
			"fromPort":    infra.Jsn(0),
			"ipv6CidrBlocks": []*string{
				infra.Js("::/0"),
			},
			"protocol": infra.Js("-1"),
			"toPort":   infra.Jsn(0),
		}},
		Ingress: []map[string]interface{}{{
			"cidrBlocks": []*string{
				infra.Js("172.31.0.0/16"),
			},
			"description": infra.Js("allow vpc ingress"),
			"fromPort":    infra.Jsn(0),
			"protocol":    infra.Js("-1"),
			"toPort":      infra.Jsn(0),
		}, {
			"cidrBlocks": []*string{
				infra.Js("0.0.0.0/0"),
			},
			"description": infra.Js("allow wireguard udp"),
			"fromPort":    infra.Jsn(41641),
			"ipv6CidrBlocks": []*string{
				infra.Js("::/0"),
			},
			"protocol": infra.Js("udp"),
			"toPort":   infra.Jsn(41641),
		}},
		Name: devWorkspaceName,
		Tags: &map[string]*string{
			"karpenter.sh/discovery": infra.Js("k3d-dfd"),
		},
		VpcId: devVpc.Id(),
	})

	app.NewApp(stack, infra.Js("code-server"), &app.AppConfig{
		AgentId:     devCoderAgent.Id(),
		DisplayName: infra.Js("code-server"),
		Healthcheck: &app.AppHealthcheck{
			Interval:  infra.Jsn(5),
			Threshold: infra.Jsn(6),
			Url:       infra.Js("http://localhost:13337/healthz"),
		},
		Icon:      infra.Js("/icon/code.svg"),
		Share:     infra.Js("owner"),
		Slug:      infra.Js("code-server"),
		Subdomain: infra.Jsbool(false),
		Url:       infra.Js(fmt.Sprintf("http://localhost:13337/?folder=/home/%s/m", *paramUsername.Value())),
	})

	aws_provider.NewAwsProvider(stack, infra.Js("aws"), &aws_provider.AwsProviderConfig{
		Region: paramRegion.Value(),
	})

	coder_provider.NewCoderProvider(stack, infra.Js("coder"), &coder_provider.CoderProviderConfig{})

	coderlogin.NewCoderlogin(stack, infra.Js("coder_login"), &coderlogin.CoderloginConfig{
		AgentId: devCoderAgent.Id(),
	})

	terraform_aws_s3_bucket.NewTerraformAwsS3Bucket(stack, infra.Js("dev_bucket"), &terraform_aws_s3_bucket.TerraformAwsS3BucketConfig{
		Name:              devWorkspaceName,
		S3ObjectOwnership: infra.Js("BucketOwnerEnforced"),
		Enabled:           infra.Jstrue(),
		UserEnabled:       infra.Jsfalse(),
		VersioningEnabled: infra.Jsfalse(),
		WebsiteConfiguration: []map[string]interface{}{{
			"index_document": infra.Js("index.html"),
			"error_document": infra.Js("404.html"),
			"routing_rules": cdktf.Token_AsList([]interface{}{map[string]map[string]*string{
				"condition": {
					"key_prefix_equals":               infra.Js("documents/"),
					"http_error_code_returned_equals": infra.Js("404"),
				},
				"redirect": {
					"host_name":               infra.Js("defn.dev"),
					"http_redirect_code":      infra.Js("404"),
					"protocol":                infra.Js("https"),
					"replace_key_prefix_with": infra.Js("docs/"),
					"replace_key_with":        infra.Js("docs/"),
				},
			}}, &cdktf.EncodingOptions{}),
		}},
	})

	devInstanceProfile := iaminstanceprofile.NewIamInstanceProfile(stack, infra.Js("dev_instance_profile"), &iaminstanceprofile.IamInstanceProfileConfig{
		Name: devWorkspaceName,
		Role: devIamRole.Name(),
	})

	devEc2Instance := instance.NewInstance(stack, infra.Js("dev_ec2_instance"), &instance.InstanceConfig{
		Ami:                devAmi.Id(),
		AvailabilityZone:   infra.Js(fmt.Sprintf("%s%s", *paramRegion.Value(), *paramAvailablityZone.Value())),
		EbsOptimized:       infra.Jsbool(true),
		IamInstanceProfile: devInstanceProfile.Name(),
		InstanceType:       paramInstanceType.Value(),
		MetadataOptions: &instance.InstanceMetadataOptions{
			HttpEndpoint:            infra.Js("enabled"),
			HttpPutResponseHopLimit: infra.Jsn(1),
			HttpTokens:              infra.Js("required"),
			InstanceMetadataTags:    infra.Js("enabled"),
		},
		Monitoring: infra.Jsbool(false),
		RootBlockDevice: &instance.InstanceRootBlockDevice{
			DeleteOnTermination: infra.Jsbool(true),
			Encrypted:           infra.Jsbool(true),
			VolumeSize:          cdktf.Token_AsNumber(paramNixVolumeSize.Value()),
			VolumeType:          infra.Js("gp3"),
		},
		Tags: &map[string]*string{
			"Coder_Provisioned": infra.Js("true"),
			"Name":              devWorkspaceName,
		},
		UserData: infra.Js(devUserData),
		VpcSecurityGroupIds: &[]*string{
			devSecurityGroup.Id(),
		},
		Lifecycle: &cdktf.TerraformResourceLifecycle{
			IgnoreChanges: []string{"ami"},
		},
	})

	devEc2Count := cdktf.TerraformCount_Of(cdktf.Token_AsNumber(cdktf.Fn_Conditional(cdktf.Op_Eq(paramServiceProvider.Value(), infra.Js("aws-ec2")), infra.Jsn(1), infra.Jsn(0))))
	metadata.NewMetadata(stack, infra.Js("dev_metadata"), &metadata.MetadataConfig{
		Item: []*metadata.MetadataItem{{
			Key:   infra.Js("instance type"),
			Value: devEc2Instance.InstanceType(),
		}, {
			Key:   infra.Js("disk"),
			Value: cdktf.Token_AsString(devEc2Instance.RootBlockDevice().VolumeSize(), &cdktf.EncodingOptions{}),
		}},
		ResourceId: devEc2Instance.Id(),
		Count:      devEc2Count,
	})

	ec2instancestate.NewEc2InstanceState(stack, infra.Js("dev_instance_state"), &ec2instancestate.Ec2InstanceStateConfig{
		InstanceId: devEc2Instance.Id(),
		State:      cdktf.Token_AsString(cdktf.Fn_Conditional(cdktf.Op_Eq(devCoderWorkspace.Transition(), infra.Js("start")), infra.Js("running"), infra.Js("stopped")), &cdktf.EncodingOptions{}),
	})

	return stack
}
