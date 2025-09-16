## Introduction
@CLIPSINK@ is a simple, secure, cross-platform clipboard server.
I use it to paste `text` to my Laptop/workstation's clipboard from remote
systems securely without pain of fumbling with mouse or firing up scp and such 
to get a file.

It listens on a TCP port for incoming HTTPS requests containing text 
data and copies that text to the system clipboard. Client authentication 
is required using a secret API key for secure communication with the server.
This allows you to securely update the system clipboard of your desktop 
from any other machine on your network using a simple HTTP request.

I hope you find this project useful! Pull requests, suggestions, and 
feedback are always welcome.
