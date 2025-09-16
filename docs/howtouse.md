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

Look at the sample client @PBCOPY@ script. It uses @CURL@. 
I use `pbcopy` command on mac, hence I named it @PBCOPY@. 
