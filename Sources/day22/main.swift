//
//  main.swift
//  day22
//
//  Created by Moritz Sternemann on 22.12.21.
//

import Common

enum Instruction {
    case on(_ coordinateRange: [ClosedRange<Int>])
    case off(_ coordinateRange: [ClosedRange<Int>])

    var coordinateRange: [ClosedRange<Int>] {
        switch self {
        case let .on(coordinateRange):
            return coordinateRange
        case let .off(coordinateRange):
            return coordinateRange
        }
    }

    var isOn: Bool {
        switch self {
        case .on:
            return true
        case .off:
            return false
        }
    }
}

extension ClosedRange {
    func intersection(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        guard overlaps(other) else { return nil }

        let clamped = clamped(to: other)
        if !clamped.isEmpty {
            return clamped
        }

        fatalError()
    }

    func contains(_ other: ClosedRange<Bound>) -> Bool {
        contains(other.lowerBound) && contains(other.upperBound)
    }
}

func rebootWithFilter(_ filter: ([ClosedRange<Int>]) -> Bool) -> Int {
    var cubeCounts: [[ClosedRange<Int>]: Int] = [:]

    for instruction in input {
        guard filter(instruction.coordinateRange) else { continue }

        for (coordinateRange, sign) in cubeCounts {
            let intersectingRanges = zip(instruction.coordinateRange, coordinateRange)
                .compactMap { $0.0.intersection($0.1) }

            if intersectingRanges.count == 3 {
                cubeCounts[intersectingRanges, default: 0] -= sign
            }
        }

        if instruction.isOn {
            cubeCounts[instruction.coordinateRange, default: 0] += 1
        }
    }

    return cubeCounts
        .map { count in
            count.key
                .map(\.count)
                .reduce(1, *)
                * count.value
        }
        .reduce(0, +)
}

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map { line -> Instruction in
        let parts = line.split(separator: " ")
        let coordinates = parts[1]
            .split(separator: ",")
            .map { part in
                part
                    .dropFirst(2)
                    .components(separatedBy: "..")
                    .compactMap(Int.init)
            }
            .map { $0[0]...$0[1] }
        return parts[0] == "on" ? .on(coordinates) : .off(coordinates)
    }

// MARK: - Part 1

let coordinateRangeFilter = (-50...50)
let filteredCubeCount = rebootWithFilter { coordinateRanges in
    coordinateRangeFilter.contains(coordinateRanges[0])
        && coordinateRangeFilter.contains(coordinateRanges[1])
        && coordinateRangeFilter.contains(coordinateRanges[2])
}

print("-- Part 1")
print("Confined range turned on cube count: \(filteredCubeCount)")

// MARK: - Part 2

let unfilteredCubeCount = rebootWithFilter { _ in true }

print("-- Part 2")
print("Unconfined turned on cube count: \(unfilteredCubeCount)")
