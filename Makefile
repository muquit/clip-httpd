#====================================================================
# Requires https://github.com/muquit/go-xbuild-go for cross compiling
# for other platforms.
# Mar-29-2025 muquit@muquit.com 
#====================================================================
README_ORIG=./docs/README.md
MAIN_MD=./docs/main.md
README=./README.md
BINARY=./clip-httpd
BINARY_SYSTRAY=./clip-httpd-systray
VERSION := $(shell cat VERSION)
LDFLAGS := -ldflags "-w -s -X 'github.com/muquit/clip-httpd/pkg/version.Version=$(VERSION)'"
BUILD_OPTIONS := -trimpath
MARKDOWC_TOC=markdown-toc-go
# requires markdown-toc-go v 1.0.3+
GLOSSARY_FILE=./docs/glossary.txt
USAGE_FILE=./docs/usage.md
PBCOPY_FILE=./docs/pbcopy.txt


all: build build_all doc

build:
	@echo "*** Compiling $(BINARY) $(VERSION) ...."
	@/bin/rm -f bin/*
	go build $(BUILD_OPTIONS) $(LDFLAGS) -o $(BINARY)

cli:
	go build $(BUILD_OPTIONS) $(LDFLAGS) -o cbcopy ./cmd/cli

cli-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(BUILD_OPTIONS) $(LDFLAGS) -o cbcopy-linux ./cmd/cli

native:
	@echo "*** Compiling $(BINARY) $(VERSION) with systray support ...."
	go build $(BUILD_OPTIONS) $(LDFLAGS) -tags systray -o $(BINARY_SYSTRAY)

# cross compile for various platforms
# requires go-xbuild-go from 
# https://github.com/muquit/go-xbuild-go
build_all:
	@echo "*** Cross Compiling $(BINARY) $(VERSION) ...."
	@/bin/rm -rf ./bin
	go-xbuild-go -build-args '$(BUILD_OPTIONS)' -additional-files pbcopy.sh

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
	@echo '```bash' > $(PBCOPY_FILE)
	@./pbcopy.sh -h >> $(PBCOPY_FILE)
	@echo '```' >> $(PBCOPY_FILE)

clean:
	/bin/rm -f $(BINARY)
	/bin/rm -rf ./bin
