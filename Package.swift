// swift-tools-version: 6.0
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
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0"),
        .package(url: "https://github.com/urbanairship/airship-mobile-framework-proxy.git", from: "15.0.2")
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