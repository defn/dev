package tf

import (
	"fmt"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	aws "github.com/cdktf/cdktf-provider-aws-go/aws/v19/provider"

	"github.com/defn/dev/m/tf/gen/terraform_aws_defn_account"

	"github.com/defn/dev/m/infra"
)

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
			Profile: infra.Js(fmt.Sprintf("%s-%s-sso-source", org.Name, acc.Profile)),
		})

	terraform_aws_defn_account.NewTerraformAwsDefnAccount(stack,
		infra.Js(fmt.Sprintf("%s-%s", org.Name, acc.Profile)), &terraform_aws_defn_account.TerraformAwsDefnAccountConfig{
			Providers:                         &[]interface{}{provider},
			Namespace:                         infra.Js(org.Name),
			Stage:                             infra.Js("ops"),
			Name:                              infra.Js("terraform"),
			Account:                           infra.Js(org.OpsAccountID),
			SkipAssetCreationFromLocalModules: infra.Jstrue(),
		})

	return stack
}
