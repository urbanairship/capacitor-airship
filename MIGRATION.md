# Migration Guide

## 6.x to 7.0.0

Capacitor Airship plugin 7.0.0 drops CocoaPods support and updates the native Airship SDKs to version 21.x on iOS and Android.

### Package Changes
- **CocoaPods**: No longer supported. `UaCapacitorAirship.podspec` has been removed and the plugin is now distributed via Swift Package Manager only. If your app's iOS project still uses CocoaPods, migrate it to SPM before upgrading — see Capacitor's [Swift Package Manager guide](https://capacitorjs.com/docs/ios/spm). Apps already on SPM are unaffected. If you're not ready to migrate, stay on the 6.x line; it will keep receiving CocoaPods releases until [CocoaPods Trunk goes read-only](https://blog.cocoapods.org/CocoaPods-Specs-Repo/) in December 2026.
- **Capacitor**: 8.5+ is now required.
- **Native SDKs**: Updated to 21.x on iOS and Android.

#### iOS Requirements
- **Xcode**: 27+ is now required.

#### Android Requirements
- **minSdk**: 26+ is now required (up from 24).

### iOS Migration
Most applications will not be affected by these changes. They only apply to apps that have implemented native extensions or customizations to the Airship SDK (for example, via `AirshipPluginExtender`).

#### Embedded Content moved to `AirshipScenes`
`AirshipEmbeddedView` and related embedded-content types moved out of `AirshipCore` into a new `AirshipScenes` module. If your native extension code references these types directly, add `import AirshipScenes` alongside (or instead of) `import AirshipCore`.

#### Airship SDK 21
- [iOS Migration Guide](https://github.com/urbanairship/ios-library/blob/main/Documentation/Migration/migration-guide-20-21.md): Detailed guide for migrating native iOS code from Airship SDK 20.x to 21.0.

### Android Migration
Most applications will not be affected by these changes. They only apply to apps that have implemented native extensions or customizations to the Airship SDK (for example, via `AirshipPluginExtender`).

#### Airship SDK 21
- [Android Migration Guide](https://github.com/urbanairship/android-library/blob/main/documentation/migration/migration-guide-20-21.md): Detailed guide for migrating native Android code from Airship SDK 20.x to 21.0.
