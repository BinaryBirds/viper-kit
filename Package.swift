// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "viper-kit",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "ViperKit", targets: ["ViperKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.5.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0-rc"),
    ],
    targets: [
        .target(name: "ViperKit", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Leaf", package: "leaf"),
        ]),
        .testTarget(name: "ViperKitTests", dependencies: ["ViperKit"]),
    ]
)
