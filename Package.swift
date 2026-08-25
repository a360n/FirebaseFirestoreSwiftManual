// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FirebaseFirestoreSwiftManual",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "FirebaseFirestoreSwiftManual",
            targets: ["FirebaseFirestoreSwiftManual"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.0.0")
        )
    ],
    targets: [
        .target(
            name: "FirebaseFirestoreSwiftManual",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ],
            path: "Sources/FirebaseFirestoreSwiftManual"
        )
    ]
)
