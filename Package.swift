// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Allegory",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Allegory",
            targets: ["Allegory"]
        ),
        .library(
            name: "Identifiable",
            targets: ["Identifiable"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            from: "6.2.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Identifiable",
            dependencies: []
        ),
        .target(
            name: "Allegory",
            dependencies: [
                "Identifiable",
                "RxSwift"
            ]
        ),
        .testTarget(
            name: "AllegoryTests",
            dependencies: ["Allegory"]
        ),
    ]
)
