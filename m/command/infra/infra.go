package command

import (
	_ "embed"

	"fmt"

	"github.com/spf13/cobra"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	aws "github.com/defn/cdktf-provider-aws-go/gen/aws/provider"

	"github.com/defn/cdktf-provider-aws-go/gen/aws/dataawsssoadmininstances"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/identitystoregroup"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/identitystoregroupmembership"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/identitystoreuser"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/organizationsaccount"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/organizationsorganization"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/ssoadminaccountassignment"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/ssoadminmanagedpolicyattachment"
	"github.com/defn/cdktf-provider-aws-go/gen/aws/ssoadminpermissionset"

	root "github.com/defn/dev/m/command/root"
	// aws_eks_cluster "github.com/defn/dev/m/tf/gen/terraform_aws_eks_cluster"
)

//go:embed infra.cue
var infra_schema string

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

type KubernetesCluster struct {
	Name   string
	Region string `json:"region"`

	NodeGroup map[string]KubernetesNodeGroup `json:"nodegroup"`

	VPC struct {
		CIDRs []string `json:"cidrs"`
	} `json:"vpc"`
}

type KubernetesNodeGroup struct {
	Name string

	InstanceTypes []string `json:"instance_types"`

	AZ map[string]AWSVPCNetwork `json:"az"`
}

type AWSVPCNetwork struct {
	Network string `json:"network"`
}

type AwsProps struct {
	Organization map[string]AwsOrganization `json:"organization"`

	Kubernetes map[string]KubernetesCluster `json:"kubernetes"`
}

// alias
func js(s string) *string {
	return jsii.String(s)
}

//lint:ignore U1000 utility
func jsn(v float64) *float64 {
	return jsii.Number(v)
}

//lint:ignore U1000 utility
func jsf(s string, a ...any) *string {
	return js(fmt.Sprintf(s, a...))
}

//lint:ignore U1000 utility
func jstrue() *bool {
	return jsii.Bool(true)
}

// infraCmd represents the infra command
var infraCmd = &cobra.Command{
	Use:   "infra",
	Short: "Generates Terraform configs from CUE",
	Long:  `Generates Terraform configs from CUE.`,
	Run: func(cmd *cobra.Command, args []string) {
		aws_props := LoadUserAwsProps()

		fmt.Printf("%v\n", aws_props)

		app := cdktf.NewApp(&cdktf.AppConfig{})

		for _, org := range aws_props.Organization {
			aws_org_stack := AwsOrganizationStack(app, &org)

			cdktf.NewS3Backend(aws_org_stack, &cdktf.S3BackendConfig{
				Bucket:        js("dfn-defn-terraform-state"),
				Key:           js("stacks/" + org.Name + "/terraform.tfstate"),
				Encrypt:       jstrue(),
				Region:        js("us-east-1"),
				Profile:       js("defn-org-sso"),
				DynamodbTable: js("dfn-defn-terraform-state-lock"),
			})
		}

		app.Synth()
	},
}

func init() {
	root.RootCmd.AddCommand(infraCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// infraCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// infraCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

func AwsOrganizationStack(scope constructs.Construct, org *AwsOrganization) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, js(org.Name))

	aws.NewAwsProvider(stack,
		js("aws"), &aws.AwsProviderConfig{
			Region:  js(org.Region),
			Profile: js(fmt.Sprintf("%s-org-sso", org.Name)),
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

	/*
		aws_eks_cluster.NewTerraformAwsEksCluster(stack,
			jsf("cool"),
			&aws_eks_cluster.TerraformAwsEksClusterConfig{
				SubnetIds: &[]*string{js("meh")},
				VpcId: js("meh"),
			})
	*/

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
