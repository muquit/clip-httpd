## History

My desktop is a Mac, but I use @ITERM2@, @MOSH@, @TMUX@ to connect to various 
remote machines and need to copy text from them, even from dumb terminals.
I had issues with clipboard functionality when mixing iTerm2, tmux, vim/nvim, etc.

It runs on my Mac and allows me to copy text or content of large text file 
to the Mac clipboard using 
@CURL@ over HTTPS from any remote environment. Especially for text files, it
is certainly much simpler than starting a scp session to copy a file. On macOS I 
just run `pbpaste > file.txt` to copy the content to a file.

It should work on Windows and
Linux as well, because it uses the go module @CLIPBOARD@ for copying text
to clipboard which supports Mac, Windows and Linux. I use @CURL@ as I have
@CURL@ available on the remote systems I use. It is possible to write a
portable client as well but I do not need it right now.

I'm sure there are similar tools with many features that exist, but my need
is simple. 
