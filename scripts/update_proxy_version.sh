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
sed -i '' "s/s\.dependency.*AirshipFrameworkProxy.*$/s.dependency \"AirshipFrameworkProxy\", \"$PROXY_VERSION\"/" "$ROOT_PATH/UaCapacitorAirship.podspec"

# Update android/build.gradle
sed -i '' "s/def proxyVersion = '.*'/def proxyVersion = '$PROXY_VERSION'/" "$ROOT_PATH/android/build.gradle"

# Update ios/Podfile
sed -i '' "s/pod 'AirshipFrameworkProxy'.*$/pod 'AirshipFrameworkProxy', '$PROXY_VERSION'/" "$ROOT_PATH/ios/Podfile"
