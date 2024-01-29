package main

import (
	_ "embed"
	"sort"

	"fmt"

	"github.com/spf13/cobra"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	aws "github.com/cdktf/cdktf-provider-aws-go/aws/v19/provider"

	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/dataawsssoadmininstances"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/identitystoregroup"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/identitystoregroupmembership"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/identitystoreuser"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/organizationsaccount"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/organizationsorganization"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/ssoadminaccountassignment"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/ssoadminmanagedpolicyattachment"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v19/ssoadminpermissionset"

	infra "github.com/defn/dev/m/command/infra"
	root "github.com/defn/dev/m/command/root"

	"github.com/defn/dev/m/tf/gen/terraform_aws_defn_account"
	"github.com/defn/dev/m/tf/gen/terraform_aws_s3_bucket"
)

func AwsOrganizationStack(scope constructs.Construct, site *infra.AwsProps, org *infra.AwsOrganization) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, infra.Js(fmt.Sprintf("org-%s", org.Name)))

	cdktf.NewS3Backend(stack, &cdktf.S3BackendConfig{
		Key:           infra.Js(fmt.Sprintf("stacks/org-%s/terraform.tfstate", org.Name)),
		Encrypt:       infra.Jstrue(),
		Bucket:        &site.Backend.Bucket,
		Region:        &site.Backend.Region,
		Profile:       &site.Backend.Profile,
		DynamodbTable: &site.Backend.Lock,
	})

	aws.NewAwsProvider(stack,
		infra.Js("aws"), &aws.AwsProviderConfig{
			Region:  infra.Js(org.Region),
			Profile: infra.Js(fmt.Sprintf("%s-org-sso", org.Name)),
		})

	organizationsorganization.NewOrganizationsOrganization(stack,
		infra.Js("organization"),
		&organizationsorganization.OrganizationsOrganizationConfig{
			FeatureSet: infra.Js("ALL"),
			EnabledPolicyTypes: &[]*string{
				infra.Js("SERVICE_CONTROL_POLICY"),
				infra.Js("TAG_POLICY")},
			AwsServiceAccessPrincipals: &[]*string{
				infra.Js("cloudtrail.amazonaws.com"),
				infra.Js("config.amazonaws.com"),
				infra.Js("ram.amazonaws.com"),
				infra.Js("ssm.amazonaws.com"),
				infra.Js("sso.amazonaws.com"),
				infra.Js("tagpolicies.tag.amazonaws.com")},
		})

	// Lookup pre-enabled AWS SSO instance
	ssoadmin_instance := dataawsssoadmininstances.NewDataAwsSsoadminInstances(stack,
		infra.Js("sso_instance"),
		&dataawsssoadmininstances.DataAwsSsoadminInstancesConfig{})

	ssoadmin_instance_arn := cdktf.NewTerraformLocal(stack,
		infra.Js("sso_instance_arn"),
		ssoadmin_instance.Arns())

	ssoadmin_permission_set := ssoadminpermissionset.NewSsoadminPermissionSet(stack,
		infra.Js("admin_sso_permission_set"),
		&ssoadminpermissionset.SsoadminPermissionSetConfig{
			Name:            infra.Js("Administrator"),
			InstanceArn:     infra.Js(cdktf.Fn_Element(ssoadmin_instance_arn.Expression(), infra.Jsn(0)).(string)),
			SessionDuration: infra.Js("PT2H"),
			Tags:            &map[string]*string{"ManagedBy": infra.Js("Terraform")},
		})

	sso_permission_set_admin := ssoadminmanagedpolicyattachment.NewSsoadminManagedPolicyAttachment(stack,
		infra.Js("admin_sso_managed_policy_attachment"),
		&ssoadminmanagedpolicyattachment.SsoadminManagedPolicyAttachmentConfig{
			InstanceArn:      ssoadmin_permission_set.InstanceArn(),
			PermissionSetArn: ssoadmin_permission_set.Arn(),
			ManagedPolicyArn: infra.Js("arn:aws:iam::aws:policy/AdministratorAccess"),
		})

	ssoadmin_instance_isid := cdktf.NewTerraformLocal(stack,
		infra.Js("sso_instance_isid"),
		ssoadmin_instance.IdentityStoreIds())

	// Create Administrators group
	identitystore_group := identitystoregroup.NewIdentitystoreGroup(stack,
		infra.Js("administrators_sso_group"),
		&identitystoregroup.IdentitystoreGroupConfig{
			DisplayName:     infra.Js("Administrators"),
			IdentityStoreId: infra.Js(cdktf.Fn_Element(ssoadmin_instance_isid.Expression(), infra.Jsn(0)).(string)),
		})

	// Create initial users in the Administrators group
	for _, adm := range org.Admins {
		identitystore_user := identitystoreuser.NewIdentitystoreUser(stack,
			infra.Jsf("admin_sso_user_%s", adm.Name),
			&identitystoreuser.IdentitystoreUserConfig{
				DisplayName: infra.Js(adm.Name),
				UserName:    infra.Js(adm.Name),
				Name: &identitystoreuser.IdentitystoreUserName{
					GivenName:  infra.Js(adm.Name),
					FamilyName: infra.Js(adm.Name),
				},
				Emails: &identitystoreuser.IdentitystoreUserEmails{
					Primary: infra.Jstrue(),
					Type:    infra.Js("work"),
					Value:   infra.Js(adm.Email),
				},
				IdentityStoreId: infra.Js(cdktf.Fn_Element(ssoadmin_instance_isid.Expression(), infra.Jsn(0)).(string)),
			})

		identitystoregroupmembership.NewIdentitystoreGroupMembership(stack,
			infra.Jsf("admin_sso_user_%s_membership", adm.Name),
			&identitystoregroupmembership.IdentitystoreGroupMembershipConfig{
				MemberId:        identitystore_user.UserId(),
				GroupId:         identitystore_group.GroupId(),
				IdentityStoreId: infra.Js(cdktf.Fn_Element(ssoadmin_instance_isid.Expression(), infra.Jsn(0)).(string)),
			})
	}

	// The master account (named "org") must be imported.
	for _, acct := range org.Accounts {
		// Create the organization account
		var organizations_account_config organizationsaccount.OrganizationsAccountConfig

		if acct.Name == org.Name {
			// The master organization account can't set
			// iam_user_access_to_billing, role_name
			organizations_account_config = organizationsaccount.OrganizationsAccountConfig{
				Name:  infra.Js(fmt.Sprintf("%s%s", acct.Prefix, acct.Name)),
				Email: infra.Jsf(acct.Email),
				Tags:  &map[string]*string{"ManagedBy": infra.Js("Terraform")},
			}
		} else {
			// Organization account
			if acct.Imported == "yes" {
				organizations_account_config = organizationsaccount.OrganizationsAccountConfig{
					Name:  infra.Js(fmt.Sprintf("%s%s", acct.Prefix, acct.Name)),
					Email: infra.Jsf(acct.Email),
					Tags:  &map[string]*string{"ManagedBy": infra.Js("Terraform")},
				}
			} else {
				organizations_account_config = organizationsaccount.OrganizationsAccountConfig{
					Name:                   infra.Js(fmt.Sprintf("%s%s", acct.Prefix, acct.Name)),
					Email:                  infra.Jsf(acct.Email),
					Tags:                   &map[string]*string{"ManagedBy": infra.Js("Terraform")},
					IamUserAccessToBilling: infra.Js("ALLOW"),
					RoleName:               infra.Js("OrganizationAccountAccessRole"),
				}
			}
		}

		organizations_account := organizationsaccount.NewOrganizationsAccount(stack,
			infra.Js(acct.Name),
			&organizations_account_config)

		// Organization accounts grant Administrator permission set to the Administrators group
		ssoadminaccountassignment.NewSsoadminAccountAssignment(stack,
			infra.Jsf("%s_admin_sso_account_assignment", acct.Name),
			&ssoadminaccountassignment.SsoadminAccountAssignmentConfig{
				InstanceArn:      sso_permission_set_admin.InstanceArn(),
				PermissionSetArn: sso_permission_set_admin.PermissionSetArn(),
				PrincipalId:      identitystore_group.GroupId(),
				PrincipalType:    infra.Js("GROUP"),
				TargetId:         organizations_account.Id(),
				TargetType:       infra.Js("AWS_ACCOUNT"),
			})
	}

	return stack
}

