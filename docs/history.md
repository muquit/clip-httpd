## History

My desktop is a Mac, but I use @ITERM2@, @MOSH@, @TMUX@ to connect to various 
remote machines and need to copy text from them, even from dumb terminals.

I had issues with clipboard functionality when mixing iTerm2, tmux, vim/nvim,
OSC52, etc. clip-httpd works flawlessly for me.

The server runs on my Mac and allows me to copy text or content of large text file 
to the Mac clipboard.  Especially for text files, it
is certainly much simpler than starting a scp session to copy a file. On
MacOS, to copy content from clipboard to a file, I just run 
```bash
pbpaste > file.txt
```

It  works on Windows and Linux as well, because it uses the go module @CLIPBOARD@ for copying text
to clipboard which supports Mac, Windows and Linux. However, custom clipboard
copy command can be specified with `-copy-command` flag.

I'm sure there are similar tools with many features that exist, but my need
is simple and it is serving me well.

Hope you would find it usefull as well.
