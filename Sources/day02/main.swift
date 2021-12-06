//
//  main.swift
//  day02
//
//  Created by Moritz Sternemann on 02.12.21.
//

import Common
import Foundation

enum Command {
    case forward(Int)
    case up(Int)
    case down(Int)
}

let commands = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .compactMap { line -> Command? in
        let parts = line.split(separator: " ")
        guard let amount = Int(parts[1]) else { return nil }
        
        switch parts[0] {
        case "forward":
            return .forward(amount)
        case "up":
            return .up(amount)
        case "down":
            return .down(amount)
        default:
            return nil
        }
    }

// MARK: - Part 1

let result1 = commands
    .reduce((horizontal: 0, depth: 0)) { result, command in
        switch command {
        case let .forward(amount):
            return (result.horizontal + amount, result.depth)
        case let .up(amount):
            return (result.horizontal, result.depth - amount)
        case let .down(amount):
            return (result.horizontal, result.depth + amount)
        }
    }

print("-- Part 1")
print("Horizontal: \(result1.horizontal), Depth: \(result1.depth), Product: \(result1.horizontal * result1.depth)")

// MARK: - Part 2

let result2 = commands
    .reduce((horizontal: 0, depth: 0, aim: 0)) { result, command in
        switch command {
        case let .forward(amount):
            return (result.horizontal + amount, result.depth + (result.aim * amount), result.aim)
        case let .up(amount):
            return (result.horizontal, result.depth, result.aim - amount)
        case let .down(amount):
            return (result.horizontal, result.depth, result.aim + amount)
        }
    }

print("-- Part 2")
print("Horizontal: \(result2.horizontal), Depth: \(result2.depth), Aim: \(result2.aim), Product: \(result2.horizontal * result2.depth)")