func AwsAccountStack(scope constructs.Construct, site *infra.AwsProps, org *infra.AwsOrganization, acc *infra.AwsAccount) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, infra.Js(fmt.Sprintf("acc-%s-%s", org.Name, acc.Profile)))

	cdktf.NewS3Backend(stack, &cdktf.S3BackendConfig{
		Key:           infra.Js(fmt.Sprintf("stacks/acc-%s-%s/terraform.tfstate", org.Name, acc.Profile)),
		Encrypt:       infra.Jstrue(),
		Bucket:        &site.Backend.Bucket,
		Region:        &site.Backend.Region,
		Profile:       &site.Backend.Profile,
		DynamodbTable: &site.Backend.Lock,
	})

	provider := aws.NewAwsProvider(stack,
		infra.Js("aws"), &aws.AwsProviderConfig{
			Alias:   infra.Js(fmt.Sprintf("%s-%s", org.Name, acc.Profile)),
			Profile: infra.Js(fmt.Sprintf("%s-%s-sso", org.Name, acc.Profile)),
		})

	terraform_aws_defn_account.NewTerraformAwsDefnAccount(stack,
		infra.Js(fmt.Sprintf("%s-%s", org.Name, acc.Profile)), &terraform_aws_defn_account.TerraformAwsDefnAccountConfig{
			Providers: &[]interface{}{provider},
			Namespace: infra.Js("dfn"),
			Stage:     infra.Js("defn"),
			Name:      infra.Js("terraform"),
		})

	return stack
}

