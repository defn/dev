package main

import (
	"log"
	"os"
	"os/exec"
	"syscall"
)

func main() {
	args := []string{"mise", "exec", "--", "cloudflared", "tunnel", "--no-autoupdate", "run"}

	fname, err := exec.LookPath(args[0])
	if err != nil {
		log.Fatalf("lookup failed: %v", err)
	}

	env := os.Environ()
	if err := syscall.Exec(fname, args, env); err != nil {
		log.Fatalf("exec failed: %v", err)
	}
}
