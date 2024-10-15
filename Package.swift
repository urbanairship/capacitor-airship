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
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main"),
        .package(url: "https://github.com/urbanairship/airship-mobile-framework-proxy.git", from: "10.1.0")
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