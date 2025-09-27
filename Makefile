#====================================================================
# Requires https://github.com/muquit/go-xbuild-go for cross compiling
# for other platforms.
# Mar-29-2025 muquit@muquit.com 
#====================================================================
README_ORIG=./docs/README.md
MAIN_MD=./docs/main.md
README=./README.md
BINARY=./clip-httpd
CLIENT_BINARY=./cbcopy
BINARY_SYSTRAY=./clip-httpd-systray
VERSION := $(shell cat VERSION)
LDFLAGS := -ldflags "-w -s -X 'github.com/muquit/clip-httpd/pkg/version.Version=$(VERSION)'"
BUILD_OPTIONS := -trimpath
MARKDOWC_TOC=markdown-toc-go
# requires markdown-toc-go v 1.0.3+
GLOSSARY_FILE=./docs/glossary.txt
USAGE_FILE=./docs/usage.md
CBCOPY_FILE=./docs/cbcopy.txt
SERVER=./cmd/server
CLIENT=./cmd/cli


all: build build_all doc

build: cli
	@echo "*** Compiling $(BINARY) $(VERSION) ...."
	@/bin/rm -f bin/*
	go build $(BUILD_OPTIONS) $(LDFLAGS) -o $(BINARY) $(SERVER)

server:
	CGO_ENABLED=0 go build $(BUILD_OPTIONS) $(LDFLAGS) -o $(BINARY) $(SERVER)

cli:
	CGO_ENABLED=0 go build $(BUILD_OPTIONS) $(LDFLAGS) -o cbcopy $(CLIENT)

cli-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(BUILD_OPTIONS) $(LDFLAGS) -o cbcopy-linux ./cmd/cli

native:
	@echo "*** Compiling $(BINARY) $(VERSION) with systray support ...."
	go build $(BUILD_OPTIONS) $(LDFLAGS) -tags systray -o $(BINARY_SYSTRAY) $(SERVER)

# native systray based server, uses CGO
# therefore has to be compiled in each system
server-darwin-arm64:
	go build $(BUILD_OPTIONS) $(LDFLAGS) -tags systray -o \
		clip-httpd-systray-$(VERSION)-darwin-arm64 $(SERVER)

server-darwin-amd64:
	go build $(BUILD_OPTIONS) $(LDFLAGS) -tags systray -o \
		clip-httpd-systray-$(VERSION)-darwin-amd64 $(SERVER)

server-linux-amd64:
	go build $(BUILD_OPTIONS) $(LDFLAGS) -tags systray -o \
		clip-httpd-systray-$(VERSION)-linux-amd64 $(SERVER)

server-windows-amd64:
	go build $(BUILD_OPTIONS) $(LDFLAGS) -tags systray -o \
		clip-httpd-systray-$(VERSION)-windows-amd64 $(SERVER)

show_commit_info:
	go version -m $(BINARY)
	go version -m $(CLIENT_BINARY)

# cross compile for various platforms
# requires go-xbuild-go from 
# https://github.com/muquit/go-xbuild-go
build_all:
	@echo "*** Cross Compiling $(BINARY) $(VERSION) ...."
	@/bin/rm -rf ./bin
	go-xbuild-go -build-args '$(BUILD_OPTIONS)' -additional-files cbcopy.sh

build_native:


release:
	go-xbuild-go -release

doc: gen_usage
	echo "*** Generating README.md with TOC ..."
	touch $(README)
	chmod 600 $(README)
	$(MARKDOWC_TOC) -i $(MAIN_MD) -o $(README) --glossary ${GLOSSARY_FILE} -f
	chmod 444 $(README)

gen_usage: build
	@echo '## Usage' > $(USAGE_FILE)
	@echo '```' >> $(USAGE_FILE)
	@${BINARY} -h 2>> $(USAGE_FILE)
	@echo '```' >> $(USAGE_FILE)
	@echo '```bash' > $(CBCOPY_FILE)
	@./cbcopy.sh -h >> $(CBCOPY_FILE)
	@echo '```' >> $(CBCOPY_FILE)

clean:
	/bin/rm -f $(BINARY)
	/bin/rm -rf ./bin
