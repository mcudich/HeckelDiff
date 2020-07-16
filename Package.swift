// swift-tools-version:5.2
//

import PackageDescription

let package = Package(
    name: "HeckelDiff",
    products: [
        .library(name: "HeckelDiff", targets: ["HeckelDiff"])
    ],
    targets: [
        .target(name: "HeckelDiff", path: "Source")
    ],
    swiftLanguageVersions: [.v5, .v4_2]
)
