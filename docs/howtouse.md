## How to use

### Run the server on your desktop
* Generate self signed certificate first. 
* set the @API_KEY@ env variable, e.g.

```bash
export @API_KEY@='your_secret'
```
The API key is simply a shared secret between the server and client. It
doesn't need to be a traditional long hex or base64 encoded token - just
use a strong, memorable passphrase.

* On your desktop machine, start the server

```bash
clip-httpd -cert cert.pem -key key.pem
```

If you will be using the GUI version to register with system tray run it with
`-systray`

### Run copy client on your remote hosts

Use the cross-platform client @CBCOPY@ on remote systems to 
send text to @CLIPHTTPD@ server running on your desktop which
copies text to your system clipboard. Look at @CBCOPY_SH@, which
uses @CURL@ to see how the client works.
