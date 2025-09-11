#====================================================================
# Requires https://github.com/muquit/go-xbuild-go for cross compiling
# for other platforms.
# Mar-29-2025 muquit@muquit.com 
#====================================================================
README_ORIG=./docs/README.md
MAIN_MD=./docs/main.md
README=./README.md
BINARY=./clip-httpd
VERSION := $(shell cat VERSION)
BUILD_OPTIONS = -ldflags "-s -w"
MARKDOWC_TOC=markdown-toc-go
# requires markdown-toc-go v 1.0.3+
GLOSSARY_FILE=./docs/glossary.txt
USAGE_FILE=./docs/usage.md


all: build build_all doc

build:
	@echo "*** Compiling $(BINARY) $(VERSION) ...."
	@/bin/rm -f bin/*
	go build $(BUILD_OPTIONS) -o $(BINARY)

# cross compile for various platforms
# requires go-xbuild-go from 
# https://github.com/muquit/go-xbuild-go
build_all:
	@echo "*** Cross Compiling $(BINARY) $(VERSION) ...."
	@/bin/rm -rf ./bin
	go-xbuild-go

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

clean:
	/bin/rm -f $(BINARY)
	/bin/rm -rf ./bin
