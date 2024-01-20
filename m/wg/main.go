package main

import (
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/botanica-consulting/wiredialer"
)

func main() {
	// Create a new Dialer based on a WireGuard configuration file
	d, err := wiredialer.NewDialerFromFile("wg0.conf")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Create a new HTTP client that uses the Dialer
	client := &http.Client{
		Transport: &http.Transport{
			DialContext: d.DialContext,
		},
	}

	// Make a request
	resp, err := client.Get("http://ifconfig.co/city")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	// Print the response body
	io.Copy(os.Stdout, resp.Body)

}
