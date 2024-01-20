package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"crypto/tls"

	"github.com/botanica-consulting/wiredialer"
)

func main() {
	// Create a new Dialer based on a WireGuard configuration file
	d, err := wiredialer.NewDialerFromFile(os.Args[1])
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Create a new HTTP client that uses the Dialer
	client := &http.Client{
		Transport: &http.Transport{
			DialContext: d.DialContext,
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
		},
	}

	// Make a request
	resp, err := client.Get(os.Args[2])
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	// Print the response body
	io.Copy(os.Stdout, resp.Body)

}
