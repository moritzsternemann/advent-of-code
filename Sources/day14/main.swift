//
//  main.swift
//  day14
//
//  Created by Moritz Sternemann on 14.12.21.
//

import Algorithms
import Common

struct InsertionRule {
    var pair: String
    var insertions: [String]

    init?(_ string: String) {
        let parts = string
            .components(separatedBy: " -> ")
        guard parts[0].count == 2, parts[1].count == 1 else { return nil }
        pair = parts[0]
        insertions = ["\(pair[pair.startIndex])\(parts[1].first!)", "\(parts[1].first!)\(pair[pair.index(after: pair.startIndex)])"]
    }
}

struct Window {
    var pair: String
    var count: Int
}

var input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)

let template = input.removeFirst()
let insertionRules = input.compactMap(InsertionRule.init(_:))

func insertionStep(_ windows: [Window]) -> [Window] {
    let newWindows = windows
        .flatMap { window -> [Window] in
            guard let insertions = insertionRules.first(where: { $0.pair == window.pair })?.insertions else { fatalError() }
            return insertions.map { Window(pair: $0, count: window.count) }
        }

    return Set(newWindows.map(\.pair))
        .map { pair in
            Window(
                pair: pair,
                count: newWindows.filter { $0.pair == pair }.map(\.count).reduce(0, +)
            )
        }
}

func pairInsertion(iterations: Int) -> Int {
    let initialWindows = template.windows(ofCount: 2).map { Window(pair: String($0), count: 1) }
    let polymer = (0..<iterations)
        .reduce(initialWindows) { windows, _ in
            insertionStep(windows)
        }

    // count characters
    let polymerCharacterCounts: [Character: Int] = polymer
        .reduce(into: [template.first!: 1]) { counts, window in
            counts[window.pair.last!, default: 0] += window.count
        }
    
    let leastCommonCharacter = polymerCharacterCounts.min(by: { $0.value < $1.value })!.value
    let mostCommonCharacter = polymerCharacterCounts.max(by: { $0.value < $1.value })!.value

    return mostCommonCharacter - leastCommonCharacter
}

// MARK: - Part 1
let differencePart1 = pairInsertion(iterations: 10)
print("-- Part 1")
print("Least/most common character difference: \(differencePart1)")

// MARK: - Part 2
let differencePart2 = pairInsertion(iterations: 40)
print("-- Part 2")
print("Least/most common character difference: \(differencePart2)")
