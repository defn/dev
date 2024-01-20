package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"crypto/tls"
	"time"

	"github.com/botanica-consulting/wiredialer"
)

func main() {
	d, err := wiredialer.NewDialerFromFile(os.Args[1])
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	client := &http.Client{
		Transport: &http.Transport{
			DialContext: d.DialContext,
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
		},
	}

	resp, err := client.Get(os.Args[2])
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	io.Copy(os.Stdout, resp.Body)

	time.Sleep(2 * time.Second)
}
