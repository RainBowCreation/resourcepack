#!/bin/bash

# Define the repository and API URL
REPO="RainBowCreation/resourcepack"
API_URL="https://api.github.com/repos/$REPO/releases/latest"
validator_directory="validator"

# Get the latest release data
latest_release=$(curl -s "$API_URL")

# Extract the tag name and download URLs of assets
tag_name=$(echo "$latest_release" | grep -oP '"tag_name": "\K(.*?)(?=")')
assets_urls=$(echo "$latest_release" | grep -oP '"browser_download_url": "\K(.*?)(?=")')

# Create a directory for the release
mkdir -p "$validator_directory"
cd "$validator_directory" || exit

# Download each asset
echo "Downloading assets for release: $tag_name"
for url in $assets_urls; do
    echo "Downloading $url..."
    curl -L -O "$url"
done

echo "Download completed!"