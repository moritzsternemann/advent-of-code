//
//  main.swift
//  day06
//
//  Created by Moritz Sternemann on 06.12.21.
//

import Common
import Foundation

struct Fish {
    var timer: Int
    
    mutating func age() -> Fish? {
        if timer == 0 {
            timer = 6
            return Fish(timer: 8)
        }
        
        timer -= 1
        return nil
    }
}

// MARK: - Part 1

var fishPart1 = try Input.loadInput(in: .module)
    .split(separator: ",")
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    .compactMap { Int($0) }
    .map(Fish.init(timer:))

for _ in 0..<80 {
    for index in 0..<fishPart1.count {
        if let newFish = fishPart1[index].age() {
            fishPart1.append(newFish)
        }
    }
}

print("-- Part 1")
print("Count: \(fishPart1.count)")

var fishPart2 = try Input.loadInput(in: .module)
    .split(separator: ",")
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    .compactMap { Int($0) }
    .reduce(into: Dictionary<Int, Int64>()) { acc, fish in
        acc[fish, default: 0] += 1
    }

func simulateFish(_ fish: [Int: Int64]) -> [Int: Int64] {
    var fish = fish.reduce(into: [:]) { $0[$1.key - 1] = $1.value }
    fish[8] = fish[-1] ?? 0
    fish[6] = (fish[6] ?? 0) + (fish[-1] ?? 0)
    fish.removeValue(forKey: -1)
    return fish
}

for _ in 0..<256 {
    fishPart2 = simulateFish(fishPart2)
}

print("-- Part 2")
print("Count: \(fishPart2.values.reduce(0, +))")
