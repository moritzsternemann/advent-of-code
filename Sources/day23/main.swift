//
//  main.swift
//  day23
//
//  Created by Moritz Sternemann on 23.12.21.
//

import Common

struct Point: Hashable {
    var x: Int
    var y: Int

    var adjacent: Set<Point> {
        [
            Point(x: x, y: y - 1),
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
            Point(x: x - 1, y: y)
        ]
    }
}

enum Amphipod: Character, CaseIterable {
    case amber = "A"
    case bronze = "B"
    case copper = "C"
    case desert = "D"

    var energyLevel: Int {
        switch self {
        case .amber:
            return 1
        case .bronze:
            return 10
        case .copper:
            return 100
        case .desert:
            return 1000
        }
    }
}

typealias HomesResolver = (Amphipod) -> [Point]

struct Board: Hashable {
    var points: Set<Point>
    var availablePositions: Set<Point>
    var amphipods: [Point: Amphipod]

    func minimumEstimatedRequiredEnergy(homesResolver: HomesResolver) -> Int {
        var totalEnergy: Int = 0

        for amphipod in Amphipod.allCases {
            var homes = homesResolver(amphipod)
            var positions = amphipods
                .filter { $0.value == amphipod }
                .keys
                .toSet()

            let overlap = homes
                .reversed()
                .prefix(while: positions.contains(_:))
            homes.removeAll()
            overlap.forEach { positions.remove($0) }

            let energy = zip(positions, homes)
                .reduce(0) { energy, pair in
                    let (position, home) = pair
                    let distance: Int
                    if position.y == 1 {
                        distance = home.y - 1 + abs(position.x - home.x)
                    } else {
                        if position.x == home.x {
                            distance = home.y + 2
                        } else {
                            distance = home.y + position.y - 2 + abs(position.x - home.x)
                        }
                    }

                    return energy + distance * amphipod.energyLevel
                }
            totalEnergy += energy
        }

        return totalEnergy
    }

    /// - Returns: Dictionary with reachable positions and the step count to reach them.
    private func reachableFrom(_ initialPosition: Point) -> [Point: Int] {
        var stepCount = 0
        var reachablePositions: [Point: Int] = [:]

        var currentPositions: Set<Point> = [initialPosition]
        while !currentPositions.isEmpty {
            stepCount += 1

            var potentiallyReachable = currentPositions
                .map(\.adjacent)
                .reduce(Set<Point>()) { potentiallyReachable, currentReachable in
                    potentiallyReachable.union(currentReachable)
                }
            potentiallyReachable.remove(initialPosition)
            potentiallyReachable.formIntersection(points)
            potentiallyReachable.subtract(amphipods.keys)
            potentiallyReachable.subtract(reachablePositions.keys)

            potentiallyReachable
                .forEach { reachablePositions[$0] = stepCount }
            currentPositions = potentiallyReachable
        }

        return reachablePositions
    }

    /// - Returns: Dictionary with new board possibilites along their required energy.
    func step(homesResolver: HomesResolver) -> [Board: Int] {
        amphipods
            .reduce(into: [:]) { result, entry in
                let (position, amphipod) = entry
                let homes = homesResolver(amphipod)

                if let homeIndex = homes.firstIndex(of: position),
                   homes
                    .dropFirst(homeIndex + 1)
                    .allSatisfy({ amphipods[$0] == amphipod }) {
                    return
                }

                for (reachablePosition, stepCount) in reachableFrom(position) {
                    if homes.contains(reachablePosition) {
                        let lowerHomes = homes
                            .drop(while: { $0 != reachablePosition })
                            .dropFirst()
                        guard lowerHomes.allSatisfy({ self.amphipods[$0] == amphipod }) else {
                            continue
                        }
                    } else if availablePositions.contains(reachablePosition) {
                        if position.y == 1 { continue }
                    } else {
                        continue
                    }

                    var amphipods = amphipods
                    amphipods.removeValue(forKey: position)
                    amphipods[reachablePosition] = amphipod

                    let requiredEnergy = stepCount * amphipod.energyLevel
                    let newBoard = Board(
                        points: points,
                        availablePositions: availablePositions,
                        amphipods: amphipods
                    )
                    result[newBoard] = requiredEnergy
                }
            }
    }
}

