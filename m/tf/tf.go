package main

import (
	_ "embed"

	"github.com/spf13/cobra"

	"github.com/bitfield/script"

	"github.com/hashicorp/terraform-cdk-go/cdktf"

	infra "github.com/defn/dev/m/command/infra"
	root "github.com/defn/dev/m/command/root"
)

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

			CoderDefnEc2Stack(app, &site, "template")

			app.Synth()
		},
	})
}

func main() {
	script.ListFiles("*.cue").Stdout()
	root.Execute()
}
