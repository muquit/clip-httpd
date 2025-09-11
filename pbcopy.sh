#!/bin/bash

########################################################################
# A remote clipboard copy client for clip-httpd
#
# This curl-based client securely sends text to a clip-httpd server,
# which copies the text to the system clipboard over HTTPS.
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
A remote clipboard copy client for clip-httpd.

This script reads from standard input and sends the data to a clip-httpd server.

Usage:
  pbcopy.sh [-h host] [-p port]

Options:
  -h    The hostname or IP address of the clip-httpd server (default: ${HOST})
  -p    The port number of the clip-httpd server (default: ${PORT})

Required Environment Variable:
  CLIP_HTTPD_APIKEY   The secret API key for authentication.

Example:
  export CLIP_HTTPD_APIKEY="your-secret-key"
  echo "Hello from remote" | pbcopy.sh
  cat file.txt | pbcopy.sh -h 192.168.1.100 -p 9000
  pbcopy.sh < file.txt
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
if [[ -z "${CLIPSINK_APIKEY}" ]]; then
  echo "Error: The CLIPSINK_APIKEY environment variable is not set." >&2
  echo "Please set it before running this script." >&2
  exit 1
fi

# --- Main Execution ---
# Construct the server URL from the host and port.
CLIPSINK_SERVER="https://${HOST}:${PORT}"

# Execute curl, reading from standard input (@-) and sending to the server.
curl --silent --show-error -k -H "X-Api-Key: ${CLIPSINK_APIKEY}" --data-binary @- "${CLIPSINK_SERVER}"
