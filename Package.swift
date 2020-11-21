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
        .package(url: "https://github.com/vapor/vapor", from: "4.35.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf", .exact("4.0.0-tau.1")),
        .package(url: "https://github.com/vapor/leaf-kit", .exact("1.0.0-tau.1.1")),
    ],
    targets: [
        .target(name: "ViperKit", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Leaf", package: "leaf"),
            .product(name: "LeafKit", package: "leaf-kit"),
        ]),
        .testTarget(name: "ViperKitTests", dependencies: ["ViperKit"], resources: [.copy("Example/Templates")]),
    ]
)
