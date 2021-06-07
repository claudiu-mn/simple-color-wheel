// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleColorWheel",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SimpleColorWheel",
            targets: ["SimpleColorWheel"]),
    ],
    targets: [
        .target(
            name: "SimpleColorWheel",
            dependencies: []),
        .testTarget(
            name: "SimpleColorWheelTests",
            dependencies: ["SimpleColorWheel"]),
    ]
)
