//
//  main.swift
//  day07
//
//  Created by Moritz Sternemann on 07.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .split(separator: ",")
    .compactMap { Int($0) }
    .sorted()

typealias CostFunction = (_ start: Int, _ end: Int) -> Int

func calculateMinimumCostToAlign(crabs: [Int], withCostFunction calculateCost: CostFunction) -> Int {
    let cost = (crabs.first!...crabs.last!)
        .map { target in
            crabs
                .map { calculateCost($0, target) }
                .reduce(0, +)
        }

    guard let minCost = cost.min() else { fatalError("No minimum cost") }
    return minCost
}

// MARK: - Part 1

let part1HorizontalPosition = calculateMinimumCostToAlign(crabs: input) {
    abs($1 - $0) // distance between crab position and target position
}
print("-- Part 1")
print("Horizontal position: \(part1HorizontalPosition)")

// MARK: - Part 2

let part2HorizontalPosition = calculateMinimumCostToAlign(crabs: input) { start, end in
    let distance = abs(end - start) // distance between crab position and target position
    return distance * (distance + 1) / 2 // sum of 1+2+3+... = n * (n + 1) / 2
}
print("-- Part 2")
print("Horizontal position: \(part2HorizontalPosition)")
