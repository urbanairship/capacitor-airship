# Capacitor Plugin Changelog

## Version 4.5.1 - August 20, 2025

Patch release that updates the Android SDK to 19.10.2 and the iOS SDK to 19.8.2

### Changes
- Updated Android SDK to [19.10.2](https://github.com/urbanairship/android-library/releases/tag/19.10.2)
- Updated iOS SDK to [19.8.2](https://github.com/urbanairship/ios-library/releases/tag/19.8.2)


## Version 4.5.0 - July 31, 2025

Minor release that updates the Android SDK to 19.10.0 and the iOS SDK to 19.7.0

### Changes
- Updated Android SDK to [19.10.0](https://github.com/urbanairship/android-library/releases/tag/19.10.0)
- Updated iOS SDK to [19.7.0](https://github.com/urbanairship/ios-library/releases/tag/19.7.0)


[All Releases](https://github.com/urbanairship/capacitor-airship/releases)

## Version 4.4.0 - June 26, 2025
Minor release that adds support for Android log privacy level configuration and updates the Android SDK to 19.9.1 and the iOS SDK to 19.6.1.

### Changes
- Updated Android SDK to [19.9.1](https://github.com/urbanairship/android-library/releases/tag/19.9.1)
- Updated iOS SDK to [19.6.1](https://github.com/urbanairship/ios-library/releases/tag/19.6.1)
- Added Android `logPrivacyLevel` configuration support

## Version 4.3.1 - May 9, 2025
Patch release that updates iOS SDK to 19.3.2

### Changes
- Updated iOS SDK to [19.3.2](https://github.com/urbanairship/ios-library/releases/tag/19.3.2)

## Version 4.3.0 - May 2, 2025
Minor release that updates the Android SDK to 19.6.2 and the iOS SDK to 19.3.1.

### Changes
- Updated Android SDK to [19.6.2](https://github.com/urbanairship/android-library/releases/tag/19.6.2)
- Updated iOS SDK to [19.3.1](https://github.com/urbanairship/ios-library/releases/tag/19.3.1)
- Added support for JSON attributes
- Added new method `Airship.channel.waitForChannelId()` that waits for the channel ID to be created

## Version 4.2.0 - March 27, 2025

Minor release that updates the Android SDK to 19.4.0 and the iOS SDK to 19.1.1

### Changes
- Updated Android SDK to [19.4.0](https://github.com/urbanairship/android-library/releases/tag/19.4.0)
- Updated iOS SDK to [19.1.1](https://github.com/urbanairship/ios-library/releases/tag/19.1.1)


## Version 4.1.0 - March 12, 2025
Major release that updates to the latest Airship SDKs and exposes the analytics session ID.

### Changes
- Updated Android SDK to [19.3.0](https://github.com/urbanairship/android-library/releases/tag/19.3.0).
- Updated iOS SDK to [19.1.0](https://github.com/urbanairship/ios-library/releases/tag/19.1.0).
- Added `Airship.analytics.getSessionId()` method.


## Version 4.0.1 - February 11, 2025
Patch release to fix the `MessageCenterUpdatedEvent` property `messageUnreadCount` on iOS.

### Changes
- Fixed MessageCenterUpdatedEvent.messageUnreadCount on iOS.

## Version 4.0.0 - February 11, 2025
Major release that updates the Android Airship SDK to 19.1.0 and iOS Airship SDK to 19.0.3

### Changes
- Updated Android SDK to [19.1.0](https://github.com/urbanairship/android-library/releases/tag/19.1.0).
- Updated iOS SDK to [19.0.3](https://github.com/urbanairship/ios-library/releases/tag/19.0.3).
- Updated Capacitor to 7.0.0
- Fixed SPM integration
- iOS requires Xcode 16.2 and iOS 15+
- Android requires compileSdkVersion 35+ and minSdkVersion 23+
