package main

import (
	_ "embed"
	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/dataawsssoadmininstances"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/identitystoregroup"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/identitystoregroupmembership"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/identitystoreuser"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/organizationsaccount"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/organizationsorganization"
	aws "github.com/cdktf/cdktf-provider-aws-go/aws/v14/provider"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/ssoadminaccountassignment"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/ssoadminmanagedpolicyattachment"
	"github.com/cdktf/cdktf-provider-aws-go/aws/v14/ssoadminpermissionset"
)

//go:embed schema/infra.cue
var infra_schema string

type TerraformCloud struct {
	Organization string `json:"organization"`
	Workspace    string `json:"workspace"`
}

type AwsAdmin struct {
	Name  string `json:"name"`
	Email string `json:"email"`
}

type AwsOrganization struct {
	Name     string     `json:"name"`
	Region   string     `json:"region"`
	Prefix   string     `json:"prefix"`
	Domain   string     `json:"domain"`
	Accounts []string   `json:"accounts"`
	Admins   []AwsAdmin `json:"admins"`
}

type AwsProps struct {
	Terraform     TerraformCloud             `json:"terraform"`
	Organizations map[string]AwsOrganization `json:"organizations"`
}

// alias
func js(s string) *string {
	return jsii.String(s)
}

func jsn(v float64) *float64 {
	return jsii.Number(v)
}

func jsf(s string, a ...any) *string {
	return js(fmt.Sprintf(s, a...))
}

func jstrue() *bool {
	return jsii.Bool(true)
}

func AwsOrganizationStack(scope constructs.Construct, org *AwsOrganization) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, js(org.Name))

	aws.NewAwsProvider(stack,
		js("aws"), &aws.AwsProviderConfig{
			Region:  js(org.Region),
			Profile: js(org.Name),
		})

	organizationsorganization.NewOrganizationsOrganization(stack,
		js("organization"),
		&organizationsorganization.OrganizationsOrganizationConfig{
			FeatureSet: js("ALL"),
			EnabledPolicyTypes: &[]*string{
				js("SERVICE_CONTROL_POLICY"),
				js("TAG_POLICY")},
			AwsServiceAccessPrincipals: &[]*string{
				js("cloudtrail.amazonaws.com"),
				js("config.amazonaws.com"),
				js("ram.amazonaws.com"),
				js("ssm.amazonaws.com"),
				js("sso.amazonaws.com"),
				js("tagpolicies.tag.amazonaws.com")},
		})
	// Lookup pre-enabled AWS SSO instance
	ssoadmin_instance := dataawsssoadmininstances.NewDataAwsSsoadminInstances(stack,
		js("sso_instance"),
		&dataawsssoadmininstances.DataAwsSsoadminInstancesConfig{})

	ssoadmin_instance_arn := cdktf.NewTerraformLocal(stack,
		js("sso_instance_arn"),
		ssoadmin_instance.Arns())

	ssoadmin_permission_set := ssoadminpermissionset.NewSsoadminPermissionSet(stack,
		js("admin_sso_permission_set"),
		&ssoadminpermissionset.SsoadminPermissionSetConfig{
			Name:            js("Administrator"),
			InstanceArn:     js(cdktf.Fn_Element(ssoadmin_instance_arn.Expression(), jsn(0)).(string)),
			SessionDuration: js("PT2H"),
			Tags:            &map[string]*string{"ManagedBy": js("Terraform")},
		})

	sso_permission_set_admin := ssoadminmanagedpolicyattachment.NewSsoadminManagedPolicyAttachment(stack,
		js("admin_sso_managed_policy_attachment"),
		&ssoadminmanagedpolicyattachment.SsoadminManagedPolicyAttachmentConfig{
			InstanceArn:      ssoadmin_permission_set.InstanceArn(),
			PermissionSetArn: ssoadmin_permission_set.Arn(),
			ManagedPolicyArn: js("arn:aws:iam::aws:policy/AdministratorAccess"),
		})

	ssoadmin_instance_isid := cdktf.NewTerraformLocal(stack,
		js("sso_instance_isid"),
		ssoadmin_instance.IdentityStoreIds())

	// Create Administrators group
	identitystore_group := identitystoregroup.NewIdentitystoreGroup(stack,
		js("administrators_sso_group"),
		&identitystoregroup.IdentitystoreGroupConfig{
			DisplayName:     js("Administrators"),
			IdentityStoreId: js(cdktf.Fn_Element(ssoadmin_instance_isid.Expression(), jsn(0)).(string)),
		})

	// Create initial users in the Administrators group
	for _, adm := range org.Admins {
		identitystore_user := identitystoreuser.NewIdentitystoreUser(stack,
			jsf("admin_sso_user_%s", adm.Name),
			&identitystoreuser.IdentitystoreUserConfig{
				DisplayName: js(adm.Name),
				UserName:    js(adm.Name),
				Name: &identitystoreuser.IdentitystoreUserName{
					GivenName:  js(adm.Name),
					FamilyName: js(adm.Name),
				},
				Emails: &identitystoreuser.IdentitystoreUserEmails{
					Primary: jstrue(),
					Type:    js("work"),
					Value:   js(adm.Email),
				},
				IdentityStoreId: js(cdktf.Fn_Element(ssoadmin_instance_isid.Expression(), jsn(0)).(string)),
			})

		identitystoregroupmembership.NewIdentitystoreGroupMembership(stack,
			jsf("admin_sso_user_%s_membership", adm.Name),
			&identitystoregroupmembership.IdentitystoreGroupMembershipConfig{
				MemberId:        identitystore_user.UserId(),
				GroupId:         identitystore_group.GroupId(),
				IdentityStoreId: js(cdktf.Fn_Element(ssoadmin_instance_isid.Expression(), jsn(0)).(string)),
			})
	}

	// The master account (named "org") must be imported.
	for _, acct := range append(org.Accounts, []string{org.Name}...) {
		// Create the organization account
		var organizations_account_config organizationsaccount.OrganizationsAccountConfig

		if acct == org.Name {
			// The master organization account can't set
			// iam_user_access_to_billing, role_name
			organizations_account_config = organizationsaccount.OrganizationsAccountConfig{
				Name:  js(acct),
				Email: jsf("%s%s@%s", org.Prefix, org.Name, org.Domain),
				Tags:  &map[string]*string{"ManagedBy": js("Terraform")},
			}
		} else {
			// Organization account
			organizations_account_config = organizationsaccount.OrganizationsAccountConfig{
				Name:                   js(acct),
				Email:                  jsf("%s%s+%s@%s", org.Prefix, org.Name, acct, org.Domain),
				Tags:                   &map[string]*string{"ManagedBy": js("Terraform")},
				IamUserAccessToBilling: js("ALLOW"),
				RoleName:               js("OrganizationAccountAccessRole"),
			}
		}

		organizations_account := organizationsaccount.NewOrganizationsAccount(stack,
			js(acct),
			&organizations_account_config)

		// Organization accounts grant Administrator permission set to the Administrators group
		ssoadminaccountassignment.NewSsoadminAccountAssignment(stack,
			jsf("%s_admin_sso_account_assignment", acct),
			&ssoadminaccountassignment.SsoadminAccountAssignmentConfig{
				InstanceArn:      sso_permission_set_admin.InstanceArn(),
				PermissionSetArn: sso_permission_set_admin.PermissionSetArn(),
				PrincipalId:      identitystore_group.GroupId(),
				PrincipalType:    js("GROUP"),
				TargetId:         organizations_account.Id(),
				TargetType:       js("AWS_ACCOUNT"),
			})
	}

	return stack
}

