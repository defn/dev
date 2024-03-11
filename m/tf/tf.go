package tf

import (
	_ "embed"

	"github.com/spf13/cobra"

	"github.com/hashicorp/terraform-cdk-go/cdktf"

	infra "github.com/defn/dev/m/command/infra"
	root "github.com/defn/dev/m/command/root"
)

func Init(schema string) {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "build",
		Short: "Generates Terraform configs from CUE",
		Long:  `Generates Terraform configs from CUE.`,

		Run: func(cmd *cobra.Command, args []string) {
			site := infra.LoadUserAwsProps(schema)
			app := cdktf.NewApp(&cdktf.AppConfig{})

			for _, org := range site.Organization {
				AwsOrganizationStack(app, &site, &org)

				for _, acc := range org.Accounts {
					AwsAccountStack(app, &site, &org, &acc)
				}
			}

			app.Synth()
		},
	})
}

func Execute() {
	root.Execute()
}