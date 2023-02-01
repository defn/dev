package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
)

func main() {
	cmd := exec.Command("echo", fmt.Sprintf("hello %v\n", os.Args))
	out, err := cmd.Output()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("%s\n", string(out))
}
