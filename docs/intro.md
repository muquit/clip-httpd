## Introduction
@CLIPSINK@ is a simple, secure, cross-platform clipboard server written in 
@GO@. It listens on a TCP port for incoming HTTPS requests containing text 
data and copies that text to the system clipboard. Client authentication 
is required using a secret API key for secure communication with the server.
This allows you to securely update the system clipboard of your desktop 
from any other machine on your network using a simple HTTP request.

I hope you find this project useful! Pull requests, suggestions, and 
feedback are always welcome.
