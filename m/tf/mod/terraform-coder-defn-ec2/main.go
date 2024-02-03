package meh
	
import "github.com/aws/constructs-go/constructs/v10"
import "github.com/hashicorp/terraform-cdk-go/cdktf"

import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/dataawsami"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/defaultvpc"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/ec2instancestate"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/iaminstanceprofile"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/iamrole"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/iamrolepolicyattachment"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/instance"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/provider"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/secretsmanagersecret"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/secretsmanagersecretversion"
import "github.com/cdktf/cdktf-provider-aws-go/aws/v19/securitygroup"
import "github.com/defn/dev/m/tf/gen/coder/coder/agent"
import "github.com/defn/dev/m/tf/gen/coder/coder/app"
import "github.com/defn/dev/m/tf/gen/coder/coder/datacoderparameter"
import "github.com/defn/dev/m/tf/gen/coder/coder/datacoderworkspace"
import "github.com/defn/dev/m/tf/gen/coder/coder/metadata"
import "github.com/defn/dev/m/tf/gen/coderlogin"

type myConvertedCode struct {
	construct
}

func newMyConvertedCode(scope construct, name *string) *myConvertedCode {
	this := &myConvertedCode{}
	newConstruct_Override(this, scope, name)
	/*Terraform Variables are not always the best fit for getting inputs in the context of Terraform CDK.
	    You can read more about this at https://cdk.tf/variables*/
	tsauthkey := cdktf.NewTerraformVariable(this, jsii.String("tsauthkey"), &TerraformVariableConfig{
	})
	amiFilter := []*string{
		"coder-*",
	}
	owners := []*string{
		"self",
	}
	username := "ubuntu"
	defaultVar := genprovidersawsdefaultvpc.NewDefaultVpc(this, jsii.String("default"), map[string]interface{}{
	})
	ubuntu := genprovidersawsdataawsami.NewDataAwsAmi(this, jsii.String("ubuntu"), map[string]interface{}{
		"filter": []map[string]interface{}{
			map[string]interface{}{
				"name": jsii.String("name"),
				"values": cdktf.Token_asList(amiFilter),
			},
			map[string]interface{}{
				"name": jsii.String("architecture"),
				"values": []*string{
					jsii.String("x86_64"),
				},
			},
		},
		"mostRecent": jsii.Boolean(true),
		"owners": cdktf.Token_asList(owners),
	})
	instanceType := genproviderscoderdatacoderparameter.NewDataCoderParameter(this, jsii.String("instance_type"), &dataCoderParameterConfig{
		default: jsii.String("m6id.large"),
		description: jsii.String("The number of CPUs to allocate to the workspace"),
		displayName: jsii.String("CPU"),
		icon: jsii.String("https://raw.githubusercontent.com/matifali/logos/main/cpu-3.svg"),
		mutable: jsii.Boolean(true),
		name: jsii.String("instance_type"),
		option: []interface{}{
			&dataCoderParameterOption{
				name: jsii.String("2"),
				value: jsii.String("m6id.large"),
			},
			&dataCoderParameterOption{
				name: jsii.String("4"),
				value: jsii.String("m6id.xlarge"),
			},
			&dataCoderParameterOption{
				name: jsii.String("8"),
				value: jsii.String("m6id.2xlarge"),
			},
			&dataCoderParameterOption{
				name: jsii.String("16"),
				value: jsii.String("m6id.4xlarge"),
			},
		},
		type: jsii.String("string"),
	})
	nixVolumeSize := genproviderscoderdatacoderparameter.NewDataCoderParameter(this, jsii.String("nix_volume_size"), &dataCoderParameterConfig{
		default: jsii.String("100"),
		description: jsii.String("The size of the nix volume to create for the workspace in GB"),
		displayName: jsii.String("nix volume size"),
		icon: jsii.String("https://raw.githubusercontent.com/matifali/logos/main/database.svg"),
		mutable: jsii.Boolean(true),
		name: jsii.String("nix_volume_size"),
		type: jsii.String("number"),
		validation: &dataCoderParameterValidation{
			max: jsii.Number(300),
			min: jsii.Number(100),
		},
	})
	provider := genproviderscoderdatacoderparameter.NewDataCoderParameter(this, jsii.String("provider"), &dataCoderParameterConfig{
		default: jsii.String("aws-ec2"),
		description: jsii.String("The service provider to deploy the workspace in"),
		displayName: jsii.String("Provider"),
		icon: jsii.String("/emojis/1f30e.png"),
		mutable: jsii.Boolean(true),
		name: jsii.String("provider"),
		option: []interface{}{
			&dataCoderParameterOption{
				name: jsii.String("Amazon Web Services VM"),
				value: jsii.String("aws-ec2"),
			},
		},
	})
	me := genproviderscoderdatacoderworkspace.NewDataCoderWorkspace(this, jsii.String("me"), &dataCoderWorkspaceConfig{
	})
	aws := map[string]interface{}{
		"availability_zone": jsii.String("us-west-2a"),
		"instance_type": instanceType.value,
		"region": jsii.String("us-west-2"),
		"root_volume_size": nixVolumeSize.value,
	}
	awsEc2Count := cdktf.Conditional(cdktf.Op_Eq(provider.value, jsii.String("aws-ec2")), jsii.Number(1), jsii.Number(0))
	coderName := "coder-${" + me.owner + "}-${" + me.name + "}"
	userData := "Content-Type: multipart/mixed; boundary=\"//\"\nMIME-Version: 1.0\n\n--//\nContent-Type: text/cloud-config; charset=\"us-ascii\"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename=\"cloud-config.txt\"\n\n#cloud-config\nhostname: ${" + coderName + "}\ncloud_final_modules:\n- [scripts-user, always]\n\n--//\nContent-Type: text/x-shellscript; charset=\"us-ascii\"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename=\"userdata.txt\"\n\n#!/bin/bash\n\nset -x\n\necho 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'fs.inotify.max_user_instances = 10000' | sudo tee -a /etc/sysctl.d/99-dfd.conf\necho 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/99-dfd.conf\nsudo sysctl -p /etc/sysctl.d/99-dfd.conf\n\nwhile true; do\n  if test -n \"$(dig +short \"cache.nixos.org\" || true)\"; then\n    break\n  fi\n  sleep 5\ndone\n\nif ! tailscale ip -4 | grep ^100; then\n  sudo tailscale up --accept-dns --accept-routes --authkey=\"${" + tsauthkey.value + "}\" --operator=ubuntu --ssh --timeout 60s # missing --advertise-routes= on reboot\nfi\n\nnohup sudo -H -E -u ${" + username + "} bash -c 'cd && (git pull || true) && cd m && exec bin/user-data.sh ${" + me.accessUrl + "} ${" + coderName + "}' >/tmp/cloud-init.log 2>&1 &\ndisown\n--//--\n\n"
	dev := genprovidersawsiamrole.NewIamRole(this, jsii.String("dev"), map[string]*string{
		"assumeRolePolicy": cdktf.Token_asString(cdktf.Fn_jsonencode(map[string]interface{}{
			"Statement": []map[string]interface{}{
				map[string]interface{}{
					"Action": jsii.String("sts:AssumeRole"),
					"Effect": jsii.String("Allow"),
					"Principal": map[string]*string{
						"Service": jsii.String("ec2.amazonaws.com"),
					},
					"Sid": jsii.String(""),
				},
			},
			"Version": jsii.String("2012-10-17"),
		})),
		"name": coderName,
	})
	genprovidersawsiamrolepolicyattachment.NewIamRolePolicyAttachment(this, jsii.String("admin"), map[string]interface{}{
		"policyArn": jsii.String("arn:aws:iam::aws:policy/AdministratorAccess"),
		"role": dev.name,
	})
	genprovidersawsiamrolepolicyattachment.NewIamRolePolicyAttachment(this, jsii.String("secretsmanager"), map[string]interface{}{
		"policyArn": jsii.String("arn:aws:iam::aws:policy/SecretsManagerReadWrite"),
		"role": dev.name,
	})
	genprovidersawsiamrolepolicyattachment.NewIamRolePolicyAttachment(this, jsii.String("ssm"), map[string]interface{}{
		"policyArn": jsii.String("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"),
		"role": dev.name,
	})
	awsSecurityGroupDev := genprovidersawssecuritygroup.NewSecurityGroup(this, jsii.String("dev_11"), map[string]interface{}{
		"description": coderName,
		"egress": []map[string]interface{}{
			map[string]interface{}{
				"cidrBlocks": []*string{
					jsii.String("0.0.0.0/0"),
				},
				"description": jsii.String("allow all egress"),
				"fromPort": jsii.Number(0),
				"ipv6CidrBlocks": []*string{
					jsii.String("::/0"),
				},
				"protocol": jsii.String("-1"),
				"toPort": jsii.Number(0),
			},
		},
		"ingress": []interface{}{
			map[string]interface{}{
				"cidrBlocks": []*string{
					jsii.String("172.31.32.0/20"),
				},
				"description": jsii.String("allow vpc ingress"),
				"fromPort": jsii.Number(0),
				"protocol": jsii.String("-1"),
				"toPort": jsii.Number(0),
			},
			map[string]interface{}{
				"cidrBlocks": []*string{
					jsii.String("0.0.0.0/0"),
				},
				"description": jsii.String("allow wireguard udp"),
				"fromPort": jsii.Number(41641),
				"ipv6CidrBlocks": []*string{
					jsii.String("::/0"),
				},
				"protocol": jsii.String("udp"),
				"toPort": jsii.Number(41641),
			},
		},
		"name": coderName,
		"tags": map[string]*string{
			"karpenter.sh/discovery": jsii.String("k3d-dfd"),
		},
		"vpcId": defaultVar.id,
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	awsSecurityGroupDev.overrideLogicalId(jsii.String("dev"))
	main := genproviderscoderagent.NewAgent(this, jsii.String("main"), &agentConfig{
		arch: jsii.String("amd64"),
		auth: jsii.String("token"),
		displayApps: &agentDisplayApps{
			sshHelper: jsii.Boolean(false),
			vscode: jsii.Boolean(false),
			vscodeInsiders: jsii.Boolean(false),
		},
		env: map[string]*string{
			"GIT_AUTHOR_EMAIL": cdktf.Token_asString(me.ownerEmail),
			"GIT_AUTHOR_NAME": cdktf.Token_asString(me.owner),
			"GIT_COMMITTER_EMAIL": cdktf.Token_asString(me.ownerEmail),
			"GIT_COMMITTER_NAME": cdktf.Token_asString(me.owner),
			"LC_ALL": jsii.String("C.UTF-8"),
			"LOCAL_ARCHIVE": jsii.String("/usr/lib/locale/locale-archive"),
		},
		os: jsii.String("linux"),
		startupScript: cdktf.Token_AsString(cdktf.Fn_File(jsii.String("${path.module}/startup.sh"))),
		startupScriptTimeout: jsii.Number(180),
	})
	genproviderscoderapp.NewApp(this, jsii.String("code-server"), &appConfig{
		agentId: main.id,
		displayName: jsii.String("code-server"),
		healthcheck: &appHealthcheck{
			interval: jsii.Number(5),
			threshold: jsii.Number(6),
			url: jsii.String("http://localhost:13337/healthz"),
		},
		icon: jsii.String("/icon/code.svg"),
		share: jsii.String("owner"),
		slug: jsii.String("code-server"),
		subdomain: jsii.Boolean(false),
		url: jsii.String("http://localhost:13337/?folder=/home/${" + username + "}/m"),
	})
	genprovidersawsprovider.NewAwsProvider(this, jsii.String("aws"), map[string]*string{
		"region": cdktf.Token_AsString(cdktf.Fn_lookupNested(aws, []interface{}{
			jsii.String("region"),
		})),
	})
	coderLogin.NewCoderLogin(this, jsii.String("coder-login"), map[string]*string{
		"agentId": main.id,
	})
	awsIamInstanceProfileDev := genprovidersawsiaminstanceprofile.NewIamInstanceProfile(this, jsii.String("dev_16"), map[string]interface{}{
		"name": coderName,
		"role": dev.name,
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	awsIamInstanceProfileDev.overrideLogicalId(jsii.String("dev"))
	awsInstanceDev := genprovidersawsinstance.NewInstance(this, jsii.String("dev_17"), map[string]interface{}{
		"ami": cdktf.Token_AsString(ubuntu.id),
		"availabilityZone": cdktf.Token_AsString(cdktf.Fn_lookupNested(aws, []interface{}{
			jsii.String("availability_zone"),
		})),
		"ebsOptimized": jsii.Boolean(true),
		"iamInstanceProfile": cdktf.Token_AsString(awsIamInstanceProfileDev.name),
		"instanceType": cdktf.Token_AsString(cdktf.Fn_lookupNested(aws, []interface{}{
			jsii.String("instance_type"),
		})),
		"metadataOptions": map[string]interface{}{
			"httpEndpoint": jsii.String("enabled"),
			"httpPutResponseHopLimit": jsii.Number(1),
			"httpTokens": jsii.String("required"),
			"instanceMetadataTags": jsii.String("enabled"),
		},
		"monitoring": jsii.Boolean(false),
		"rootBlockDevice": map[string]interface{}{
			"deleteOnTermination": jsii.Boolean(true),
			"encrypted": jsii.Boolean(true),
			"volumeSize": cdktf.Token_asNumber(cdktf.Fn_lookupNested(aws, []interface{}{
				jsii.String("root_volume_size"),
			})),
			"volumeType": jsii.String("gp3"),
		},
		"tags": map[string]interface{}{
			"Coder_Provisioned": jsii.String("true"),
			"Name": coderName,
		},
		"userData": userData,
		"vpcSecurityGroupIds": []*string{
			cdktf.Token_AsString(awsSecurityGroupDev.id),
		},
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	awsInstanceDev.overrideLogicalId(jsii.String("dev"))
	awsSecretsmanagerSecretDev := genprovidersawssecretsmanagersecret.NewSecretsmanagerSecret(this, jsii.String("dev_18"), map[string]*string{
		"name": jsii.String("${" + coderName + "}-${" + awsInstanceDev.id + "}"),
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	awsSecretsmanagerSecretDev.overrideLogicalId(jsii.String("dev"))
	awsSecretsmanagerSecretVersionDev := genprovidersawssecretsmanagersecretversion.NewSecretsmanagerSecretVersion(this, jsii.String("dev_19"), map[string]*string{
		"secretId": cdktf.Token_AsString(awsSecretsmanagerSecretDev.id),
		"secretString": jsii.String("{coder_agent_token:${" + main.token + "}}"),
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	awsSecretsmanagerSecretVersionDev.overrideLogicalId(jsii.String("dev"))
	/*In most cases loops should be handled in the programming language context and
	    not inside of the Terraform context. If you are looping over something external, e.g. a variable or a file input
	    you should consider using a for loop. If you are looping over something only known to Terraform, e.g. a result of a data source
	    you need to keep this like it is.*/
	mainCount := cdktf.TerraformCount_Of(cdktf.Token_AsNumber(awsEc2Count))
	coderMetadataMain := genproviderscodermetadata.NewMetadata(this, jsii.String("main_20"), &metadataConfig{
		item: []interface{}{
			&metadataItem{
				key: jsii.String("instance type"),
				value: cdktf.Token_*AsString(awsInstanceDev.instanceType),
			},
			&metadataItem{
				key: jsii.String("disk"),
				value: jsii.String(cdktf.Token_AsString(cdktf.Fn_LookupNested(awsInstanceDev.rootBlockDevice, []interface{}{
					jsii.String("0"),
					jsii.String("volume_size"),
				})) + " GiB"),
			},
		},
		resourceId: cdktf.Token_*AsString(awsInstanceDev.id),
		count: mainCount,
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	coderMetadataMain.OverrideLogicalId(jsii.String("main"))
	awsEc2InstanceStateDev := genprovidersawsec2instancestate.NewEc2InstanceState(this, jsii.String("dev_21"), map[string]*string{
		"instanceId": cdktf.Token_AsString(awsInstanceDev.id),
		"state": cdktf.Token_AsString(cdktf.Conditional(cdktf.Op_Eq(me.transition, jsii.String("start")), jsii.String("running"), jsii.String("stopped"))),
	})
	/*This allows the Terraform resource name to match the original name. You can remove the call if you don't need them to match.*/
	awsEc2InstanceStateDev.overrideLogicalId(jsii.String("dev"))
	return this
}
