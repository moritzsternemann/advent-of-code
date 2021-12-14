// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "advent-of-code",
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.2"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Common"),
        .executableTarget(
            name: "day01",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day02",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day03",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day04",
            dependencies: [
                .target(name: "Common"),
                .product(name: "Collections", package: "swift-collections")
            ],
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day05",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input.txt")]
        ),
        .executableTarget(
            name: "day06",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day07",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day08",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day09",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day10",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day11",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day12",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day13",
            dependencies: [.target(name: "Common")],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
        .executableTarget(
            name: "day14",
            dependencies: [
                .target(name: "Common"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            resources: [.copy("input_sample.txt"), .copy("input.txt")]
        ),
    ]
)
