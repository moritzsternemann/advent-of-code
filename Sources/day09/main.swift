//
//  main.swift
//  day09
//
//  Created by Moritz Sternemann on 09.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map { $0.compactMap(\.wholeNumberValue) }

struct Point: Hashable {
    var row: Int
    var column: Int
}

func adjacentPoints(of point: Point) -> [Point] {
    return [
        Point(row: point.row - 1, column: point.column),
        Point(row: point.row, column: point.column + 1),
        Point(row: point.row + 1, column: point.column),
        Point(row: point.row, column: point.column - 1)
    ]
}

let lowPoints: [Point] = stride(from: 0, to: input.count, by: 1)
    .flatMap { row in
        stride(from: 0, to: input[row].count, by: 1).map { Point(row: row, column: $0) }
    }
    .reduce(into: []) { result, point in
        let adjacentHeights = adjacentPoints(of: point)
            .compactMap { input[safe: $0.row]?[safe: $0.column] }

        if let minAdjacent = adjacentHeights.min(), minAdjacent > input[point.row][point.column] {
            result.append(point)
        }
    }

// MARK: - Part 1

let riskLevelSum = lowPoints
    .map { input[$0.row][$0.column] + 1 }
    .reduce(0, +)

print("-- Part 1")
print("Sum of risk levels: \(riskLevelSum)")

// MARK: - Part 2

func pointsInBasin(lowPoint point: Point) -> Set<Point> {
    func expandBasin(_ basin: Set<Point>) -> Set<Point> {
        var expandedBasin = basin
        for point in basin {
            let adjacent = adjacentPoints(of: point)
                .filter {
                    guard let value = input[safe: $0.row]?[safe: $0.column] else { return false }
                    return value < 9
                }
            expandedBasin = expandedBasin.union(adjacent)
        }
        return expandedBasin
    }
    
    var basin = Set([point])
    var expandedBasin: Set<Point>
    while true {
        expandedBasin = expandBasin(basin)
        if expandedBasin.count == basin.count {
            return expandedBasin
        }
        basin = expandedBasin
    }
}

let basinSizesProduct = lowPoints
    .map(pointsInBasin(lowPoint:))
    .sorted { $0.count < $1.count }
    .suffix(3)
    .map(\.count)
    .reduce(1, *)

print("-- Part 2")
print("Product of basin sizes: \(basinSizesProduct)")
