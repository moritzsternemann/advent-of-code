//
//  main.swift
//  day15
//
//  Created by Moritz Sternemann on 15.12.21.
//

import Common

struct Point: Hashable {
    var x: Int
    var y: Int
    
    func neighbors(constrainedTo size: Int) -> [Point] {
        var neighbors: [Point] = []
        if x > 0 { neighbors.append(Point(x: x - 1, y: y)) }
        if y > 0 { neighbors.append(Point(x: x, y: y - 1)) }
        if x < size - 1 { neighbors.append(Point(x: x + 1, y: y)) }
        if y < size - 1 { neighbors.append(Point(x: x, y: y + 1)) }
        return neighbors
    }
}

/// Dijkstra 🥲
func findLowestRiskPath(points: [Point], size: Int, cost costFunction: (Point, Point) -> Int) -> [Point] {
    guard let source = points.first,
          let destination = points.last
    else { return [] }
    
    var frontier: [[Point]] = [[source]]
    var cost: [Point: Int] = [:]
    var predecessors: [Point: Point] = [:]
    
    cost[source] = 0
    
    while true {
        var i = 0
        var current: Point?
        while true {
            if frontier[i].isEmpty {
                i += 1
            } else {
                current = frontier[i].removeFirst()
                break
            }
        }
        
        guard let current = current else { fatalError() }
        if current == destination {
            break
        }
        
        for neighbor in current.neighbors(constrainedTo: size) {
            let alternativeCost = cost[current]! + costFunction(current, neighbor)
            if !cost.keys.contains(current) || alternativeCost < cost[neighbor, default: Int.max] {
                cost[neighbor] = alternativeCost
                while frontier.count < alternativeCost + 1 {
                    frontier.append([])
                }
                frontier[alternativeCost].append(neighbor)
                predecessors[neighbor] = current
            }
        }
    }
    
    guard predecessors[destination] != nil else { return [] }
    
    // walk the path in reverse from destination to source
    var path: [Point] = [destination]
    while let last = path.last, let predecessor = predecessors[last] {
        path.append(predecessor)
    }
    
    return path.reversed()
}

func calculateTotalRiskOfPath(_ path: [Point], risk: [[Int]]) -> Int {
    path
        .map { risk[$0.y][$0.x] }
        .reduce(0, +)
        - risk[0][0]
}

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map { line in line.map(String.init).compactMap(Int.init) }

// MARK: - Part 1

let allPoints = stride(from: 0, to: input.count, by: 1)
    .flatMap { row in
        stride(from: 0, to: input.count, by: 1)
            .map { Point(x: $0, y: row) }
    }

let lowRiskPath = findLowestRiskPath(points: allPoints, size: input.count) { _, v in
    input[v.y][v.x]
}
let lowestRiskPathTotalRisk = calculateTotalRiskOfPath(lowRiskPath, risk: input)

print("-- Part 1")
print("Lowest risk path total risk: \(lowestRiskPathTotalRisk)")

// MARK: - Part 2

func expandedGridOf(_ grid: [[Int]]) -> [[Int]] {
    let size = grid.count // always a square
    let newSize = size * 5
    var expandedGrid = Array(repeating: Array(repeating: 0, count: newSize), count: newSize)
    
    for column in 0..<newSize {
        for row in 0..<newSize {
            let originalX = column % size
            let originalY = row % size
            
            let gridOffsetX = column / size
            let gridOffsetY = row / size
            
            let originalValue = grid[originalY][originalX]
            let newValue = (originalValue + gridOffsetX + gridOffsetY) % 9
            if newValue == 0 {
                expandedGrid[column][row] = 9
            } else {
                expandedGrid[column][row] = newValue
            }
        }
    }
    
    return expandedGrid
}

let expandedGrid = expandedGridOf(input)
let expandedAllPoints = stride(from: 0, to: expandedGrid.count, by: 1)
    .flatMap { row in
        stride(from: 0, to: expandedGrid.count, by: 1)
            .map { Point(x: $0, y: row) }
    }

let expandedLowestRiskPath = findLowestRiskPath(points: expandedAllPoints, size: expandedGrid.count) { _, v in
    expandedGrid[v.y][v.x]
}
let expandedLowestRiskPathTotalRisk = calculateTotalRiskOfPath(expandedLowestRiskPath, risk: expandedGrid)

print("-- Part 2")
print("Lowest risk path total risk: \(expandedLowestRiskPathTotalRisk)")
