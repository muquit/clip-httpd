## How to use

### Run the server on your desktop
* Generate self signed certificate first. 
* set the @API_KEY@ env variable, e.g.

```bash
export @API_KEY@='your_secret'
```

* On your desktop machine, start the server

```bash
clip-httpd -cert cert.pem -key key.pem
```

### Run copy client from your remote hosts

Use the cross-platfmr client @CBCOPY@ on remote systems to 
send text to @CLIPHTTPD@ server running on your desktop which
copies text to your system clipboard.
