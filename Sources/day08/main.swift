//
//  main.swift
//  day08
//
//  Created by Moritz Sternemann on 08.12.21.
//

import Common

let input: [[Set<Character>]: [Set<Character>]] = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .reduce(into: [:]) { result, line in
        let parts = line.split(separator: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard let signals = parts[safe: 0], let output = parts[safe: 1] else { return }
        result[signals.split(separator: " ").map(Set.init)] = output.split(separator: " ").map(Set.init)
    }

enum Digit: Int {
    case digit0
    case digit1
    case digit2
    case digit3
    case digit4
    case digit5
    case digit6
    case digit7
    case digit8
    case digit9
    
    static let unique: [Digit] = [.digit1, .digit4, .digit7, .digit8]
    
    var segmentCount: Int {
        switch self {
        case .digit1:
            return 2
        case .digit7:
            return 3
        case .digit4:
            return 4
        case .digit2, .digit3, .digit5:
            return 5
        case .digit0, .digit6, .digit9:
            return 6
        case .digit8:
            return 7
        }
    }
}

// MARK: - Part 1

// focus on 1 -> 2 segments
//          4 -> 4 segments
//          7 -> 3 segments
//          8 -> 7 segments
let uniqueDigitsSegmentCounts = Digit.unique.map(\.segmentCount)
let wordCount = input
    .flatMap(\.value)
    .filter { uniqueDigitsSegmentCounts.contains($0.count) }
    .count

print("-- Part 1")
print("Word count: \(wordCount)")

// MARK: - Part 2

func resolveDigitPatterns(of signals: [Set<Character>]) -> [Digit: Set<Character>] {
    // Patterns for unique digits
    let patternsUniqueLength: [Digit: Set<Character>] = signals
        .compactMap { signal -> (Digit, Set<Character>)? in
            guard let digit = Digit.unique.first(where: { $0.segmentCount == signal.count }) else { return nil }
            return (digit, signal)
        }
        .reduce(into: [:]) { $0[$1.0] = $1.1 }
    
    // Patterns of digits 4 and 1, and the part of 4 without 1 can be used to identify the remaining digits
    guard let patternDigit4 = patternsUniqueLength[.digit4],
          let patternDigit1 = patternsUniqueLength[.digit1]
    else { return [:] }
    let patternDigit4Unique = patternDigit4.subtracting(patternDigit1)
    
    // Differentiate patterns of length 5 (2, 3, 5)
    let patternsLength5: [Digit: Set<Character>] = signals
        .filter { $0.count == Digit.digit5.segmentCount }
        .reduce(into: [:]) { patterns, signal in
            if patternDigit1.isSubset(of: signal) {
                patterns[.digit3] = signal
            } else if patternDigit4Unique.isSubset(of: signal) {
                patterns[.digit5] = signal
            } else {
                patterns[.digit2] = signal
            }
        }
    
    // Differentiate patterns of length 6 (0, 6, 9)
    let patternsLength6: [Digit: Set<Character>] = signals
        .filter { $0.count == Digit.digit6.segmentCount }
        .reduce(into: [:]) { patterns, signal in
            if patternDigit4Unique.isSubset(of: signal) && patternDigit1.isSubset(of: signal) {
                patterns[.digit9] = signal
            } else if patternDigit4Unique.isSubset(of: signal) {
                patterns[.digit6] = signal
            } else {
                patterns[.digit0] = signal
            }
        }
    
    return patternsUniqueLength
        .merging(patternsLength5) { (current, _) in current }
        .merging(patternsLength6) { (current, _) in current }
}

let numbersSum = input
    .compactMap { (signals, outputs) -> Int? in
        let patterns = resolveDigitPatterns(of: signals)
        let digits = outputs
            .compactMap { output in
                patterns.first(where: { $1 == output })?.key
            }
            .map(\.rawValue)
            .map { String($0) }
            .joined()
        return Int(digits)
    }
    .reduce(0, +)

print("-- Part 2")
print("Sum of displayed numbers: \(numbersSum)")
