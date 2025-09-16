## How it works

The @CLIPSINK@ works on a simple and secure **client-server model**.
The @CLIPSINK@ binary is the server that runs on the machine whose 
clipboard you want to control, like your desktop. The client @PBCOPY@ is a small 
script runs on a remote machine that sends text to the server.

@FLOW@

-----

### Server (Text Receiver)

The @CLIPSINK@ server is a specialized web server that performs a few key tasks:

1.  **Listens for Connections:** It starts up and listens on a specific 
network port (e.g., `8881`) for incoming connections.

2.  **Secures the Connection:** When a client connects, the server uses 
the provided certificate files (`cert.pem`, `key.pem`) to establish a 
secure **HTTPS** tunnel. This encrypts all data sent between the client and server.

3.  **Authenticates the Client:** It inspects the incoming request for an `X-Api-Key` header.
It compares the key in the header to its own secret key. If they don't match, the connection is rejected.

4.  **Receives the Text:** If authentication is successful, the server reads the raw text data from the body of the `POST` request.

5.  **Updates the Clipboard:** This is the final and most important step. The server uses a native @GO@ library 
called @CLIPBOARD@ to interact directly with the operating system's 
clipboard API with installed clipboard copy tools. But you can also use the flag
`-copy-commad` to supply a custom copy command.

-----

### Client (Text Sender)

The supplied @PBCOPY@ Bash script can be used at your remote machine as a client which uses @CURL@. Its job is to prepare and send the data.

1.  **Reads the Text:** It takes any text that is piped (`|`) or redirected (`<`) to it from its standard input.

2.  **Packages the Request:** It uses the @CURL@ command to wrap this text into an HTTPS `POST` request.

3.  **Adds the Secret Key:** It adds your secret key to the `X-Api-Key` header to authenticate itself.

4.  **Sends the Data:** It sends the complete, encrypted request over the network to the server's IP address and port.

-----

