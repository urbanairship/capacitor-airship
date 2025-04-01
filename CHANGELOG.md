# Capacitor Plugin Changelog

## Version 4.3.0 - April 1, 2025

Minor release that updates the Android SDK to 19.5.0 and the iOS SDK to 19.1.2

### Changes
- Updated Android SDK to [19.5.0](https://github.com/urbanairship/android-library/releases/tag/19.5.0)
- Updated iOS SDK to [19.1.2](https://github.com/urbanairship/ios-library/releases/tag/19.1.2)


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

## Version 3.1.0 - December 6, 2024
Minor release that updates the Android Airship SDK to 18.5.0 and iOS Airship SDK to 18.13.0

### Changes
- Updated Android SDK to [18.5.0](https://github.com/urbanairship/android-library/releases/tag/18.5.0).
- Updated iOS SDK to [18.13.0](https://github.com/urbanairship/ios-library/releases/tag/18.13.0).

## Version 3.0.1 - November 26, 2024
Patch release that updates the iOS Airship SDK to 18.12.2 and Android Airship SDK to 18.4.2

### Changes
- Updated Android SDK to [18.4.2](https://github.com/urbanairship/android-library/releases/tag/18.4.2).
- Updated iOS SDK to [18.12.2](https://github.com/urbanairship/ios-library/releases/tag/18.12.2).
- Updated Android plugin to use the project compileSdk, minSdkVersion, and targetSdkVersion. The plugin still requires compileSdk to be set to 35+.

## Version 3.0.0 - October 25, 2024
Major version that makes it easier to include Airship in a hybrid app. The only breaking change is when extending the AirshipPluginExtender protocol on java there is a new extendConfig(Contex, AirshipConfigOptions.Builder) method to implement. Most application will not be affected.

### Changes
- Added new methods to the plugin extender to make hybrid app integrations easier
- Updated Airship Android SDK to [18.3.3](https://github.com/urbanairship/android-library/releases/tag/18.3.3)
- Fixed tracking live activities started from a push notification

## Version 2.4.0 - October 15, 2024
Minor release that updates the native SDKs and fixes an issue with `Airship.messageCenter.getUnreadCount()`

### Changes
- Updated Airship iOS SDK to [18.11.1](https://github.com/urbanairship/ios-library/releases/tag/18.11.1)
- Fixed method binding for `Airship.messageCenter.getUnreadCount()`
- Fixed MessageCenterPredicate not being applied to the OOTB Message Center UI on iOS

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
