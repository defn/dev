package command

import (
	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"

	"github.com/hashicorp/terraform-cdk-go/cdktf"

	"github.com/spf13/cobra"

	"github.com/defn/dev/m/infra"
	"github.com/defn/dev/m/tf"

	root "github.com/defn/dev/m/command/root"
)

func LoadUserAwsProps(infra_schema string) infra.AwsProps {
	ctx := cuecontext.New()

	user_schema := ctx.CompileString(infra_schema)

	user_input_instance := load.Instances([]string{"."}, nil)[0]
	user_input := ctx.BuildInstance(user_input_instance)

	user_schema.Unify(user_input)

	var aws_props infra.AwsProps
	user_input.LookupPath(cue.ParsePath("input")).Decode(&aws_props)

	return aws_props
}

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "infra",
		Short: "Generates Terraform configs from CUE",
		Long:  `Generates Terraform configs from CUE.`,

		Run: func(cmd *cobra.Command, args []string) {
			site := LoadUserAwsProps("")
			app := cdktf.NewApp(&cdktf.AppConfig{})

			for _, org := range site.Organization {
				tf.AwsOrganizationStack(app, &site, &org)

				for _, acc := range org.Accounts {
					tf.AwsAccountStack(app, &site, &org, &acc)
				}
			}

			tf.GlobalStack(app, &site)

			app.Synth()
		},
	})
}
