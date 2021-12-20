//
//  main.swift
//  day20
//
//  Created by Moritz Sternemann on 20.12.21.
//

import Common

struct Point: Hashable {
    var x: Int
    var y: Int

    func spread() -> [Point] {
        let rowRange = (y - 1)...(y + 1)
        let columnRange = (x - 1)...(x + 1)
        return rowRange
            .flatMap { row in
                columnRange
                    .compactMap { column in
                        Point(x: column, y: row)
                    }
            }
    }
}

func enhance(grid: [Point: Bool], outsideValue: Bool) -> [Point: Bool] {
    let minX = grid.keys.map(\.x).min()!
    let maxX = grid.keys.map(\.x).max()!
    let rangeX = (minX - 1)...(maxX + 1)

    let minY = grid.keys.map(\.y).min()!
    let maxY = grid.keys.map(\.y).max()!
    let rangeY = (minY - 1)...(maxY + 1)

    var result: [Point: Bool] = [:]

    for row in rangeY {
        for column in rangeX {
            let current = Point(x: column, y: row)
            let adjacentValue = current
                .spread()
                .map { grid[$0] ?? outsideValue }
                .reduce(into: 0) { result, bit in
                    result *= 2
                    result += bit ? 1 : 0
                }
            result[current] = algorithm.contains(adjacentValue)
        }
    }

    return result
}

func enhance(grid: [Point: Bool], iterations: Int) -> [Point: Bool] {
    var grid = grid
    var outsideValue = !algorithm.contains(0)

    for _ in 0..<iterations {
        grid = enhance(grid: grid, outsideValue: outsideValue)
        outsideValue = algorithm.contains(outsideValue ? 511 : 0)
    }

    return grid
}

let input = try Input.loadInput(in: .module)
    .components(separatedBy: "\n\n")

let algorithm = input[0]
    .enumerated()
    .reduce(into: Set<Int>()) { onesSet, character in
        guard character.element == "#" else { return }
        onesSet.insert(character.offset)
    }

let initialGrid = input[1]
    .split(separator: "\n")
    .enumerated()
    .reduce(into: [:]) { state, line in
        line.element
            .enumerated()
            .forEach { x, character in
                state[Point(x: x, y: line.offset)] = (character == "#")
            }
    }

// MARK: - Part 1

let enhancedIterations2 = enhance(grid: initialGrid, iterations: 2)
let litPixelCountIterations2 = enhancedIterations2
    .values
    .filter { $0 }
    .count

print("-- Part 1")
print("Lit pixel count: \(litPixelCountIterations2)")

// MARK: - Part 2

let enhancedIterations50 = enhance(grid: initialGrid, iterations: 50)
let litPixelCountIterations50 = enhancedIterations50
    .values
    .filter { $0 }
    .count

print("-- Part 2")
print("Lit pixel count: \(litPixelCountIterations50)")
