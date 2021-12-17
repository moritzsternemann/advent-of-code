//
//  main.swift
//  day17
//
//  Created by Moritz Sternemann on 17.12.21.
//

import Common

struct Area {
    var horizontal: ClosedRange<Int>
    var vertical: ClosedRange<Int>
    
    func contains(_ vector: Vector) -> Bool {
        horizontal.contains(vector.x) && vertical.contains(vector.y)
    }
}

struct Vector: Equatable {
    var x: Int
    var y: Int
    
    static var zero: Vector {
        Vector(x: 0, y: 0)
    }
    
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

struct Probe {
    var position: Vector
    var velocity: Vector
    
    func canReachTarget(_ target: Area) -> Bool {
        return position.x <= target.horizontal.upperBound
            && position.y >= target.vertical.lowerBound
    }
    
    var next: Probe {
        let horizontalAcceleration: Int
        if velocity.x < 0 {
            horizontalAcceleration = 1
        } else if velocity.x > 0 {
            horizontalAcceleration = -1
        } else {
            horizontalAcceleration = 0
        }
        
        return Probe(
            position: position + velocity,
            velocity: velocity + Vector(x: horizontalAcceleration, y: -1)
        )
    }
}

func readTargetArea(_ axis: Substring) -> ClosedRange<Int> {
    let parts = axis
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "=")
    let numbers = parts[1].components(separatedBy: "..")
    return Int(numbers[0])!...Int(numbers[1])!
}

func vectorsToAllPointsInArea(_ area: Area) -> [Vector] {
    area.horizontal
        .flatMap { column in
            area.vertical
                .map { Vector(x: column, y: $0) }
        }
}

let input = try Input.loadInput(in: .module)
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .replacingOccurrences(of: "target area: ", with: "")
    .split(separator: ",")

let target = Area(horizontal: readTargetArea(input[0]), vertical: readTargetArea(input[1]))

// MARK: - Part 1

func calculateMaxHeightOfProbeWithVelocity(_ velocity: Vector, target: Area) -> Int? {
    let probe = Probe(position: .zero, velocity: velocity)
    var probes = [probe]
    
    while let probe = probes.last, probe.canReachTarget(target) {
        if target.contains(probe.position) {
            return probes.max(by: { $0.position.y < $1.position.y })?.position.y
        }
        
        probes.append(probe.next)
    }
    
    return nil
}

// maximize height of the probe while still reaching the target
let maxHeightProbeRange = Area(horizontal: 0...300, vertical: 0...300)
let probeMaxHeight = vectorsToAllPointsInArea(maxHeightProbeRange)
    .compactMap { calculateMaxHeightOfProbeWithVelocity($0, target: target) }
    .max()!

print("-- Part 1")
print("Probe can reach max height: \(probeMaxHeight)")

// MARK: - Part 2

func checkProbeReachesTargetWithVelocity(_ velocity: Vector, target: Area) -> Bool {
    var probe = Probe(position: .zero, velocity: velocity)
    
    while probe.canReachTarget(target) {
        if target.contains(probe.position) {
            return true
        }
        probe = probe.next
    }
    
    return false
}

let reachingTargetProbeRange = Area(horizontal: 0...300, vertical: -300...300)
let vectorsReachingTarget = vectorsToAllPointsInArea(reachingTargetProbeRange)
    .filter { checkProbeReachesTargetWithVelocity($0, target: target) }

print("-- Part 2")
print("Start vectors where the probe reaches the target: \(vectorsReachingTarget.count)")
