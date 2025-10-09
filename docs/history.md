## History

My desktop is a Mac, but I use @ITERM2@, @MOSH@, and @TMUX@ to connect to
various remote machines and frequently need to copy text from them, even
from dumb terminals. I encountered issues with clipboard functionality
when mixing iTerm2, tmux, vim/nvim, and OSC52, but clip-httpd works
flawlessly for me.

The server runs on my Mac and allows me to copy text or the contents of
large text files directly to the Mac clipboard. For text files especially,
this is much simpler than starting an scp session to copy a file. On macOS
, copying content from the clipboard to a file is as simple as running:

```bash
pbpaste > file.txt
```
The server is cross-platform and runs on any system @GO@ can compile to. It 
uses the @GO@ module @CLIPBOARD@ for copying text to the clipboard, which 
supports Mac, Windows, and Linux. However, a custom clipboard copy command 
can be specified with the `-copy-command` flag.
