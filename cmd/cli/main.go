// file: cmd/cli/main.go

package main

import (
	"bytes"
	"crypto/tls"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"runtime"

	"github.com/muquit/clip-httpd/pkg/version"
)

// Default host and port values
const (
	me          = "cbcopy"
	defaultHost = "192.168.1.72"
	defaultPort = "8881"
	apiKeyEnv   = "CLIP_HTTPD_APIKEY"
	url         = "https://github.com/muquit/clip-httpd"
)

func main() {
	// 1. Define and parse command-line flags
	host := flag.String("h", defaultHost, "The hostname or IP of the clip-httpd server.")
	port := flag.String("p", defaultPort, "The port number of the clip-httpd server.")
	versionFlag := flag.Bool("version", false, "Print version and exit")
	
    // --- UPDATED SECTION START ---
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, `A remote clipboard copy client for clip-httpd.

This tool reads from standard input and sends the data 
to a clip-httpd server.

Project URL: %s
Compiled with go version: %s

Usage:
  cbcopy [-h host] [-p port]

Options:
`, url, runtime.Version())
		flag.PrintDefaults()
		fmt.Fprintf(os.Stderr, `
Required Environment Variable:
  %s    The secret API key for authentication.

Examples:

  # On Bash (Linux/macOS)
  export %s="your-secret-key"
  echo "hello from cbcopy-httpd!" | cbcopy
  cat file.txt | cbcopy -h 192.168.1.100

  # On Windows Command Prompt
  set %s="your-secret-key"
  echo Hello from CMD | cbcopy
  type file.txt | cbcopy -h 192.168.1.100

  # On PowerShell
  $env:%s = "your-secret-key"
  "Hello from PowerShell" | cbcopy
  Get-Content file.txt | cbcopy -h 192.168.1.100
`, apiKeyEnv, apiKeyEnv, apiKeyEnv, apiKeyEnv)
	}

	flag.Parse()
    if *versionFlag {
        fmt.Printf("%s %s %s\n", me, version.Get(), url)
        os.Exit(0)
    }

	// 2. Security Check: Get API key from environment variable
	apiKey := os.Getenv(apiKeyEnv)
	if apiKey == "" {
		fmt.Fprintf(os.Stderr, "Error: The %s environment variable is not set.\n", apiKeyEnv)
		fmt.Fprintln(os.Stderr, "Please set it before running this tool.")
		os.Exit(1)
	}

	// 3. Read all data from standard input
	inputData, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading from standard input: %v\n", err)
		os.Exit(1)
	}

	if len(inputData) == 0 {
		return
	}

	// 4. Construct the URL
	url := fmt.Sprintf("https://%s:%s", *host, *port)

	// 5. Create a custom HTTP client to replicate `curl -k` (insecure)
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}

	// 6. Create the POST request with the input data as the body
	req, err := http.NewRequest("POST", url, bytes.NewReader(inputData))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating request: %v\n", err)
		os.Exit(1)
	}

	// 7. Set the custom API key header
	req.Header.Set("X-Api-Key", apiKey)
	req.Header.Set("Content-Type", "application/octet-stream")

	// 8. Execute the request
	resp, err := client.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error sending request to %s: %v\n", url, err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	// 9. Check the server's response status
	if resp.StatusCode != http.StatusOK {
		fmt.Fprintf(os.Stderr, "Error: Server responded with status: %s\n", resp.Status)
		os.Exit(1)
	}
}
