# Capacitor Plugin Changelog

## Version 6.2.0 - July 23, 2026

Minor release that adds support for Embedded Content and updates the iOS SDK to 20.11.0 and the Android SDK to 20.10.0.

### Changes
- Added `Airship.inApp.addEmbeddedReadyListener` and `Airship.inApp.isEmbeddedReady` to track when embedded content is available for an embedded ID
- Added `Airship.inApp.createEmbeddedView` to display embedded Scene content inline by overlaying a native view on a placeholder element
- Added an optional `clipElement` to `createEmbeddedView` that clips the native view to a scroll container's bounds, so it scrolls under surrounding content (such as a header) instead of over it
- Updated iOS SDK to [20.11.0](https://github.com/urbanairship/ios-library/releases/tag/20.11.0)
- Updated Android SDK to [20.10.0](https://github.com/urbanairship/android-library/releases/tag/20.10.0)
- Fixed iOS Message Center inbox failing to load after upgrading across SDK versions that changed the Core Data model

## Version 6.1.0 - June 12, 2026

Minor release that updates the Android SDK to 20.7.4 and the iOS SDK to 20.7.2.

### Changes
- Updated Android SDK to [20.7.4](https://github.com/urbanairship/android-library/releases/tag/20.7.4)
- Updated iOS SDK to [20.7.2](https://github.com/urbanairship/ios-library/releases/tag/20.7.2)

## Version 6.0.0 - May 7, 2026

Major release that updates Capacitor to 8.0.

### Changes
- Updated Capacitor to 8.0
- Android `minSdkVersion` increased from 23 to 24
- Android Gradle wrapper updated to 8.14.3

## Version 5.5.1 - May 6, 2026

Patch release that fixes `Package.swift` not being included in the published npm package.

### Changes
- Fixed `Package.swift` missing from the published npm package

## Version 5.5.0 - May 1, 2026

Minor release that updates the Android SDK to 20.7.0 and the iOS SDK to 20.7.0.

### Changes
- Updated Android SDK to [20.7.0](https://github.com/urbanairship/android-library/releases/tag/20.7.0)
- Updated iOS SDK to [20.7.0](https://github.com/urbanairship/ios-library/releases/tag/20.7.0)

## Version 5.4.0 - April 1, 2026

Minor release that updates the Android SDK to 20.6.1 and the iOS SDK to 20.6.0

### Changes
- Updated Android SDK to [20.6.1](https://github.com/urbanairship/android-library/releases/tag/20.6.1)
- Updated iOS SDK to [20.6.0](https://github.com/urbanairship/ios-library/releases/tag/20.6.0)


## Version 5.3.0 - March 17, 2026

Minor release that updates the Android SDK to 20.5.0 and the iOS SDK to 20.5.0.

### Changes
- Updated Android SDK to [20.5.0](https://github.com/urbanairship/android-library/releases/tag/20.5.0)
- Updated iOS SDK to [20.5.0](https://github.com/urbanairship/ios-library/releases/tag/20.5.0)


## Version 5.2.0 - March 4, 2026

Minor release that updates the Android SDK to 20.4.0 and the iOS SDK to 20.4.0.

### Changes
- Updated Android SDK to [20.4.0](https://github.com/urbanairship/android-library/releases/tag/20.4.0)
- Updated iOS SDK to [20.4.0](https://github.com/urbanairship/ios-library/releases/tag/20.4.0)
- Fixed missing back button on iOS when displaying a message with Airship.messageCenter.showMessageView

## Version 5.1.0 - February 19, 2026

Minor release that fixes Airship failing to take off on iOS due to a plugin loader compatibility issue and updates the iOS SDK to 20.3.1 and the Android SDK to 20.2.2.

### Changes
- Updated iOS SDK to [20.3.1](https://github.com/urbanairship/ios-library/releases/tag/20.3.1)
- Updated Android SDK to [20.2.2](https://github.com/urbanairship/android-library/releases/tag/20.2.2)
- Fixed iOS plugin loader to use the updated `onLoad()` protocol method
- iOS minimum deployment target increased from 15.0 to 16.0
- Android compileSdkVersion updated to 36
- Android Kotlin version updated to 2.2.20
- Android Gradle Plugin updated to 8.13.0


## Version 5.0.0 - December 30, 2025

Major release that updates the Android SDK to 20.0.6 and the iOS SDK to 20.0.3

### Changes
- Updated Android SDK to [20.0.6](https://github.com/urbanairship/android-library/releases/tag/20.0.6)
- Updated iOS SDK to [20.0.3](https://github.com/urbanairship/ios-library/releases/tag/20.0.3)


## Version 4.6.1 - November 14, 2025

Patch release that fixes YouTube video playback in In-App Automation and Scenes. Applications that use YouTube videos in Scenes and non-html In-App Automations (IAA) must update to resolve playback errors.

### Changes
- Updated Android SDK to [19.13.6](https://github.com/urbanairship/android-library/releases/tag/19.13.6)
- Updated iOS SDK to [19.11.2](https://github.com/urbanairship/ios-library/releases/tag/19.11.2)


## Version 4.6.0 - August 27, 2025

Patch release that updates the Android SDK to 19.11.0 and the iOS SDK to 19.8.3

### Changes
- Updated Android SDK to [19.11.0](https://github.com/urbanairship/android-library/releases/tag/19.11.0)
- Updated iOS SDK to [19.8.3](https://github.com/urbanairship/ios-library/releases/tag/19.8.3)


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
