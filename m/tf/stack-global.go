package main

import (
	_ "embed"
	"sort"

	"fmt"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	aws "github.com/cdktf/cdktf-provider-aws-go/aws/v19/provider"

	"github.com/defn/dev/m/tf/gen/terraform_aws_s3_bucket"

	infra "github.com/defn/dev/m/command/infra"
)

func ToTerraformAwsS3BucketConfig(org *infra.AwsOrganization, acc *infra.AwsAccount, provider *aws.AwsProvider) *terraform_aws_s3_bucket.TerraformAwsS3BucketConfig {
	return &terraform_aws_s3_bucket.TerraformAwsS3BucketConfig{
		Providers: &[]interface{}{*provider},

		Enabled:    acc.Cfg.Enabled,
		Namespace:  acc.Cfg.Namespace,
		Stage:      acc.Cfg.Stage,
		Name:       acc.Cfg.Name,
		Attributes: acc.Cfg.Attributes,

		Acl:               acc.Cfg.Acl,
		UserEnabled:       acc.Cfg.UserEnabled,
		VersioningEnabled: acc.Cfg.VersioningEnabled,

		SkipAssetCreationFromLocalModules: infra.Jstrue(),
	}
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

			terraform_aws_s3_bucket.NewTerraformAwsS3Bucket(stack, acc.Cfg.Id, ToTerraformAwsS3BucketConfig(&org, &acc, &provider))
		}
	}

	return stack
}