func GlobalStack(scope constructs.Construct, site *infra.AwsProps) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, infra.Js("global"))

	cdktf.NewS3Backend(stack, &cdktf.S3BackendConfig{
		Key:           infra.Js("stacks/global/terraform.tfstate"),
		Encrypt:       infra.Jstrue(),
		Bucket:        &site.Backend.Bucket,
		Region:        &site.Backend.Region,
		Profile:       &site.Backend.Profile,
		DynamodbTable: &site.Backend.Lock,
	})

	var keys []string
	for key := range site.Organization {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	for _, org_name := range keys {
		org := site.Organization[org_name]
		for _, acc := range org.Accounts {
			provider := aws.NewAwsProvider(stack,
				infra.Js(fmt.Sprintf("aws-global-%s-%s", org_name, acc.Profile)), &aws.AwsProviderConfig{
					Alias:   infra.Js(fmt.Sprintf("%s-%s", org_name, acc.Profile)),
					Profile: infra.Js(fmt.Sprintf("%s-sso", "defn-org")),
					Region:  infra.Js("us-east-1"),
					AssumeRole: []interface{}{
						aws.AwsProviderAssumeRole{
							RoleArn: infra.Js(fmt.Sprintf("arn:aws:iam::%s:role/dfn-defn-terraform", site.Info[org_name].Account[acc.Profile].Id)),
						},
					},
				},
			)

			terraform_aws_s3_bucket.NewTerraformAwsS3Bucket(stack,
				infra.Js(fmt.Sprintf("s3-%s-%s", org_name, acc.Profile)), &terraform_aws_s3_bucket.TerraformAwsS3BucketConfig{
					Providers:  &[]interface{}{provider},
					Enabled:    infra.Jstrue(),
					Namespace:  infra.Js("dfn"),
					Stage:      infra.Js("defn"),
					Name:       infra.Js("global"),
					Attributes: &[]*string{infra.Js(fmt.Sprintf("%s-%s", org_name, acc.Profile))},

					Acl:                         infra.Js("private"),
					UserEnabled:                 infra.Jsfalse(),
					VersioningEnabled:           infra.Jsfalse(),
					LifecycleConfigurationRules: nil,
				})
		}
	}

	return stack
}

//go:embed tf.cue
var infra_schema string

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "infra",
		Short: "Generates Terraform configs from CUE",
		Long:  `Generates Terraform configs from CUE.`,

		Run: func(cmd *cobra.Command, args []string) {
			site := infra.LoadUserAwsProps(infra_schema)
			app := cdktf.NewApp(&cdktf.AppConfig{})

			for _, org := range site.Organization {
				AwsOrganizationStack(app, &site, &org)

				for _, acc := range org.Accounts {
					AwsAccountStack(app, &site, &org, &acc)
				}
			}

			GlobalStack(app, &site)

			app.Synth()
		},
	})
}

func main() {
	root.Execute()
}
