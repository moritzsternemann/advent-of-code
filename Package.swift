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
        .package(url: "https://github.com/apple/swift-collections.git", revision: "cc1c037a734c5f3b0ca7d47505389ccd31381052"),
        .package(url: "https://github.com/apple/swift-numerics.git", revision: "1883189574c7be40112a712d9b2d49ac5b3ac65f"),
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Numerics", package: "swift-numerics"),
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
