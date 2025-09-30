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

### Run copy client from your remote hosts

Use the cross-platfmr client @CBCOPY@ on remote systems to 
send text to @CLIPHTTPD@ server running on your desktop which
copies text to your system clipboard.
