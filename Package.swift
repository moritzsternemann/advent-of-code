// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "advent-of-code",
    targets: [
        .executableTarget(
            name: "day01",
            resources: [.copy("input.txt")]
        ),
    ]
)
