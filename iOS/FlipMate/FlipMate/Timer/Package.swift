// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Timer",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Timer",
            targets: ["Timer"]),
    ],
    dependencies: [
        .package(path: "../../Core"),
        .package(path: "../../Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Timer",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain")
            ]),
        .testTarget(
            name: "TimerTests",
            dependencies: ["Timer"]),
    ]
)
