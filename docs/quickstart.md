## Quick Start

Get up and running in just a few steps:

1. **Generate a self-signed certificate (once per desktop where clip-httpd
   will be running):**
```bash
   openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -nodes
```

2. **Start the server on your desktop:**

```bash
 export CLIP_HTTPD_APIKEY='your_secret_key'
./clip-httpd -cert cert.pem -key key.pem
```

3. **Send text from a remote machine:**
```bash
 export CLIP_HTTPD_APIKEY='your_secret_key'
echo "Hello from remote!" | ./pbcopy.sh -h <your_desktop_ip> -p 8881
./pbcopy.sh -h <your_desktop_ip> -p 8881 < file.txt
```
4. ** Desktop Integration **
```bash
./clip-httpd-systray -systray -cert cert.pem -key key.pem
```

Please look @EXAMPLES@ section for varous usecases