func LoadUserAwsProps() AwsProps {
	ctx := cuecontext.New()

	user_schema := ctx.CompileString(infra_schema)

	user_input_instance := load.Instances([]string{"."}, nil)[0]
	user_input := ctx.BuildInstance(user_input_instance)

	user_schema.Unify(user_input)

	var aws_props AwsProps
	user_input.LookupPath(cue.ParsePath("input")).Decode(&aws_props)

	return aws_props
}

func main() {
	aws_props := LoadUserAwsProps()

	fmt.Printf("%v\n", aws_props)

	app := cdktf.NewApp(nil)

	app.Node().SetContext(js("excludeStackIdFromLogicalIds"), "true")
	app.Node().SetContext(js("allowSepCharsInLogicalIds"), "true")

	for _, org := range aws_props.Organizations {
		// Create the aws organization + accounts stack
		aws_org_stack := AwsOrganizationStack(app, &org)

		/*
			cdktf.NewCloudBackend(aws_org_stack, &cdktf.CloudBackendConfig{
				Hostname:     js("app.terraform.io"),
				Organization: js(aws_props.Terraform.Organization),
				Workspaces:   cdktf.NewNamedCloudWorkspace(js(org.Name)),
			})
		*/

		cdktf.NewS3Backend(aws_org_stack, &cdktf.S3BackendConfig{
			Bucket:        js("defn-bootstrap-remote-state"),
			Key:           js(org.Name + "/terraform.tfstate"),
			Encrypt:       jstrue(),
			Region:        js("us-east-2"),
			Profile:       js("terraform"),
			DynamodbTable: js("defn-bootstrap-remote-state"),
		})
	}

	// Emit cdk.tf.json
	app.Synth()
}
