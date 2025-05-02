package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"golang.org/x/net/idna"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		input := strings.TrimSpace(scanner.Text())
		if input == "" {
			continue
		}
		ascii, err := idna.ToASCII(input)
		if err != nil {
			continue // silently skip invalid lines
		}
		fmt.Println(ascii)
	}
}
