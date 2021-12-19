//
//  main.swift
//  day19
//
//  Created by Moritz Sternemann on 19.12.21.
//

import Common

struct Position: Hashable {
    var x: Int
    var y: Int
    var z: Int

    static var zero: Position {
        Position(x: 0, y: 0, z: 0)
    }

    func adjustedForOrientation(_ orientation: Int) -> Position {
        // no need to identify the different orientations, just need to take care of all
        switch orientation {
        case 00: return Position(x: x, y: y, z: z)
        case 01: return Position(x: x, y: -y, z: -z)
        case 02: return Position(x: x, y: z, z: -y)
        case 03: return Position(x: x, y: -z, z: y)
        case 04: return Position(x: -x, y: y, z: -z)
        case 05: return Position(x: -x, y: -y, z: z)
        case 06: return Position(x: -x, y: z, z: y)
        case 07: return Position(x: -x, y: -z, z: -y)
        case 08: return Position(x: y, y: x, z: -z)
        case 09: return Position(x: y, y: -x, z: z)
        case 10: return Position(x: y, y: z, z: x)
        case 11: return Position(x: y, y: -z, z: -x)
        case 12: return Position(x: -y, y: x, z: z)
        case 13: return Position(x: -y, y: -x, z: -z)
        case 14: return Position(x: -y, y: z, z: -x)
        case 15: return Position(x: -y, y: -z, z: x)
        case 16: return Position(x: z, y: x, z: y)
        case 17: return Position(x: z, y: -x, z: -y)
        case 18: return Position(x: z, y: y, z: -x)
        case 19: return Position(x: z, y: -y, z: x)
        case 20: return Position(x: -z, y: x, z: -y)
        case 21: return Position(x: -z, y: -x, z: y)
        case 22: return Position(x: -z, y: y, z: x)
        case 23: return Position(x: -z, y: -y, z: -x)
        default: fatalError()
        }
    }

    static func + (lhs: Position, rhs: Position) -> Position {
        Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static func - (lhs: Position, rhs: Position) -> Position {
        Position(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}

struct Scanner {
    let position: Position
    let orientation: Int
    let beacons: Set<Position>
    let resolvedBeacons: Set<Position>

    init(position: Position = .zero, orientation: Int = 0, beacons: Set<Position>) {
        self.position = position
        self.orientation = orientation
        self.beacons = beacons

        // Resolve relative coordinates
        self.resolvedBeacons = beacons
            .map { $0.adjustedForOrientation(orientation) }
            .map { $0 + position }
            .toSet()
    }

    func matchWithOtherScanner(_ other: Scanner) -> Scanner? {
        for beacon in resolvedBeacons {
            for orientationTransformation in 0...23 {
                for otherBeacon in other.beacons {
                    let offsetPosition = beacon - otherBeacon.adjustedForOrientation(orientationTransformation)

                    let matchedScanner = Scanner(position: offsetPosition, orientation: orientationTransformation, beacons: other.beacons)
                    guard resolvedBeacons.intersection(matchedScanner.resolvedBeacons).count >= 12 else { continue }
                    return matchedScanner
                }
            }
        }
        return nil
    }
}

func matchScanners(_ scanners: [Scanner]) -> [Scanner] {
    var scanners = scanners
    var matchedScanners = [scanners.removeFirst()] // first scanner is our reference

    while !scanners.isEmpty {
        for matchedScanner in matchedScanners {
            for (index, _) in scanners.enumerated() {
                guard let matchedScanner = matchedScanner.matchWithOtherScanner(scanners[index])
                else { continue }

                matchedScanners.append(matchedScanner)
                scanners.remove(at: index)
                break
            }
        }
    }

    return matchedScanners
}

let scanners = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .reduce(into: []) { (beacons: inout [Set<Position>], line: Substring) in
        if line.hasPrefix("---") {
            beacons.append([])
            return
        }

        let positions = line
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)

        beacons[beacons.count - 1].insert(Position(x: positions[0], y: positions[1], z: positions[2]))
    }
    .map { Scanner(beacons: $0) }

let matchedScanners = matchScanners(scanners)


// MARK: - Part 1

let beaconCount = matchedScanners
    .map(\.resolvedBeacons)
    .reduce(Set<Position>()) { $0.union($1) }
    .count

print("-- Part 1")
print("Beacon count: \(beaconCount)")

// MARK: - Part 2

let distancesBetweenScanners = stride(from: 0, to: matchedScanners.count, by: 1)
    .flatMap { first in
        stride(from: 0, to: matchedScanners.count, by: 1)
            .map { (first, $0) }
    }
    .filter { $0.0 != $0.1 }
    .map { (matchedScanners[$0.0], matchedScanners[$0.1]) }
    .map { scanners -> Int in
        let delta = scanners.0.position - scanners.1.position
        return abs(delta.x) + abs(delta.y) + abs(delta.z) // manhattan distance
    }

print("-- Part 2")
print("Maximum distance between scanners: \(distancesBetweenScanners.max()!)")

// MARK: - Debug

extension Position: CustomStringConvertible {
    var description: String {
        "\(x),\(y),\(z)"
    }
}
