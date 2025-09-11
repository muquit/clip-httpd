## Installation
### Download
Download pre-compiled binaries from @RELEASES@ page

Please look at [How to use](#how-to-use)

### Building from source

Install @GO@ first

* Compile native binary
```bash
git clone @URL@
cd @ME@
go build .
./clip-httpd -version
```
Cross-compile for other platforms
* Install @GO_XBUILD_GO@
Then, type:

```bash
go-xbuild-go
```
Look at `bin/` directory

Please look at @MAKEFILE@ for more info

