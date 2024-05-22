// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    products: [ 
        .library(name: "Data", targets: ["Data"]),
    ],
    
    dependencies: [
        .package(path: "../Domain") 
    ],
    
    targets: [
        .target(name: "Data", dependencies: [ .product(name: "Domain", package: "Domain")]),
        .testTarget(name: "DataTests", dependencies: ["Data"]),
    ]
)
