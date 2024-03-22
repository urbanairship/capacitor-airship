#!/bin/bash -ex
VERSION=$1

ROOT_PATH=`dirname "${0}"`/..
ANDROID_VERISON_PATH="$ROOT_PATH/android/src/main/java/com/airship/capacitor/AirshipCapacitorVersion.kt"
IOS_VERISON_PATH="$ROOT_PATH/ios/Plugin/AirshipCapacitorVersion.swift"


if [ -z "$1" ]
  then
    echo "No version number supplied"
    exit
fi


sed -i '' "s/var version = \"[-0-9.a-zA-Z]*\"/var version = \"$VERSION\"/" $ANDROID_VERISON_PATH
sed -i '' "s/static let version = \"[-0-9.a-zA-Z]*\"/static let version = \"$VERSION\"/" $IOS_VERISON_PATH
npm --prefix $ROOT_PATH version $VERSION --no-git-tag-version