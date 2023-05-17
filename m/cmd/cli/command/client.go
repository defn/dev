package command

import (
	"context"
	"log"
	"net/http"

	"github.com/spf13/cobra"

	"github.com/bufbuild/connect-go"

	demov1 "github.com/defn/dev/m/a/demo/v1"
	"github.com/defn/dev/m/a/demo/v1/demov1connect"
)

var clientCmd = &cobra.Command{
	Use:   "client",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		client := demov1connect.NewPetStoreServiceClient(
			http.DefaultClient,
			"http://localhost:8080",
		)
		res, err := client.PutPet(
			context.Background(),
			connect.NewRequest(&demov1.PutPetRequest{
				PetType: demov1.PetType_PET_TYPE_SNAKE,
				Name:    "Ekans",
			}),
		)
		if err != nil {
			log.Println(err)
			return
		}
		log.Println(res.Msg)
	},
}

func init() {
	rootCmd.AddCommand(clientCmd)
}
