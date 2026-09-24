// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProcessRunning",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ProcessRunning",
            targets: ["ProcessRunning"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProcessRunning",
            dependencies: [
                .product(name: "Subprocess", package: "swift-subprocess")
            ],
            swiftSettings: [
                // Match Subprocess so `run` and `body` stay on the caller's actor.
                .enableUpcomingFeature("NonisolatedNonsendingByDefault")
            ]
        ),
        .testTarget(
            name: "ProcessRunningTests",
            dependencies: ["ProcessRunning"]
        ),
    ]
)
