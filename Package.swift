// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "SPQRCode",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "SPQRCode", targets: ["SPQRCode"])
    ],
    dependencies: [
        .package(url: "https://github.com/ivanvorobei/NativeUIKit", .upToNextMajor(from: "1.4.6"))
    ],
    targets: [
        .target(
            name: "SPQRCode",
            dependencies: [
                .product(name: "NativeUIKit", package: "NativeUIKit"),
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .define("SPQRCODE_SPM")
            ]
        )
    ]
)
