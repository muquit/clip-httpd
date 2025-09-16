## Examples

Instead of fumbling with mouse selection, starting scp to transfer a file, 
scrolling to find text boundaries, or dealing with terminal text that spans 
multiple screens, you can instantly pipe any command output directly to 
your clipboard. This is especially valuable during meetings, demos, or 
incident response when every second counts.

Also, I find this techniques very useful when working with LLMs.

```bash
# Copy an API key from a json file 
cat ~/api.key | jq -r .api_key | pbcopy.sh
```

```bash
# Copy to the clipboard of your laptop/workstation connected to a remote 
# system over VPN.
# First create a reverse ssh proxy from your system to the remote system
ssh -R 881:localhost:8881 user@remote_host

# At your remote host, copy text to localhost at port 8881
echo 'hello over VPN' | pbcopy.sh -h 127.0.0.1 -p 8881
```

```bash
# Copy an image to clipboard
cat file.png | base64 | pbcopy.sh

# Save the image from clipboard. on Mac, use pbpaste.
pbpaste | base64 -d > file.png

# On Linux
xclip -selection clipboard -o | base64 -d > file.png

# On Windows
# may require git bash, wsl for base64
powershell "Get-Clipboard | base64 -d > file.png"

# Any binary data can be copied and pasted this way
```

```bash
# On remote server - send a specific function to clipboard
sed -n '45,67p' main.go | pbcopy.sh
```

```bash
# Or send an entire file
cat config.yaml | pbcopy.sh
```

etc.
