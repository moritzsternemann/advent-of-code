//
//  main.swift
//  day05
//
//  Created by Moritz Sternemann on 05.12.21.
//

import Common
import Foundation

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)
let diagramSize = 1000

struct Point {
    var x: Int
    var y: Int
}

struct Line {
    var start: Point
    var end: Point
}

let lines = input
    .compactMap { line -> Line? in
        let parts = line
            .replacingOccurrences(of: " -> ", with: ",")
            .split(separator: ",")
            .compactMap { Int($0) }
        guard parts.count == 4 else { return nil }
        
        // normalize so that start <= end
        let start: Point
        let end: Point
        if parts[0] == parts[2] {
            start = Point(x: parts[0], y: min(parts[1], parts[3]))
            end = Point(x: parts[2], y: max(parts[1], parts[3]))
        } else if parts[1] == parts[3] {
            start = Point(x: min(parts[0], parts[2]), y: parts[1])
            end = Point(x: max(parts[0], parts[2]), y: parts[3])
        } else {
            start = Point(x: parts[0], y: parts[1])
            end = Point(x: parts[2], y: parts[3])
        }
        
        return Line(start: start, end: end)
    }

func printDiagram(_ diagram: [[Int]]) {
    for row in diagram {
        let rowString = row
            .map { number in
                switch number {
                case 0: return "."
                default: return String(number)
                }
            }
            .joined(separator: " ")
        print(rowString)
    }
}

// MARK: - Part 1

var diagram: [[Int]] = Array(repeating: Array(repeating: 0, count: diagramSize), count: diagramSize)

// mark positions
for line in lines {
    if line.start.x != line.end.x && line.start.y != line.end.y {
        continue // skip non horizontal/vertical lines
    }
    
    // vertical line
    if line.start.x == line.end.x {
        for rowIndex in line.start.y...line.end.y {
            diagram[rowIndex][line.start.x] += 1
        }
    }
    
    // horizontal line
    if line.start.y == line.end.y {
        for columnIndex in line.start.x...line.end.x {
            diagram[line.start.y][columnIndex] += 1
        }
    }
}

let overlapCountPart1 = diagram
    .reduce(0) { result, row in
        return result + row
            .filter { $0 > 1 }
            .map { _ in 1 }
            .reduce(0, +)
    }

print("-- Part 1")
print("Overlap count: \(overlapCountPart1)")

// MARK: - Part 2

diagram = Array(repeating: Array(repeating: 0, count: diagramSize), count: diagramSize)

// mark positions
for line in lines {
    if line.start.x == line.end.x {
        // vertical line
        for rowIndex in line.start.y...line.end.y {
            diagram[rowIndex][line.start.x] += 1
        }
    } else if line.start.y == line.end.y {
        // horizontal line
        for columnIndex in line.start.x...line.end.x {
            diagram[line.start.y][columnIndex] += 1
        }
    } else {
        // diagonal line
        assert(abs(line.start.x - line.end.x) == abs(line.start.y - line.end.y))
        
        let rows = line.start.y < line.end.y
            ? Array(line.start.y...line.end.y)
            : Array(line.end.y...line.start.y).reversed()
        let columns = line.start.x < line.end.x
            ? Array(line.start.x...line.end.x)
            : Array(line.end.x...line.start.x).reversed()
        
        for point in zip(rows, columns) {
            diagram[point.0][point.1] += 1
        }
    }
}

let overlapCountPart2 = diagram
    .reduce(0) { result, row in
        return result + row
            .filter { $0 > 1 }
            .map { _ in 1 }
            .reduce(0, +)
    }

print("-- Part 2")
print("Overlap count: \(overlapCountPart2)")
