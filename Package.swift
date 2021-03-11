// swift-tools-version:5.3
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
        .package(url: "https://github.com/vapor/vapor", from: "4.41.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/tau", from: "1.0.0"),
    ],
    targets: [
        .target(name: "ViperKit", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Tau", package: "tau"),
        ]),
        .testTarget(name: "ViperKitTests", dependencies: [
            .target(name: "ViperKit"),
        ], exclude: [
            "Example/Templates"
        ]),
    ]
)
