#!/bin/bash
set -e

ROOT_PATH=`dirname "${0}"`/..

PACKAGE_PATH="$ROOT_PATH/package.json"
ANDROID_VERISON_PATH="$ROOT_PATH/android/src/main/java/com/airship/capacitor/AirshipCapacitorVersion.kt"
IOS_VERISON_PATH="$ROOT_PATH/ios/Plugin/AirshipCapacitorVersion.swift"

packageVersion=$(node -p "require('$PACKAGE_PATH').version")
echo "package version: $packageVersion"


androidVersion=$(grep "var version" $ANDROID_VERISON_PATH | awk -F'"' '{print $2}')
echo "android: $androidVersion"

iosVersion=$(grep "static let version" $IOS_VERISON_PATH | awk -F'"' '{print $2}')
echo "ios: $iosVersion"

if [ "$packageVersion" = "$androidVersion" ] && [ "$packageVersion" = "$androidVersion" ] && [ "$packageVersion" = "$iosVersion" ]; then
    echo "All versions are equal :)"
else
    echo "Version mismatch!"
	exit 1
fi