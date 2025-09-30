## Usage
```
clip-httpd v1.0.2 - A simple, secure, cross-platform clipboard server.
URL: https://github.com/muquit/clip-httpd/

Flags:
  -cert-file string
    	Path to TLS certificate file (enables HTTPS)
  -copy-command string
    	Custom command to copy data to clipboard
  -host string
    	Host address to bind the server to (default "0.0.0.0")
  -key-file string
    	Path to TLS key file (enables HTTPS)
  -port int
    	Port for the server to listen on (default 8881)
  -systray
    	Enable System Tray GUI
  -version
    	Print version and exit

** Specify server secret with env variable CLIP_HTTPD_API_KEY **
Set the same API key for cbcopy client on each remote host
Examples:
  # On Bash (Linux/macOS)
  export CLIP_HTTPD_API_KEY="your-secret-key"

  # On Windows Command Prompt
  set CLIP_HTTPD_API_KEY=your-secret-key

  # On PowerShell
  $env:CLIP_HTTPD_API_KEY = "your-secret-key"
  ```
