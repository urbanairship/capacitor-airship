// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UaCapacitorAirship",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "UaCapacitorAirship",
            targets: ["UaCapacitorAirship"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0"),
        .package(url: "https://github.com/urbanairship/airship-mobile-framework-proxy.git", revision: "593e96bb83ee9c0cd6b5897672eaa2c9fb861c69")
    ],
    targets: [
         .target(
            name: "UaCapacitorAirship",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "AirshipFrameworkProxy", package: "airship-mobile-framework-proxy")
            ],
            path: "ios/Plugin"
        )
    ]
)
