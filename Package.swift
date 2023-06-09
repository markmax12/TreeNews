// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TreeNews",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "treenews", targets: ["TreeNews"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "TreeNews",
            path: "Sources"),
    ]
)
