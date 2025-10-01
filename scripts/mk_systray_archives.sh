#!/bin/bash

########################################################################
# Script to create systray binary archives. Needed this because 
# systray module uses CGO and the binaries must be compiled in each
# platform.
#
# Creates archives for:
#   darwin-amd64,
#   darwin-arm64,
#   linux-amd64,
#   windows-amd64
# By Claude AI Sonnet 4
# Sep-25-2025 
########################################################################

#set -e

VERSION="v1.0.2"
BASE_NAME="clip-httpd-systray"
OUTPUT_DIR="./bin"
CHECKSUMS_FILE="${OUTPUT_DIR}/${BASE_NAME}-${VERSION}-checksums.txt"

# Platforms to build archives for
UNIX_PLATFORMS=("darwin-amd64" "darwin-arm64" "linux-amd64")
WINDOWS_PLATFORMS=("windows-amd64")

export PATH=/bin:/usr/bin:/usr/local/bin:$PATH

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Remove old checksums file if it exists
rm -f "${CHECKSUMS_FILE}"

echo "Creating systray archives..."

# Function to create Unix archives (tar.gz)
create_unix_archive() {
    local platform=$1
    local binary_name="${BASE_NAME}-${VERSION}-${platform}"
    local archive_name="${binary_name}.d.tar.gz"
    local temp_dir="${binary_name}.d"
    
    echo "Creating archive for ${platform}..."
    
    # Check if binary exists
    if [[ ! -f "${binary_name}" ]]; then
        echo "Error: Binary ${binary_name} not found in current directory"
        return 1
    fi
    
    # Create temporary directory structure
    mkdir -p "${temp_dir}"
    
    # Copy files to temp directory
    cp "${binary_name}" "${temp_dir}/"
    cp LICENSE "${temp_dir}/"
    cp README.md "${temp_dir}/"
    cp platforms.txt "${temp_dir}/"
    
    # Create archive
    tar -czf "${OUTPUT_DIR}/${archive_name}" "${temp_dir}"
    
    # Generate checksums
    (cd "${OUTPUT_DIR}" && sha256sum "${archive_name}" >> "$(basename "${CHECKSUMS_FILE}")")
    (cd "${OUTPUT_DIR}" && md5sum "${archive_name}" >> "$(basename "${CHECKSUMS_FILE}")")
    
    # Clean up temp directory
    rm -rf "${temp_dir}"
    
    echo "Created ${archive_name}"
}

# Function to create Windows archives (zip)
create_windows_archive() {
    local platform=$1
    local binary_name="${BASE_NAME}-${VERSION}-${platform}"
    local binary_with_exe="${binary_name}.exe"  # Add this
    local archive_name="${binary_name}.d.zip"
    local temp_dir="${binary_name}.d"
    
    echo "Creating archive for ${platform}..."
    
    # Check for both with and without .exe
    if [[ -f "${binary_with_exe}" ]]; then
        # Binary already has .exe extension
        local source_binary="${binary_with_exe}"
    elif [[ -f "${binary_name}" ]]; then
        # Binary doesn't have .exe extension
        local source_binary="${binary_name}"
    else
        echo "Warning: Binary ${binary_name} (or .exe) not found, skipping..."
        return 0
    fi
    
    # Create temporary directory structure
    mkdir -p "${temp_dir}"
    
    # Copy files to temp directory
    cp "${source_binary}" "${temp_dir}/${binary_name}.exe"
    cp LICENSE "${temp_dir}/"
    cp README.md "${temp_dir}/"
    cp platforms.txt "${temp_dir}/"
    
    # Create zip archive
    (cd "${temp_dir}" && zip -r "../${OUTPUT_DIR}/${archive_name}" .)
    
    # Generate checksums
    (cd "${OUTPUT_DIR}" && sha256sum "${archive_name}" >> "$(basename "${CHECKSUMS_FILE}")")
    (cd "${OUTPUT_DIR}" && md5sum "${archive_name}" >> "$(basename "${CHECKSUMS_FILE}")")
    
    # Clean up temp directory
    rm -rf "${temp_dir}"
    
    echo "Created ${archive_name}"
}

# Create Unix archives
for platform in "${UNIX_PLATFORMS[@]}"; do
    create_unix_archive "${platform}"
done

# Create Windows archives
for platform in "${WINDOWS_PLATFORMS[@]}"; do
    create_windows_archive "${platform}"
done

echo ""
echo "All archives created successfully in ${OUTPUT_DIR}/"
echo "Checksums written to ${CHECKSUMS_FILE}"
echo ""
echo "Created archives:"
ls -la "${OUTPUT_DIR}/${BASE_NAME}-${VERSION}"*.{tar.gz,zip} 2>/dev/null || true
