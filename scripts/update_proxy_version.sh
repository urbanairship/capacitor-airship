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
sed -i '' "s/airshipProxyVersion = project\.hasProperty('airshipProxyVersion') ? rootProject\.ext\.airshipProxyVersion : '.*'/airshipProxyVersion = project.hasProperty('airshipProxyVersion') ? rootProject.ext.airshipProxyVersion : '$PROXY_VERSION'/" "$ROOT_PATH/android/build.gradle"

# Update ios/Podfile
sed -i '' "s/pod 'AirshipFrameworkProxy'.*$/pod 'AirshipFrameworkProxy', '$PROXY_VERSION'/" "$ROOT_PATH/ios/Podfile"

# Update Package.swift
sed -i '' "s/\.package(url: \"https:\/\/github\.com\/urbanairship\/airship-mobile-framework-proxy\.git\", from: \".*\")/.package(url: \"https:\/\/github.com\/urbanairship\/airship-mobile-framework-proxy.git\", from: \"$PROXY_VERSION\")/" "$ROOT_PATH/Package.swift"
