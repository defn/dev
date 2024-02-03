package meh

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
	this := cdktf.NewTerraformStack(scope, infra.Js(fmt.Sprintf("coder-defn-ec2-%s", name)))

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
			map[string]interface{}{
				"name":   infra.Js("name"),
				"values": cdktf.Token_AsList(amiFilter),
			},
			map[string]interface{}{
				"name": infra.Js("architecture"),
				"values": []*string{
					infra.Js("x86_64"),
				},
			},
		},
		MostRecent: infra.Jsbool(true),
		Owners:     cdktf.Token_AsList(owners),
	})

	instanceType := datacoderparameter.NewDataCoderParameter(this, infra.Js("instance_type"), &datacoderparameter.DataCoderParameterConfig{
		"default":   infra.Js("m6id.large"),
		description: infra.Js("The number of CPUs to allocate to the workspace"),
		displayName: infra.Js("CPU"),
		icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		mutable:     infra.Jsbool(true),
		name:        infra.Js("instance_type"),
		option: []interface{}{
			&dataCoderParameterOption{
				name:  infra.Js("2"),
				value: infra.Js("m6id.large"),
			},
			&dataCoderParameterOption{
				name:  infra.Js("4"),
				value: infra.Js("m6id.xlarge"),
			},
			&dataCoderParameterOption{
				name:  infra.Js("8"),
				value: infra.Js("m6id.2xlarge"),
			},
			&dataCoderParameterOption{
				name:  infra.Js("16"),
				value: infra.Js("m6id.4xlarge"),
			},
		},
		"type": infra.Js("string"),
	})

	nixVolumeSize := datacoderparameter.NewDataCoderParameter(this, infra.Js("nix_volume_size"), &datacoderparameter.DataCoderParameterConfig{
		"default":   infra.Js("100"),
		description: infra.Js("The size of the nix volume to create for the workspace in GB"),
		displayName: infra.Js("nix volume size"),
		icon:        infra.Js("https://raw.githubusercontent.com/matifali/logos/main/database.svg"),
		mutable:     infra.Jsbool(true),
		name:        infra.Js("nix_volume_size"),
		"type":      infra.Js("number"),
		validation: &dataCoderParameterValidation{
			max: infra.Jsn(300),
			min: infra.Jsn(100),
		},
	})

	coderprovider := datacoderparameter.NewDataCoderParameter(this, infra.Js("provider"), &datacoderparameter.DataCoderParameterConfig{
		"default":   infra.Js("aws-ec2"),
		description: infra.Js("The service provider to deploy the workspace in"),
		displayName: infra.Js("Provider"),
		icon:        infra.Js("/emojis/1f30e.png"),
		mutable:     infra.Jsbool(true),
		name:        infra.Js("provider"),
		option: []interface{}{
			&dataCoderParameterOption{
				name:  infra.Js("Amazon Web Services VM"),
				value: infra.Js("aws-ec2"),
			},
		},
	})

	me := datacoderworkspace.NewDataCoderWorkspace(this, infra.Js("me"), &datacoderworkspace.DataCoderWorkspaceConfig{})

	aws := map[string]interface{}{
		"availability_zone": infra.Js("us-west-2a"),
		"instance_type":     instanceType.value,
		"region":            infra.Js("us-west-2"),
		"root_volume_size":  nixVolumeSize.value,
	}
	awsEc2Count := cdktf.Conditional(cdktf.Op_Eq(coderprovider.value, infra.Js("aws-ec2")), infra.Jsn(1), infra.Jsn(0))
	coderName := "coder-${" + me.owner + "}-${" + me.name + "}"
	userData := "Content-type: multipart/mixed; boundary=\"//\"\nMIME-Version: 1.0\n\n--//\nContent-type: text/cloud-config; charset=\"us-ascii\"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename=\"cloud-config.txt\"\n\n#cloud-config\nhostname: ${" + coderName + "}\ncloud_final_modules:\n- [scripts-user, always]\n\n--//\nContent-type: text/x-shellscript; charset=\"us-ascii\"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename=\"userdata.txt\"\n\n#!/bin/bash\n\nset -x\n\necho 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'fs.inotify.max_user_instances = 10000' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/99-dfd.conf\nsudo sysctl -p /etc/sysctl.d/99-dfd.conf\n\nwhile true; do\n  if test -n \"$(dig +short \"cache.nixos.org\" || true)\"; then\n    break\n  fi\n  sleep 5\ndone\n\nif ! tailscale ip -4 | grep ^100; then\n  sudo tailscale up --accept-dns --accept-routes --authkey=\"${" + tsauthkey.value + "}\" --operator=ubuntu --ssh --timeout 60s # missing --advertise-routes= on reboot\nfi\n\nnohup sudo -H -E -u ${" + username + "} bash -c 'cd && (git pull || true) && cd m && exec bin/user-data.sh ${" + me.accessUrl + "} ${" + coderName + "}' >/tmp/cloud-init.log 2>&1 &\ndisown\n--//--\n\n"
	dev := iamrole.NewIamRole(this, infra.Js("dev"), map[string]*string{
		"assumeRolePolicy": cdktf.Token_asString(cdktf.Fn_jsonencode(map[string]interface{}{
			"Statement": []map[string]interface{}{
				map[string]interface{}{
					"Action": infra.Js("sts:AssumeRole"),
					"Effect": infra.Js("Allow"),
					"Principal": map[string]*string{
						"Service": infra.Js("ec2.amazonaws.com"),
					},
					"Sid": infra.Js(""),
				},
			},
			"Version": infra.Js("2012-10-17"),
		})),
		"name": coderName,
	})
	iamrolepolicyattachment.NewIamRolePolicyAttachment(this, infra.Js("admin"), map[string]interface{}{
		"policyArn": infra.Js("arn:aws:iam::aws:policy/AdministratorAccess"),
		"role":      dev.name,
	})
	iamrolepolicyattachment.NewIamRolePolicyAttachment(this, infra.Js("secretsmanager"), map[string]interface{}{
		"policyArn": infra.Js("arn:aws:iam::aws:policy/SecretsManagerReadWrite"),
		"role":      dev.name,
	})
	iamrolepolicyattachment.NewIamRolePolicyAttachment(this, infra.Js("ssm"), map[string]interface{}{
		"policyArn": infra.Js("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"),
		"role":      dev.name,
	})
	awsSecurityGroupDev := securitygroup.NewSecurityGroup(this, infra.Js("dev_11"), map[string]interface{}{
		"description": coderName,
		"egress": []map[string]interface{}{
			map[string]interface{}{
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
		"ingress": []interface{}{
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
		"name": coderName,
		"tags": map[string]*string{
			"karpenter.sh/discovery": infra.Js("k3d-dfd"),
		},
		"vpcId": defaultVar.id,
	})

	main := agent.NewAgent(this, infra.Js("main"), &agentConfig{
		arch: infra.Js("amd64"),
		auth: infra.Js("token"),
		displayApps: &agentDisplayApps{
			sshHelper:      infra.Jsbool(false),
			vscode:         infra.Jsbool(false),
			vscodeInsiders: infra.Jsbool(false),
		},
		env: map[string]*string{
			"GIT_AUTHOR_EMAIL":    cdktf.Token_asString(me.ownerEmail),
			"GIT_AUTHOR_NAME":     cdktf.Token_asString(me.owner),
			"GIT_COMMITTER_EMAIL": cdktf.Token_asString(me.ownerEmail),
			"GIT_COMMITTER_NAME":  cdktf.Token_asString(me.owner),
			"LC_ALL":              infra.Js("C.UTF-8"),
			"LOCAL_ARCHIVE":       infra.Js("/usr/lib/locale/locale-archive"),
		},
		os:                   infra.Js("linux"),
		startupScript:        cdktf.Token_AsString(cdktf.Fn_File(infra.Js("${path.module}/startup.sh"))),
		startupScriptTimeout: infra.Jsn(180),
	})
	app.NewApp(this, infra.Js("code-server"), &appConfig{
		agentId:     main.id,
		displayName: infra.Js("code-server"),
		healthcheck: &appHealthcheck{
			interval:  infra.Jsn(5),
			threshold: infra.Jsn(6),
			url:       infra.Js("http://localhost:13337/healthz"),
		},
		icon:      infra.Js("/icon/code.svg"),
		share:     infra.Js("owner"),
		slug:      infra.Js("code-server"),
		subdomain: infra.Jsbool(false),
		url:       infra.Js("http://localhost:13337/?folder=/home/${" + username + "}/m"),
	})
	provider.NewAwsProvider(this, infra.Js("aws"), map[string]*string{
		"region": cdktf.Token_AsString(cdktf.Fn_lookupNested(aws, []interface{}{
			infra.Js("region"),
		})),
	})
	coderlogin.Newcoderlogin(this, infra.Js("coder-login"), map[string]*string{
		"agentId": main.id,
	})
	awsIamInstanceProfileDev := iaminstanceprofile.NewIamInstanceProfile(this, infra.Js("dev_16"), map[string]interface{}{
		"name": coderName,
		"role": dev.name,
	})

	awsInstanceDev := instance.NewInstance(this, infra.Js("dev_17"), map[string]interface{}{
		"ami": cdktf.Token_AsString(ubuntu.id),
		"availabilityZone": cdktf.Token_AsString(cdktf.Fn_lookupNested(aws, []interface{}{
			infra.Js("availability_zone"),
		})),
		"ebsOptimized":       infra.Jsbool(true),
		"iamInstanceProfile": cdktf.Token_AsString(awsIamInstanceProfileDev.name),
		"instanceType": cdktf.Token_AsString(cdktf.Fn_lookupNested(aws, []interface{}{
			infra.Js("instance_type"),
		})),
		"metadataOptions": map[string]interface{}{
			"httpEndpoint":            infra.Js("enabled"),
			"httpPutResponseHopLimit": infra.Jsn(1),
			"httpTokens":              infra.Js("required"),
			"instanceMetadataTags":    infra.Js("enabled"),
		},
		"monitoring": infra.Jsbool(false),
		"rootBlockDevice": map[string]interface{}{
			"deleteOnTermination": infra.Jsbool(true),
			"encrypted":           infra.Jsbool(true),
			"volumeSize": cdktf.Token_asNumber(cdktf.Fn_lookupNested(aws, []interface{}{
				infra.Js("root_volume_size"),
			})),
			"volumeType": infra.Js("gp3"),
		},
		"tags": map[string]interface{}{
			"Coder_Provisioned": infra.Js("true"),
			"Name":              coderName,
		},
		"userData": userData,
		"vpcSecurityGroupIds": []*string{
			cdktf.Token_AsString(awsSecurityGroupDev.id),
		},
	})

	awsSecretsmanagerSecretDev := secretsmanagersecret.NewSecretsmanagerSecret(this, infra.Js("dev_18"), map[string]*string{
		"name": infra.Js("${" + coderName + "}-${" + awsInstanceDev.id + "}"),
	})

	awsSecretsmanagerSecretVersionDev := secretsmanagersecretversion.NewSecretsmanagerSecretVersion(this, infra.Js("dev_19"), map[string]*string{
		"secretId":     cdktf.Token_AsString(awsSecretsmanagerSecretDev.id),
		"secretString": infra.Js("{coder_agent_token:${" + main.token + "}}"),
	})

	mainCount := cdktf.TerraformCount_Of(cdktf.Token_AsNumber(awsEc2Count))
	coderMetadataMain := metadata.NewMetadata(this, infra.Js("main_20"), &metadataConfig{
		item: []interface{}{
			&metadataItem{
				key:   infra.Js("instance type"),
				value: cdktf.Token_ * AsString(awsInstanceDev.instanceType),
			},
			&metadataItem{
				key: infra.Js("disk"),
				value: infra.Js(cdktf.Token_AsString(cdktf.Fn_LookupNested(awsInstanceDev.rootBlockDevice, []interface{}{
					infra.Js("0"),
					infra.Js("volume_size"),
				})) + " GiB"),
			},
		},
		resourceId: cdktf.Token_ * AsString(awsInstanceDev.id),
		count:      mainCount,
	})

	awsEc2InstanceStateDev := ec2instancestate.NewEc2InstanceState(this, infra.Js("dev_21"), map[string]*string{
		"instanceId": cdktf.Token_AsString(awsInstanceDev.id),
		"state":      cdktf.Token_AsString(cdktf.Conditional(cdktf.Op_Eq(me.transition, infra.Js("start")), infra.Js("running"), infra.Js("stopped"))),
	})

	return this
}
