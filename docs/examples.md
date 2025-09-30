## Examples

Instead of fumbling with mouse selection, starting scp to transfer a file, 
scrolling to find text boundaries, or dealing with terminal text that spans 
multiple screens, you can instantly pipe any command output directly to 
your clipboard. This is especially valuable during meetings, demos, or 
incident response when every second counts.

Also, I find this techniques very useful when working with LLMs.

```bash
# Copy an API key from a json file 
cat ~/api.key | jq -r .api_key | cbcopy
```

```bash
# Copy to the clipboard of your laptop/workstation connected to a remote 
# system over VPN.
# First create a reverse ssh tuneel from your system to the remote system.
# Check your company policy if you are connecting to a host at corporate
# network.
ssh -R 881:localhost:8881 user@remote_host

# At your remote host, copy text to localhost at port 8881
echo 'hello over VPN' | cbcopy -h 127.0.0.1 -p 8881
```

```bash
# Copy an image to clipboard
cat file.png | base64 | cbcopy

# Save the image from clipboard. on Mac, use pbpaste.
pbpaste | base64 -d > file.png

# On Linux (X11 with xclip)
xclip -selection clipboard -o | base64 -d > file.png

# On Linux (X11 with xsel)
xsel --clipboard --output | base64 -d > file.png

# On Linux (Wayland)
wl-paste | base64 -d > file.png

# On Windows - encode image to base64 and copy (requires Git Bash or WSL)
# @GIT_BASH_URL@
cat file.png | base64 | cbcopy.exe

# On Windows - save image from clipboard (requires Git Bash or WSL for base64)
# @GIT_BASH_URL@
powershell -command "Get-Clipboard" | base64 -d > file.png
# View the decoded image
start file.png

# On Windows - alternative using built-in certutil
certutil -encode file.png temp.b64 && type temp.b64 | cbcopy.exe && del temp.b64
powershell -command "Get-Clipboard" > temp.b64 && certutil -decode temp.b64 file.png && del temp.b64
# View the decoded image
start file.png


# Any binary data can be copied and pasted this way
```

```bash
# On remote server - send a specific function to clipboard
sed -n '45,67p' main.go | cbcopy
```

```bash
# Or send an entire file
cat config.yaml | cbcopy
```

```bash
# Windows CMD examples
# Copy output of a command
ipconfig | cbcopy.exe

# Copy contents of a file
type config.json | cbcopy.exe

# Copy current directory path
cd | cbcopy.exe

# Extract and copy a value from JSON (requires jq - install from jqlang.org/download/)
type api.key | jq.exe -r .api_key | cbcopy.exe
```

```powershell
# Windows PowerShell examples
# Copy command output
Get-Process | ConvertTo-Json | cbcopy.exe

# Copy file contents
Get-Content config.yaml | cbcopy.exe

# Copy directory listing
Get-ChildItem | Out-String | cbcopy.exe
```

etc.
