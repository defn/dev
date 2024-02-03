package main

import (
	"fmt"

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
