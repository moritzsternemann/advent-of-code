//
//  main.swift
//  day10
//
//  Created by Moritz Sternemann on 10.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map { String($0) }
    .filter { !$0.isEmpty }

func complementOf(_ character: Character) -> Character {
    switch character {
    case "(": return ")"
    case "[": return "]"
    case "{": return "}"
    case "<": return ">"
    case ")": return "("
    case "]": return "["
    case "}": return "{"
    case ">": return "<"
    default: fatalError("Invalid character")
    }
}

// MARK: - Part 1

func illegalPoints(for character: Character) -> Int {
    switch character {
    case ")": return 3
    case "]": return 57
    case "}": return 1197
    case ">": return 25137
    default: fatalError("Invalid character")
    }
}

func validateLine(_ line: String) -> Character? {
    var stack: [Character] = []
    for character in line {
        switch character {
        case "(", "[", "{", "<":
            stack.append(character)
        case ")", "]", "}", ">":
            if complementOf(character) != stack.last {
                return character
            }
            stack.removeLast()
        default:
            fatalError("Invalid character")
        }
    }
    
    return nil
}

let corruptedSum = input
    .compactMap(validateLine(_:))
    .map(illegalPoints(for:))
    .reduce(0, +)

print("-- Part 1")
print("Sum of corrupted line scores: \(corruptedSum)")

// MARK: - Part 2

func missingPoints(for character: Character) -> Int {
    switch character {
    case ")": return 1
    case "]": return 2
    case "}": return 3
    case ">": return 4
    default: fatalError("Invalid character")
    }
}

func completeLine(_ line: String) -> [Character] {
    var stack: [Character] = []
    for character in line {
        switch character {
        case "(", "[", "{", "<":
            stack.append(character)
        case ")", "]", "}", ">":
            if complementOf(character) == stack.last {
                stack.removeLast()
            } else {
                fatalError("Chunks should be valid")
            }
        default:
            fatalError("Invalid character")
        }
    }
    
    return stack
}

let lineMissingScores = input
    .filter { validateLine($0) == nil }
    .map(completeLine(_:))
    .filter { !$0.isEmpty }
    .map { missing -> Int in
        return missing
            .reversed()
            .map(complementOf(_:))
            .map(missingPoints(for:))
            .reduce(0) { total, characterScore in
                (total * 5) + characterScore
            }
    }
    .sorted()

print("-- Part 2")
print("Middle missing score: \(lineMissingScores[lineMissingScores.count / 2])")
