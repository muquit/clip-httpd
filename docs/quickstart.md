## Quick Start

Get up and running in just a few steps:

1. **Generate a self-signed certificate (once per desktop where clip-httpd
   will be running):**
```bash
   openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -nodes
```

*Note: If you have a real certificate (e.g., from Let's Encrypt or your organization), you can use that instead.*

2. **Start the server on your desktop:**

```bash
 export CLIP_HTTPD_API_KEY='your_secret_key'
./clip-httpd -cert cert.pem -key key.pem
```

3. **Send text from a remote machine:**
```bash
 export CLIP_HTTPD_API_KEY='your_secret_key'
echo "Hello from remote!" | cbcopy -h <your_desktop_ip> -p 8881
cbcopy -h <your_desktop_ip> -p 8881 < file.txt
```
4. **Desktop Integration**
```bash
./clip-httpd-systray -systray -cert cert.pem -key key.pem
```
I use the system tray mode so that I can see at a glance if it's running or not. 

Screenshot of a segment of my Mac's Top Bar:

@MAC_TOP_BAR@

Screenshot of a segment of Linux Top Bar:

@LINUX_TOP_BAR@

Windows systray works fine as wel, sorry I didn't get time to take a screenshot.

Please look @EXAMPLES@ section for various usecases
