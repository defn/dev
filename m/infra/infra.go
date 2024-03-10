package main

import (
	_ "embed"

	"github.com/spf13/cobra"

	"github.com/hashicorp/terraform-cdk-go/cdktf"

	infra "github.com/defn/dev/m/command/infra"
	root "github.com/defn/dev/m/command/root"
	tf "github.com/defn/dev/m/tf"
)

//go:embed schema.cue
var schema string

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "build",
		Short: "Generates Terraform configs from CUE",
		Long:  `Generates Terraform configs from CUE.`,

		Run: func(cmd *cobra.Command, args []string) {
			site := infra.LoadUserAwsProps(schema)
			app := cdktf.NewApp(&cdktf.AppConfig{})

			for _, org := range site.Organization {
				tf.AwsOrganizationStack(app, &site, &org)

				for _, acc := range org.Accounts {
					tf.AwsAccountStack(app, &site, &org, &acc)
				}
			}

			//tf.GlobalStack(app, &site)

			tf.CoderDefnEc2Stack(app, &site, "template")

			app.Synth()
		},
	})
}

func main() {
	root.Execute()
}
