#!/bin/bash

########################################################################
# A remote clipboard copy client for clip-httpd uses curl. It was
# originally written as a POC. Now a cross-platform native client
# written in go is available.
#
# This curl-based client securely sends text to a clip-httpd server,
# which copies the text to the system clipboard over HTTPS. Set
# server's API key by setting the env var CLIP_HTTPD_API_KEY
#
# Author: Developed with Google Gemini AI 2.5 Pro
# Date: Sep-10-2025 - first cut
# URL: https://github.com/muquit/clip-httpd
########################################################################

# --Change to your default--
HOST="192.168.1.72"
PORT="8881"

# --- Help and Usage Message ---
usage() {
  cat << EOF
A remote clipboard copy client for clip-httpd uses curl.

This script reads from standard input and sends the data to a clip-httpd 
server using curl. A native cros-platform stand alone client cbcopy is
also available.

Usage:
  cbcopy.sh [-h host] [-p port]

Options:
  -h    The hostname or IP address of the clip-httpd server (default: ${HOST})
  -p    The port number of the clip-httpd server (default: ${PORT})

Required Environment Variable:
  CLIP_HTTPD_API_KEY   The secret API key for authentication.

Example:
  export CLIP_HTTPD_API_KEY="your-secret-key"
  echo "Hello from remote" | cbcopy.sh
  cat file.txt | cbcopy.sh -h 192.168.1.100 -p 9000
  cbcopy.sh < file.txt
  # copy an image to clipboard
  cat file.png | base64 | cbcopy.sh
  To decode image from clipboard on mac using pbpaste
      pbpaste | base64 -d > file.png
EOF
  exit 0
}

# --- Parse Command-Line Flags ---
while getopts ":h:p:" opt; do
  case ${opt} in
    h)
      HOST="${OPTARG}"
      ;;
    p)
      PORT="${OPTARG}"
      ;;
    *)
      usage
      ;;
  esac
done

# --- Security Check ---
# Exit if the API key environment variable is not set.
if [[ -z "${CLIP_HTTPD_API_KEY}" ]]; then
  echo "Error: The CLIP_HTTPD_API_KEY environment variable is not set." >&2
  echo "Please set it before running this script." >&2
  exit 1
fi

# --- Main Execution ---
# Construct the server URL from the host and port.
CLIP_HTTPD_API_KEY_SERVER="https://${HOST}:${PORT}"

# Execute curl, reading from standard input (@-) and sending to the server.
curl --silent --show-error -k -H "X-Api-Key: ${CLIP_HTTPD_API_KEY}" --data-binary @- "${CLIP_HTTPD_API_KEY_SERVER}"
