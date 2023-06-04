package command

// buf curl --schema proto/pet/v1/pet.proto --data '{"pet_type": "PET_TYPE_SNAKE", "name": "Ekans"}' http://localhost:8080/pet.v1.PetStoreService/PutPet

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/spf13/cobra"

	"github.com/bufbuild/connect-go"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	demov1 "github.com/defn/dev/m/a/demo/v1"
	"github.com/defn/dev/m/a/demo/v1/demov1connect"
)

var serverCmd = &cobra.Command{
	Use:   "server",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		mux := http.NewServeMux()
		path, handler := demov1connect.NewPetStoreServiceHandler(&petStoreServiceServer{})
		mux.Handle(path, handler)
		fmt.Println("... Listening on", address)
		http.ListenAndServe(
			address,
			// Use h2c so we can serve HTTP/2 without TLS.
			h2c.NewHandler(mux, &http2.Server{}),
		)
	},
}

func init() {
	rootCmd.AddCommand(serverCmd)
}

const address = "localhost:8080"

// petStoreServiceServer implements the PetStoreService API.
type petStoreServiceServer struct {
	demov1connect.UnimplementedPetStoreServiceHandler
}

// PutPet adds the pet associated with the given request into the PetStore.
func (s *petStoreServiceServer) PutPet(
	ctx context.Context,
	req *connect.Request[demov1.PutPetRequest],
) (*connect.Response[demov1.PutPetResponse], error) {
	name := req.Msg.GetName()
	petType := req.Msg.GetPetType()
	log.Printf("Got a request to create a %v named %s", petType, name)
	meh := demov1.Pet{Name: name}
	return connect.NewResponse(&demov1.PutPetResponse{Pet: &meh}), nil
}
