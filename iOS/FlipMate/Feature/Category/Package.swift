// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Category",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Category", targets: ["Category"]),
    ],
    
    dependencies: [
        .package(name: "Core", path: "../../Core"),
        .package(name: "DesignSystem", path: "../../DesignSystem"),
        .package(name: "Domain", path: "../../Domain"),
        .package(name: "Service", path: "../../Service")
    ],
    
    targets: [
        .target(name: "Category", dependencies: [
            .product(name: "Core", package: "Core"),
            .product(name: "DesignSystem", package: "DesignSystem"),
            .product(name: "Domain", package: "Domain"),
            .product(name: "CategoryService", package: "Service")
        ]),
        .testTarget(name: "CategoryTests", dependencies: ["Category"]),
    ]
)
