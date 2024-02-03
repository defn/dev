package main

import (
	"fmt"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/dataawsami"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/defaultvpc"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/ec2instancestate"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/iaminstanceprofile"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/iamrole"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/iamrolepolicyattachment"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/instance"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/provider"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/secretsmanagersecret"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/secretsmanagersecretversion"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/securitygroup"
	"github.com/defn/dev/m/tf/gen/coder/coder/agent"
	"github.com/defn/dev/m/tf/gen/coder/coder/app"
	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderparameter"
	"github.com/defn/dev/m/tf/gen/coder/coder/datacoderworkspace"
	"github.com/defn/dev/m/tf/gen/coder/coder/metadata"
	"github.com/defn/dev/m/tf/gen/coderlogin"

	infra "github.com/defn/dev/m/command/infra"
)

func CoderDefnEc2Stack(scope constructs.Construct, name *string) cdktf.TerraformStack {
	this := cdktf.NewTerraformStack(scope, infra.Js(fmt.Sprintf("coder-defn-ec2-%s", *name)))

	amiFilter := []*string{
		infra.Js("coder-*"),
	}
	owners := []*string{
		infra.Js("self"),
	}
	username := "ubuntu"

	defaultVar := defaultvpc.NewDefaultVpc(this, infra.Js("default"), &defaultvpc.DefaultVpcConfig{})

	tsauthkey := cdktf.NewTerraformVariable(this, infra.Js("tsauthkey"), &cdktf.TerraformVariableConfig{})

	ubuntu := dataawsami.NewDataAwsAmi(this, infra.Js("ubuntu"), &dataawsami.DataAwsAmiConfig{
		Filter: []map[string]interface{}{
			{
				"name":   infra.Js("name"),
				"values": cdktf.Token_AsList(amiFilter, &cdktf.EncodingOptions{}),
			},
			{
				"name": infra.Js("architecture"),
				"values": []*string{
					infra.Js("x86_64"),
				},
			},
		},
		MostRecent: infra.Jsbool(true),
		Owners:     cdktf.Token_AsList(owners, &cdktf.EncodingOptions{}),
	})

	instanceType := datacoderparameter.NewDataCoderParameter(this, infra.Js("instance_type"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("m6id.large"),
		Description: infra.Js("The number of CPUs to allocate to the workspace"),
		DisplayName: infra.Js("CPU"),
		Icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		Mutable:     infra.Jsbool(true),
		Name:        infra.Js("instance_type"),
		Option: []interface{}{
			&datacoderparameter.DataCoderParameterOption{
				Name:  infra.Js("2"),
				Value: infra.Js("m6id.large"),
			},
			&datacoderparameter.DataCoderParameterOption{
				Name:  infra.Js("4"),
				Value: infra.Js("m6id.xlarge"),
			},
			&datacoderparameter.DataCoderParameterOption{
				Name:  infra.Js("8"),
				Value: infra.Js("m6id.2xlarge"),
			},
			&datacoderparameter.DataCoderParameterOption{
				Name:  infra.Js("16"),
				Value: infra.Js("m6id.4xlarge"),
			},
		},
		Type: infra.Js("string"),
	})

	nixVolumeSize := datacoderparameter.NewDataCoderParameter(this, infra.Js("nix_volume_size"), &datacoderparameter.DataCoderParameterConfig{
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

	coderprovider := datacoderparameter.NewDataCoderParameter(this, infra.Js("provider"), &datacoderparameter.DataCoderParameterConfig{
		Default:     infra.Js("aws-ec2"),
		Description: infra.Js("The service provider to deploy the workspace in"),
		DisplayName: infra.Js("Provider"),
		Icon:        infra.Js("/emojis/1f30e.png"),
		Mutable:     infra.Jsbool(true),
		Name:        infra.Js("provider"),
		Option: []interface{}{
			&datacoderparameter.DataCoderParameterOption{
				Name:  infra.Js("Amazon Web Services VM"),
				Value: infra.Js("aws-ec2"),
			},
		},
	})

	me := datacoderworkspace.NewDataCoderWorkspace(this, infra.Js("me"), &datacoderworkspace.DataCoderWorkspaceConfig{})

	aws := map[string]interface{}{
		"availability_zone": infra.Js("us-west-2a"),
		"instance_type":     instanceType.Value,
		"region":            infra.Js("us-west-2"),
		"root_volume_size":  nixVolumeSize.Value,
	}

	awsEc2Count := cdktf.Fn_Conditional(cdktf.Op_Eq(coderprovider.Value, infra.Js("aws-ec2")), infra.Jsn(1), infra.Jsn(0))
	coderName := infra.Js("coder-${" + *me.Owner() + "}-${" + *me.Name() + "}")
	userData := "Content-type: multipart/mixed; boundary=\"//\"\nMIME-Version: 1.0\n\n--//\nContent-type: text/cloud-config; charset=\"us-ascii\"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename=\"cloud-config.txt\"\n\n#cloud-config\nhostname: ${" + *coderName + "}\ncloud_final_modules:\n- [scripts-user, always]\n\n--//\nContent-type: text/x-shellscript; charset=\"us-ascii\"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename=\"userdata.txt\"\n\n#!/bin/bash\n\nset -x\n\necho 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'fs.inotify.max_user_instances = 10000' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/99-dfd.conf\nsudo sysctl -p /etc/sysctl.d/99-dfd.conf\n\nwhile true; do\n  if test -n \"$(dig +short \"cache.nixos.org\" || true)\"; then\n    break\n  fi\n  sleep 5\ndone\n\nif ! tailscale ip -4 | grep ^100; then\n  sudo tailscale up --accept-dns --accept-routes --authkey=\"${" + *tsauthkey.StringValue() + "}\" --operator=ubuntu --ssh --timeout 60s # missing --advertise-routes= on reboot\nfi\n\nnohup sudo -H -E -u ${" + username + "} bash -c 'cd && (git pull || true) && cd m && exec bin/user-data.sh ${" + *me.AccessUrl() + "} ${" + *coderName + "}' >/tmp/cloud-init.log 2>&1 &\ndisown\n--//--\n\n"

	dev := iamrole.NewIamRole(this, infra.Js("dev"), &iamrole.IamRoleConfig{
		AssumeRolePolicy: cdktf.Token_AsString(cdktf.FnGenerated_Jsonencode(map[string]interface{}{
			"Statement": []map[string]interface{}{
				{
					"Action": infra.Js("sts:AssumeRole"),
					"Effect": infra.Js("Allow"),
					"Principal": map[string]*string{
						"Service": infra.Js("ec2.amazonaws.com"),
					},
					"Sid": infra.Js(""),
				},
			},
			"Version": infra.Js("2012-10-17"),
		}), &cdktf.EncodingOptions{}),
		Name: coderName,
	})

	iamrolepolicyattachment.NewIamRolePolicyAttachment(this, infra.Js("admin"), &iamrolepolicyattachment.IamRolePolicyAttachmentConfig{
		PolicyArn: infra.Js("arn:aws:iam::aws:policy/AdministratorAccess"),
		Role:      dev.Name(),
	})

	iamrolepolicyattachment.NewIamRolePolicyAttachment(this, infra.Js("secretsmanager"), &iamrolepolicyattachment.IamRolePolicyAttachmentConfig{
		PolicyArn: infra.Js("arn:aws:iam::aws:policy/SecretsManagerReadWrite"),
		Role:      dev.Name(),
	})

	iamrolepolicyattachment.NewIamRolePolicyAttachment(this, infra.Js("ssm"), &iamrolepolicyattachment.IamRolePolicyAttachmentConfig{
		PolicyArn: infra.Js("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"),
		Role:      dev.Name(),
	})

	awsSecurityGroupDev := securitygroup.NewSecurityGroup(this, infra.Js("dev_11"), &securitygroup.SecurityGroupConfig{
		Description: coderName,
		Egress: []map[string]interface{}{
			{
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
			},
		},
		Ingress: []interface{}{
			map[string]interface{}{
				"cidrBlocks": []*string{
					infra.Js("172.31.32.0/20"),
				},
				"description": infra.Js("allow vpc ingress"),
				"fromPort":    infra.Jsn(0),
				"protocol":    infra.Js("-1"),
				"toPort":      infra.Jsn(0),
			},
			map[string]interface{}{
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
			},
		},
		Name: coderName,
		Tags: &map[string]*string{
			"karpenter.sh/discovery": infra.Js("k3d-dfd"),
		},
		VpcId: defaultVar.Id(),
	})

	main := agent.NewAgent(this, infra.Js("main"), &agent.AgentConfig{
		Arch: infra.Js("amd64"),
		Auth: infra.Js("token"),
		DisplayApps: &agent.AgentDisplayApps{
			SshHelper:      infra.Jsbool(false),
			Vscode:         infra.Jsbool(false),
			VscodeInsiders: infra.Jsbool(false),
		},
		Env: &map[string]*string{
			"GIT_AUTHOR_EMAIL":    cdktf.Token_AsString(me.OwnerEmail, &cdktf.EncodingOptions{}),
			"GIT_AUTHOR_NAME":     cdktf.Token_AsString(me.Owner, &cdktf.EncodingOptions{}),
			"GIT_COMMITTER_EMAIL": cdktf.Token_AsString(me.OwnerEmail, &cdktf.EncodingOptions{}),
			"GIT_COMMITTER_NAME":  cdktf.Token_AsString(me.Owner, &cdktf.EncodingOptions{}),
			"LC_ALL":              infra.Js("C.UTF-8"),
			"LOCAL_ARCHIVE":       infra.Js("/usr/lib/locale/locale-archive"),
		},
		Os:                   infra.Js("linux"),
		StartupScript:        cdktf.Token_AsString(cdktf.Fn_File(infra.Js("${path.module}/startup.sh")), &cdktf.EncodingOptions{}),
		StartupScriptTimeout: infra.Jsn(180),
	})

	app.NewApp(this, infra.Js("code-server"), &app.AppConfig{
		AgentId:     main.Id(),
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
		Url:       infra.Js("http://localhost:13337/?folder=/home/${" + username + "}/m"),
	})

	provider.NewAwsProvider(this, infra.Js("aws"), &provider.AwsProviderConfig{
		Region: cdktf.Token_AsString(cdktf.Fn_LookupNested(aws, &[]interface{}{
			infra.Js("region"),
		}), &cdktf.EncodingOptions{}),
	})

	coderlogin.NewCoderlogin(this, infra.Js("coder-login"), &coderlogin.CoderloginConfig{
		AgentId: main.Id(),
	})

	awsIamInstanceProfileDev := iaminstanceprofile.NewIamInstanceProfile(this, infra.Js("dev_16"), &iaminstanceprofile.IamInstanceProfileConfig{
		Name: coderName,
		Role: dev.Name(),
	})

	awsInstanceDev := instance.NewInstance(this, infra.Js("dev_17"), &instance.InstanceConfig{
		Ami: cdktf.Token_AsString(ubuntu.Id(), &cdktf.EncodingOptions{}),
		AvailabilityZone: cdktf.Token_AsString(cdktf.Fn_LookupNested(aws, &[]interface{}{
			infra.Js("availability_zone"),
		}), &cdktf.EncodingOptions{}),
		EbsOptimized:       infra.Jsbool(true),
		IamInstanceProfile: cdktf.Token_AsString(awsIamInstanceProfileDev.Name(), &cdktf.EncodingOptions{}),
		InstanceType: cdktf.Token_AsString(cdktf.Fn_LookupNested(aws, &[]interface{}{
			infra.Js("instance_type"),
		}), &cdktf.EncodingOptions{}),
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
			VolumeSize: cdktf.Token_AsNumber(cdktf.Fn_LookupNested(aws, &[]interface{}{
				infra.Js("root_volume_size"),
			})),
			VolumeType: infra.Js("gp3"),
		},
		Tags: &map[string]*string{
			"Coder_Provisioned": infra.Js("true"),
			"Name":              coderName,
		},
		UserData: &userData,
		VpcSecurityGroupIds: &[]*string{
			cdktf.Token_AsString(awsSecurityGroupDev.Id(), &cdktf.EncodingOptions{}),
		},
	})

	awsSecretsmanagerSecretDev := secretsmanagersecret.NewSecretsmanagerSecret(this, infra.Js("dev_18"), &secretsmanagersecret.SecretsmanagerSecretConfig{
		Name: infra.Js("${" + *coderName + "}-${" + *awsInstanceDev.Id() + "}"),
	})

	secretsmanagersecretversion.NewSecretsmanagerSecretVersion(this, infra.Js("dev_19"), &secretsmanagersecretversion.SecretsmanagerSecretVersionConfig{
		SecretId:     cdktf.Token_AsString(awsSecretsmanagerSecretDev.Id(), &cdktf.EncodingOptions{}),
		SecretString: infra.Js("{coder_agent_token:${" + *main.Token() + "}}"),
	})

	mainCount := cdktf.TerraformCount_Of(cdktf.Token_AsNumber(awsEc2Count))
	metadata.NewMetadata(this, infra.Js("main_20"), &metadata.MetadataConfig{
		Item: []interface{}{
			&metadata.MetadataItem{
				Key:   infra.Js("instance type"),
				Value: cdktf.Token_AsString(awsInstanceDev.InstanceType(), &cdktf.EncodingOptions{}),
			},
			&metadata.MetadataItem{
				Key: infra.Js("disk"),
				Value: infra.Js(*cdktf.Token_AsString(cdktf.Fn_LookupNested(awsInstanceDev.RootBlockDevice(), &[]interface{}{
					infra.Js("0"),
					infra.Js("volume_size"),
				}), &cdktf.EncodingOptions{}) + " GiB"),
			},
		},
		ResourceId: cdktf.Token_AsString(awsInstanceDev.Id(), &cdktf.EncodingOptions{}),
		Count:      mainCount,
	})

	ec2instancestate.NewEc2InstanceState(this, infra.Js("dev_21"), &ec2instancestate.Ec2InstanceStateConfig{
		InstanceId: cdktf.Token_AsString(awsInstanceDev.Id(), &cdktf.EncodingOptions{}),
		State:      cdktf.Token_AsString(cdktf.Fn_Conditional(cdktf.Op_Eq(me.Transition, infra.Js("start")), infra.Js("running"), infra.Js("stopped")), &cdktf.EncodingOptions{}),
	})

	return this
}
