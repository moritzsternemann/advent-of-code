//
//  main.swift
//  day11
//
//  Created by Moritz Sternemann on 11.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map { line in line.compactMap { Int(String($0)) } }

struct Point: Hashable {
    var row: Int
    var column: Int
}

func adjacentPoints(of point: Point, width: Int, height: Int) -> [Point] {
    return [
        Point(row: point.row - 1, column: point.column),     // top
        Point(row: point.row - 1, column: point.column + 1), // top right
        Point(row: point.row, column: point.column + 1),     // right
        Point(row: point.row + 1, column: point.column + 1), // bottom right
        Point(row: point.row + 1, column: point.column),     // bottom
        Point(row: point.row + 1, column: point.column - 1), // bottom left
        Point(row: point.row, column: point.column - 1),     // left
        Point(row: point.row - 1, column: point.column - 1)  // top left
    ].filter { $0.row >= 0 && $0.row < height && $0.column >= 0 && $0.column < width }
}

func step(_ grid: inout [[Int]]) -> Int {
    let width = grid.count
    let height = grid[0].count
    
    // increment every octopus by one
    for row in 0..<height {
        for column in 0..<width {
            grid[row][column] += 1
        }
    }
    
    var flashes = Set<Point>()
    var flashAdjacentPoints: [Point] = []
    
    // find octopus that flash
    for row in 0..<height {
        for column in 0..<width {
            guard grid[row][column] > 9 else { continue }
            let flashPoint = Point(row: row, column: column)
            flashes.insert(flashPoint)
            
            flashAdjacentPoints.append(contentsOf: adjacentPoints(of: flashPoint, width: width, height: height))
        }
    }
    
    // propagate flashes
    while !flashAdjacentPoints.isEmpty {
        let adjacent = flashAdjacentPoints.removeFirst()
        grid[adjacent.row][adjacent.column] += 1
        
        guard grid[adjacent.row][adjacent.column] > 9 && !flashes.contains(adjacent) else { continue }
        flashes.insert(adjacent)
        flashAdjacentPoints.append(contentsOf: adjacentPoints(of: adjacent, width: width, height: height))
    }
    
    // count flashes
    var flashCount = 0
    for row in 0..<height {
        for column in 0..<width {
            guard grid[row][column] > 9 else { continue }
            grid[row][column] = 0
            flashCount += 1
        }
    }
    
    return flashCount
}

// MARK: - Part 1

var grid = input
var flashCount = 0
for _ in 0..<100 {
    flashCount += step(&grid)
}

print("-- Part 1")
print("Flashe count: \(flashCount)")

// MARK: - Part 2

grid = input
let width = grid.count
let height = grid[0].count
// run steps until all flash
var stepCount = 0
while step(&grid) != width * height {
    stepCount += 1
}

print("-- Part 2")
print("Step count: \(stepCount + 1)")
