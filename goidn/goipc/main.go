package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
)

func main() {

	// get the command from the command line
	args := os.Args[1:]
	if len(args) == 0 {
		fmt.Println("Please provide a command to run.")
		return
	}

	// Prepare the command to run (e.g., a simple shell)
	cmd := exec.Command(args[0])

	// Get a pipe to the command's stdin
	stdin, err := cmd.StdinPipe()
	if err != nil {
		panic(err)
	}

	// Get a pipe to the command's stdout
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		panic(err)
	}

	// Start the command
	if err := cmd.Start(); err != nil {
		panic(err)
	}

	// Create a writer to send input to the process
	go func() {
		fmt.Fprintln(stdin, "español.com")
		stdin.Close() // Close stdin to indicate EOF
	}()

	// Read output from the process
	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		fmt.Println("Output:", scanner.Text())
	}

	// Wait for the process to finish
	if err := cmd.Wait(); err != nil {
		panic(err)
	}
}
