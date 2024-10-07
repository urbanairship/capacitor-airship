# Capacitor Plugin Changelog

## Version 2.3.0 - October 7, 2024

Minor release that updates to latest SDK versions and adds support for iOS Live Activities & Android Live Updates.

### Changes
- Updated Airship Android SDK to [18.3.2](https://github.com/urbanairship/android-library/releases/tag/18.3.2)
- Updated Airship iOS SDK to [18.10.0](https://github.com/urbanairship/ios-library/releases/tag/18.10.0)
- Added new APIs to manage [iOS Live Activities](https://docs.airship.com/platform/mobile/ios-live-activities/)
- Added new APIs to manage [Android Live Updates](https://docs.airship.com/platform/mobile/android-live-updates/)
- Added a new [Plugin Extenders](http://localhost:1313/platform/mobile/setup/sdk/capacitor/#extending-airship) to modify the native Airship SDK after takeOff


## Version 2.2.0 September 25, 2024
Minor release that updates the iOS SDK to 18.9.2 and adds the method `Airship.messageCenter.showMessageCenter(messageId?: string)` that can be used to show the OOTB Message Center UI even if auto launching Message Center is disabled. This new functionality is useful if the application needs to route the user in the app before processing the display event while still being able to use the OOTB UI.

### Changes
- Updated Airship iOS SDK to 18.9.2.
- Added new `showMessageCenter(messageId?: string)` to `MessageCenter`.

## Version 2.1.0 September 16, 2024
Minor release that adds `notificationPermissionStatus` to the `PushNotificationStatus` object and a way to specify the fallback when requesting permissions and the permission is already denied.

### Changes
- Updated Airship Android SDK to 18.3.0
- Updated Airship iOS SDK to 18.9.1
- Added `notificationPermissionStatus` to `PushNotificationStatus`
- Added options to `enableUserNotifications` to specify the `PromptPermissionFallback` when enabling user notifications

## Version 2.0.1 July 16, 2024
Patch release that fixes a critical issue with iOS that prevents the Airship library from automatically initializing. Apps using 2.0.0 should update.

### Changes
- Added missing files to the npm package for iOS

## Version 2.0.0 July 2, 2024
Major release to support Capacitor 6.

### Changes
- Updated Airship Android SDK to 18.1.1
- Updated Airship iOS SDK to 18.5.0
- Added iOS logPrivacyLevel that can be set in the environments when calling takeOff

## Version 1.2.4 June 21, 2024
Patch release to fix a regression on iOS with In-App Automations, Scenes, and Surveys ignoring screen, version, and custom event triggers. Apps using those triggers that are on 1.2.3 should update.

### Changes
- Updated iOS SDK to 18.4.1
- Fixed regression with triggers

## Version 1.2.3 June 20, 2024
Patch release that updates to latest iOS SDK.

### Changes
- Updated iOS SDK to 18.4.0

## Version 1.2.2 May 17, 2024
Patch release that updates to latest iOS SDK.

### Changes
- Updated iOS SDK to 18.2.2

## Version 1.2.1 May 13, 2024
Patch release that updates to latest Airship SDKs and fixes issues with methods that take an optional string parameter on Android.

### Changes
- Updated iOS SDK to 18.2.0
- Updated Android SDK to 17.8.1
- Fixed `Airship.messageCenter.display(null)` and `Airship.analytics.trackScreen(null)` on Android

## Version 1.2.0 May 2, 2024
Minor release that fixes push events on Android.

### Changes
- Fixed push events on Android.
- Added `isForeground` to push received events to indicate the application state when the push was received.
- Updated iOS SDK to 18.1.2

## Version 1.1.0 April 18, 2024
Minor release that updates the Airship SDKs.

### Changes
- Updated Airship iOS SDK to 18.1.0
- Updated Airship Android SDK to 17.8.0


## Version 1.0.0  March 22, 2024
Initial capacitor plugin release
