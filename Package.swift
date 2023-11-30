// swift-tools-version: 5.9
import Foundation
import PackageDescription

let inputFiles: [Resource] = (1...25)
    .map { day in
        let name = "Day\(day.formatted(.number.precision(.integerLength(2))))"
        return "\(name)/\(name).txt"
    }
    .map { .process($0) }

let package = Package(
    name: "advent-of-code-2023",
    platforms: [.iOS(.v16), .macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.5"),
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources",
            resources: inputFiles
        ),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: [
                .target(name: "AdventOfCode"),
            ],
            path: "Tests",
            resources: inputFiles
        )
    ]
)
