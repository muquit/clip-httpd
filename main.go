package main

///////////////////////////////////////////////////////////////////////
// A simple and secure clipboard server. My desktop is Mac but I use
// iterm2/mosh/tmux to connect to various remote machines and need to
// copy text/file from remote machines to my Mac's clipboard, even
// from dumpb terminals. I had issues mixing clipboard copy with iterm2,
// tmux, vim etc. That's the reason I wrote it. It runs on my mac and
// I copy text to/ mac clipboard using curl over https.
// With assistance from:
//    Google Gemini AI 2.5 Pro
//    Claude AI Sonnet 4
// To compile with systray support:
//    go build -tags systray .
//	  or 
//    make native
// start with -systray flag as well
// muquit@muquit.com Sep-14-2025 - first cut
///////////////////////////////////////////////////////////////////////
import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"syscall"
	"os/signal"
	"runtime"

	"github.com/atotto/clipboard"
	"github.com/joho/godotenv"
)

const (
	version = "v1.0.1"
	me      = "clip-httpd"
	url     = "https://github.com/muquit/clip-httpd"
)

// clipboard handler
func clipboardHandler(apiKey string, copyCommand string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("X-Api-Key") != apiKey {
			log.Printf("Failed auth attempt from %s", r.RemoteAddr)
			http.Error(w, "Unauthorized.", http.StatusUnauthorized)
			return
		}
		if r.Method != http.MethodPost {
			http.Error(w, "Invalid request method. Only POST is accepted.", http.StatusMethodNotAllowed)
			return
		}
		defer r.Body.Close()
		postData, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "Failed to read request body.", http.StatusInternalServerError)
			log.Printf("Error reading request body: %v", err)
			return
		}

		// Use custom copy command for whatever reason, it can be script or some other
		// third party CLI or something you wrote.
		if copyCommand != "" {
			// Use custom command - supports binary data
			cmd := exec.Command("sh", "-c", copyCommand)
			cmd.Stdin = bytes.NewReader(postData)
			if err := cmd.Run(); err != nil {
				errMsg := fmt.Sprintf("Failed to execute copy command '%s': %v", copyCommand, err)
				http.Error(w, errMsg, http.StatusInternalServerError)
				log.Println(errMsg)
				return
			}
			log.Printf("Copied %d bytes to clipboard using custom command '%s' from %s.", len(postData), copyCommand, r.RemoteAddr)
		} else {
			// Use default clipboard module - text only
			if err := clipboard.WriteAll(string(postData)); err != nil {
				errMsg := fmt.Sprintf("Failed to write to clipboard: %v", err)
				http.Error(w, errMsg, http.StatusInternalServerError)
				log.Println(errMsg)
				return
			}
			log.Printf("Copied %d bytes to clipboard from %s.", len(postData), r.RemoteAddr)
		}

		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "Successfully copied %d bytes to clipboard.\n", len(postData))
	}
}

func main() {
	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(),
			"%s %s - A simple, secure, cross-platform clipboard server.\n", me, version)
		fmt.Printf("Compiled with go version: %s\n", runtime.Version())
		fmt.Fprintf(flag.CommandLine.Output(), "URL: %s/\n\n", url)
		fmt.Fprintf(flag.CommandLine.Output(), "Flags:\n")
		flag.PrintDefaults()
		fmt.Fprintf(flag.CommandLine.Output(), "\n** Specify server secret with env variable CLIP_HTTPD_APIKEY ***\n")
	}
	host := flag.String("host", "0.0.0.0", "Host address to bind the server to")
	port := flag.Int("port", 8881, "Port for the server to listen on")
	versionFlag := flag.Bool("version", false, "Print version and exit")
	certFile := flag.String("cert-file", "", "Path to TLS certificate file (enables HTTPS)")
	keyFile := flag.String("key-file", "", "Path to TLS key file (enables HTTPS)")
	useSystray := flag.Bool("systray", false, "Enable System Tray GUI")
	copyCommand := flag.String("copy-command", "", "Custom command to copy data to clipboard")

	flag.Parse()

	if *versionFlag {
		fmt.Printf("%s %s %s\n", me, version, url)
		os.Exit(0)
	}
	apiKey := os.Getenv("CLIP_HTTPD_APIKEY")
	if apiKey == "" {
		_ = godotenv.Load()
		apiKey = os.Getenv("CLIP_HTTPD_APIKEY")
	}
	if apiKey == "" {
		log.Fatal("Error: API key not set. Set the CLIP_HTTPD_APIKEY environment variable or create a .env file.")
	}
	addr := fmt.Sprintf("%s:%d", *host, *port)
	http.HandleFunc("/", clipboardHandler(apiKey, *copyCommand))
	isTlsEnabled := *certFile != "" && *keyFile != ""

	// define server startup func
	startServer := func() {
		if isTlsEnabled {
			log.Printf("Starting %s %s HTTPS server on https://%s ... 🔐", me, version, addr)
			if err := http.ListenAndServeTLS(addr, *certFile, *keyFile, nil); err != nil {
				log.Fatalf("Could not start HTTPS server: %s\n", err)
			}
		} else {
			log.Printf("Starting %s %s HTTP server on http://%s ... 🛰️", me, version, addr)
			log.Println("WARNING: Server is running in insecure HTTP mode. Use -cert-file and -key-file for HTTPS.")
			if err := http.ListenAndServe(addr, nil); err != nil {
				log.Fatalf("Could not start HTTP server: %s\n", err)
			}
		}
	}

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
	if *useSystray {
		go startServer() // start the server in background
		log.Printf("Initialize systray ...")
		initSystray(sigChan, *port)
	} else {
		go func() {
			sig := <-sigChan
			log.Printf("Received signal: %v. Shutting down...", sig)
			os.Exit(0)
		}()		
		startServer()
	}

	// Log the copy method being used
	if *copyCommand != "" {
		log.Printf("Using custom copy command: '%s' (supports binary data)", *copyCommand)
	} else {
		log.Printf("Using default clipboard module (text only)")
	}



	if isTlsEnabled {
		log.Printf("Starting %s %s HTTPS server on https://%s ... 🔐", me, version, addr)
		if err := http.ListenAndServeTLS(addr, *certFile, *keyFile, nil); err != nil {
			log.Fatalf("Could not start HTTPS server: %s\n", err)
		}
	} else {
		log.Printf("Starting %s %s HTTP server on http://%s ... 🛰️", me, version, addr)
		log.Println("WARNING: Server is running in insecure HTTP mode. Use -cert-file and -key-file for HTTPS.")
		if err := http.ListenAndServe(addr, nil); err != nil {
			log.Fatalf("Could not start HTTP server: %s\n", err)
		}
	}
}
