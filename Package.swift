// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftXLS",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftXLS",
            targets: ["SwiftXLS"]),
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftXLS",
            dependencies: ["Clibxls"]),
        .systemLibrary(
            name: "Clibxls",
            pkgConfig: "libxls",
            providers: [
                .brew(["libxls"]),
                .apt(["libxls-dev"])
            ]
        ),
        .testTarget(
            name: "SwiftXLSTests",
            dependencies: ["SwiftXLS"]
        ),
    ]
)
