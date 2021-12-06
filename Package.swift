// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "advent-of-code",
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.2"),
    ],
    targets: [
        .target(name: "Common"),
        .executableTarget(
            name: "day01",
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day02",
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day03",
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day04",
            dependencies: [.product(name: "Collections", package: "swift-collections")],
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day05",
            resources: [.copy("input.txt")]
        ),
    ]
)