func loadInput(filename: String) throws -> Board {
    let input = try Input.loadInput(filename: filename, in: .module)
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "\n")

    var points: Set<Point> = []
    var availablePositions: Set<Point> = []
    var amphipods: [Point: Amphipod] = [:]

    for (rowIndex, line) in input.enumerated() {
        for (columnIndex, character) in line.enumerated() {
            guard character != " " && character != "#" else { continue }

            let point = Point(x: columnIndex, y: rowIndex)
            points.insert(point)

            if character == "." {
                availablePositions.insert(point)
            } else if let amphipod = Amphipod(rawValue: character) {
                amphipods[point] = amphipod
            }
        }
    }

    availablePositions.remove(Point(x: 3, y: 1))
    availablePositions.remove(Point(x: 5, y: 1))
    availablePositions.remove(Point(x: 7, y: 1))
    availablePositions.remove(Point(x: 9, y: 1))

    return Board(points: points, availablePositions: availablePositions, amphipods: amphipods)
}

func organizeAmphipods(filename: String = "input", homesResolver: HomesResolver) throws -> Int {
    let initialBoard = try loadInput(filename: filename)

    let finalPositions: [Point: Amphipod] = Amphipod.allCases
        .reduce(into: [:]) { finalPositions, amphipod in
            homesResolver(amphipod)
                .forEach { finalPositions[$0] = amphipod }
        }

    var testedBoards: [[Point: Amphipod]: Int] = [initialBoard.amphipods: 0]
    var currentBoards: [Board: (Int, Int)] = [initialBoard: (0, initialBoard.minimumEstimatedRequiredEnergy(homesResolver: homesResolver))]
    var minimumRequiredEnergy = Int.max

    while let (board, energies) = currentBoards.min(by: { ($0.value.1, $0.value.0) < ($1.value.1, $1.value.0) }) {
        currentBoards.removeValue(forKey: board)
        let energy = energies.0

        if let testedBoard = testedBoards[board.amphipods], testedBoard < energy {
            continue
        }

        guard energy + energies.1 < minimumRequiredEnergy else { continue }

        for (nextBoard, requiredEnergy) in board.step(homesResolver: homesResolver) {
            let nextRequiredEnergy = energy + requiredEnergy
            guard nextRequiredEnergy < minimumRequiredEnergy else { continue }

            if nextBoard.amphipods == finalPositions {
                minimumRequiredEnergy = min(minimumRequiredEnergy, nextRequiredEnergy)
                continue
            }

            if let testedRequiredEnergy = testedBoards[nextBoard.amphipods],
               testedRequiredEnergy <= nextRequiredEnergy {
                continue
            }

            testedBoards[nextBoard.amphipods] = nextRequiredEnergy
            currentBoards[nextBoard] = (nextRequiredEnergy, nextBoard.minimumEstimatedRequiredEnergy(homesResolver: homesResolver))
        }
    }

    return minimumRequiredEnergy
}

// MARK: - Part 1

let part1MinimumRequiredEnergy = try organizeAmphipods { amphipod in
    switch amphipod {
    case .amber:
        return (2...3).map { Point(x: 3, y: $0) }
    case .bronze:
        return (2...3).map { Point(x: 5, y: $0) }
    case .copper:
        return (2...3).map { Point(x: 7, y: $0) }
    case .desert:
        return (2...3).map { Point(x: 9, y: $0) }
    }
}

print("-- Part 1")
print("Minimum required energy: \(part1MinimumRequiredEnergy)")

// MARK: - Part 2

let part2MinimumRequiredEnergy = try organizeAmphipods(filename: "input2") { amphipod in
    switch amphipod {
    case .amber:
        return (2...5).map { Point(x: 3, y: $0) }
    case .bronze:
        return (2...5).map { Point(x: 5, y: $0) }
    case .copper:
        return (2...5).map { Point(x: 7, y: $0) }
    case .desert:
        return (2...5).map { Point(x: 9, y: $0) }
    }
}

print("-- Part 2")
print("Minimum required energy: \(part2MinimumRequiredEnergy)")
