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

### Copy client to your remote hosts

Look at the sample client @PBCOPY@ script. It uses @CURL@. 
I use `pbcopy` command on mac, hense I named it @PBCOPY@. 
```bash
pbcopy.sh -h
A remote pbcopy client for clip-httpd.

This script reads from standard input and sends the data to a clip-httpd server.

Usage:
  pbcopy [-h host] [-p port]

Options:
  -h    The hostname or IP address of the clip-httpd server (default: 192.168.1.72)
  -p    The port number of the clip-httpd server (default: 8881)

Required Environment Variable:
  CLIP_HTTPD_APIKEY   The secret API key for authentication.

Example:
  export CLIP_HTTPD_APIKEY="your-secret-key"
  echo "Hello from remote" | pbcopy.sh
  cat file.txt | pbcopy.sh -h 192.168.1.100 -p 9000
  pbcopy.sh < file.txt
```
