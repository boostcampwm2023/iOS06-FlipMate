// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Service",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "CategoryService", targets: ["CategoryService"]),
    ],
    
    dependencies: [
        .package(name: "Domain", path: "../Domain")
    ],
    
    targets: [
        .target(name: "CategoryService", dependencies: [
            .product(name: "Domain", package: "Domain")
        ]),
        .testTarget(name: "ServiceTests", dependencies: [
            "CategoryService"
        ]),
    ]
)
