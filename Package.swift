// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "UaCapacitorAirship",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "UaCapacitorAirship",
            targets: ["UaCapacitorAirship"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/urbanairship/airship-mobile-framework-proxy.git", from: "16.0.1"),
        .package(url: "https://github.com/urbanairship/ios-library.git", from: "21.0.2")
    ],
    targets: [
         .target(
            name: "UaCapacitorAirship",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "AirshipFrameworkProxy", package: "airship-mobile-framework-proxy"),
                .product(name: "AirshipCore", package: "ios-library"),
                .product(name: "AirshipAutomation", package: "ios-library"),
                .product(name: "AirshipMessageCenter", package: "ios-library"),
                .product(name: "AirshipPreferenceCenter", package: "ios-library"),
                .product(name: "AirshipFeatureFlags", package: "ios-library"),
                .product(name: "AirshipScenes", package: "ios-library")
            ],
            path: "ios/Plugin"
        )
    ]
)