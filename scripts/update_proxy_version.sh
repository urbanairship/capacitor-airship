#!/usr/bin/env bash
set -euxo pipefail

SCRIPT_DIRECTORY="$(cd "$(dirname "$0")" && pwd)"
ROOT_PATH="$SCRIPT_DIRECTORY/.."

PROXY_VERSION="$1"
if [ -z "$PROXY_VERSION" ]; then
    echo "No proxy version supplied"
    exit 1
fi

# Update UaCapacitorAirship.podspec
sed -i.bak -E "s/(s\.dependency *\"AirshipFrameworkProxy\", *\")([^\"]*)(\")/\1$PROXY_VERSION\3/" "$ROOT_PATH/UaCapacitorAirship.podspec"

# Update android/build.gradle
sed -i.bak -E "s/(def proxyVersion = ')([^']*)(')/\1$PROXY_VERSION\3/" "$ROOT_PATH/android/build.gradle"

# Update ios/Podfile
sed -i.bak -E "s/(pod 'AirshipFrameworkProxy', ')(.*?)(')/\1$PROXY_VERSION\3/" "$ROOT_PATH/ios/Podfile"

# Clean up backup files
find "$ROOT_PATH" -name "*.bak" -delete
