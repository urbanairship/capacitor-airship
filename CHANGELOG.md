# Capacitor Plugin Changelog

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
