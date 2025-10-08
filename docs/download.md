## Installation
### 1. Download
* Download the appropriate archive for your platform from the @RELEASES@ page

### 2. Verify Checksum

```bash
# Download the checksums file
# Verify the archive
sha256sum -c cbcopy-vX.X.X-checksums.txt
```
Repeat the step for other archives

### 3. Extract
macOS/Linux:

```bash
tar -xzf cbcopy-vX.X.X-darwin-amd64.d.tar.gz
cd cbcopy-vX.X.X-darwin-amd64.d/
```

Repeat the step for other archives

Windows:

The tar command is available in Windows 10 (1803) and later, or you can 
use the GUI (right-click → Extract All). After extracting, copy/rename the 
binary somewhere in your PATH.

### 4. Install

```bash
# macOS/Linux
sudo cp cbcopy-vX.X.X-darwin-amd64 /usr/local/bin/cbcopy
sudo chmod +x /usr/local/bin/cbcopy
```

```bash
# Windows
copy cbcopy-vX.X.X-windows-amd64.exe C:\Windows\System32\cbcopy.exe
```

Use the same procedure for server and GUI version

* Please look at [How to use](#how-to-use) and [Examples](#examples) sections
for details.

### Building from source

Install @GO@ first

* Compile native binary
```bash
git clone @URL@
cd @ME@
go build -ldflags "-s -w" .
or
make build
./clip-httpd -version
```
Cross-compile for other platforms
* Install @GO_XBUILD_GO@
Then, type:

```bash
go-xbuild-go -config build-config.json
or 
make build_all
```
Look at `bin/` directory for archive with built binaries

Please look at @MAKEFILE@ for more info

