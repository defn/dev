package command

import (
	_ "embed"

	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
	"github.com/hashicorp/terraform-cdk-go/cdktf"

	tfe "github.com/cdktf/cdktf-provider-tfe-go/tfe/v5/provider"
	"github.com/spf13/cobra"
)

// infraCmd represents the infra command
var infraCmd = &cobra.Command{
	Use:   "infra",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		example_props := LoadUserExampleProps()

		if example_props == (ExampleProps{}) {
			fmt.Printf("Error: for details, run: cue vet main.cue command/infra.cue\n")
			return
		}

		fmt.Printf("%v\n", example_props)

		app := cdktf.NewApp(nil)

		app.Node().SetContext(js("excludeStackIdFromLogicalIds"), "true")
		app.Node().SetContext(js("allowSepCharsInLogicalIds"), "true")

		workspaces := ExampleStack(app, example_props.Terraform.Workspace)
		cdktf.NewCloudBackend(workspaces, &cdktf.CloudBackendConfig{
			Hostname:     js("app.terraform.io"),
			Organization: js(example_props.Terraform.Organization),
			Workspaces:   cdktf.NewNamedCloudWorkspace(js(example_props.Terraform.Workspace)),
		})

		// Emit cdk.tf.json
		app.Synth()
	},
}

func init() {
	rootCmd.AddCommand(infraCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// infraCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// infraCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

//go:embed infra.cue
var infra_schema_cue string

type ExampleProps struct {
	Terraform TerraformCloud `json:"terraform"`
	Dog       DogAnimal      `json:"dog"`
	Cat       CatAnimal      `json:"cat"`
}

type TerraformCloud struct {
	Organization string `json:"organization"`
	Workspace    string `json:"workspace"`
}

type CatAnimal struct {
	Name string `json:"name"`
}

type DogAnimal struct {
	Name string `json:"name"`
}

//lint:ignore U1000 utility
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

func ExampleStack(scope constructs.Construct, id string) cdktf.TerraformStack {
	stack := cdktf.NewTerraformStack(scope, js(id))

	tfe.NewTfeProvider(stack, js("tfe"), &tfe.TfeProviderConfig{
		Hostname: js("app.terraform.io"),
	})

	return stack
}

func LoadUserExampleProps() ExampleProps {
	ctx := cuecontext.New()

	user_schema := ctx.CompileString(infra_schema_cue)

	user_input_instance := load.Instances([]string{"."}, nil)[0]
	user_input := ctx.BuildInstance(user_input_instance)

	unified_input := user_schema.Unify(user_input)

	var example_props ExampleProps
	unified_input.LookupPath(cue.ParsePath("input")).Decode(&example_props)

	return example_props
}
