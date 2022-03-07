// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SPQRCode",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "SPQRCode",
            targets: ["SPQRCode"]
        )
    ],
    targets: [
        .target(
            name: "SPQRCode",
//            resources: [
//                .process("Resources/Assets.xcassets")
//            ],
            swiftSettings: [
                .define("SPQRCODE_SPM")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
