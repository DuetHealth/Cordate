// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Cordate",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "Cordate",
            targets: ["Cordate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("5.1.3"))
    ],
    targets: [
        .target(
            name: "Cordate",
            dependencies: ["RxSwift", "RxCocoa"],
            path: "Cordate/Sources")
    ]
)
