package main

import (
	"fmt"

	"github.com/bitfield/script"
)

func main() {
	numLines, err := script.File("main.go").CountLines()
	if err != nil {
		return
	}

	fmt.Printf("Number of lines %d\n", numLines)
}
