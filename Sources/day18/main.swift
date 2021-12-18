//
//  main.swift
//  day18
//
//  Created by Moritz Sternemann on 18.12.21.
//

import Algorithms
import Common

enum SnailfishNumber: Equatable {
    case regular(_ value: Int)
    indirect case pair(_ lhs: SnailfishNumber, _ rhs: SnailfishNumber)

    init(string: String) {
        func parse(string: inout String) -> SnailfishNumber {
            switch string.first {
            case "[":
                return parsePair(string: &string)
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                return parseRegular(string: &string)
            default:
                fatalError("Unexpected character")
            }
        }

        func parsePair(string: inout String) -> SnailfishNumber {
            string.removeFirst() // [
            let lhs = parse(string: &string)
            string.removeFirst() // ,
            let rhs = parse(string: &string)
            string.removeFirst() // ]

            return .pair(lhs, rhs)
        }

        func parseRegular(string: inout String) -> SnailfishNumber {
            let character = string.removeFirst()
            guard let number = Int(String(character)) else { fatalError() }
            return .regular(number)
        }

        var string = string
        self = parse(string: &string)
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        .pair(lhs, rhs)
    }

    var magnitude: Int {
        switch self {
        case let .regular(number):
            return number
        case let .pair(lhs, rhs):
            return lhs.magnitude * 3 + rhs.magnitude * 2
        }
    }

    var nestedPairDepth: Int {
        switch self {
        case .regular:
            return 0
        case let .pair(lhs, rhs):
            return max(1 + lhs.nestedPairDepth, 1 + rhs.nestedPairDepth)
        }
    }

    func reduced() -> SnailfishNumber {
        var number = self

        func reduce() -> Bool {
            number.explode() ? true : number.split()
        }

        while true {
            if !reduce() { break }
        }

        return number
    }

    private mutating func explode() -> Bool {
        guard case .pair = self,
              nestedPairDepth > 4
        else { return false }

        let path = findPathToPairAtDepth(4)
        return explodeAtPath(path)
    }

    private func findPathToPairAtDepth(_ depth: Int) -> [ExplodePathComponent] {
        switch self {
        case .pair(.regular, .regular):
            return [.root(self)]
        case let .pair(.regular, rhs):
            return [.right] + rhs.findPathToPairAtDepth(depth - 1)
        case let .pair(lhs, .regular):
            return [.left] + lhs.findPathToPairAtDepth(depth - 1)
        case let .pair(lhs, rhs):
            let lhsPair = lhs.findPathToPairAtDepth(depth - 1)
            if lhsPair.count >= depth {
                return [.left] + lhsPair
            } else {
                return [.right] + rhs.findPathToPairAtDepth(depth - 1)
            }
        default:
            fatalError()
        }
    }

    private mutating func explodeAtPath(_ path: [ExplodePathComponent]) -> Bool {
        guard case let .root(.pair(.regular(lhsRoot), .regular(rhsRoot))) = path.last else { return false }

        replaceItemAtPath(path, withValue: .regular(0))

        if let rhsInverted = invertPath(path, fromFirst: .right) {
            add(lhsRoot, atPath: rhsInverted, from: .left)
        }
        if let lhsInverted = invertPath(path, fromFirst: .left) {
            add(rhsRoot, atPath: lhsInverted, from: .right)
        }

        return true
    }

    private mutating func replaceItemAtPath(_ path: [ExplodePathComponent], withValue value: SnailfishNumber) {
        if path.count == 1 {
            self = value
            return
        }
        guard case var .pair(lhs, rhs) = self else { return }

        let nextSubpath = Array(path[path.index(after: path.startIndex)...])

        switch path.first {
        case .left:
            lhs.replaceItemAtPath(nextSubpath, withValue: value)
            self = .pair(lhs, rhs)
        case .right:
            rhs.replaceItemAtPath(nextSubpath, withValue: value)
            self = .pair(lhs, rhs)
        default:
            break
        }
    }

    private func invertPath(_ path: [ExplodePathComponent], fromFirst from: ExplodePathComponent) -> [ExplodePathComponent]? {
        guard let fromIndex = path.lastIndex(of: from) else { return nil }

        var path = path
        for index in fromIndex..<path.endIndex {
            path[index] = path[index].inverted
        }
        return path
    }

    private mutating func add(_ value: Int, atPath path: [ExplodePathComponent], from: ExplodePathComponent) {
        if case let .regular(selfValue) = self {
            self = .regular(selfValue + value)
            return
        }

        guard case var .pair(lhs, rhs) = self else { return }

        let nextSubpathStartIndex = path.index(after: path.startIndex)
        guard nextSubpathStartIndex <= path.endIndex else { return }
        let nextSubpath = Array(path[nextSubpathStartIndex...])

        switch path.first {
        case .left:
            lhs.add(value, atPath: nextSubpath, from: from)
            self = .pair(lhs, rhs)
        case .right:
            rhs.add(value, atPath: nextSubpath, from: from)
            self = .pair(lhs, rhs)
        default:
            switch from {
            case .left:
                rhs.add(value, atPath: [.left], from: .left)
                self = .pair(lhs, rhs)
            case .right:
                lhs.add(value, atPath: [.right], from: .right)
                self = .pair(lhs, rhs)
            case .root:
                break
            }
        }
    }

    private mutating func split() -> Bool {
        if case let .regular(value) = self, value >= 10 {
            self = .pair(
                .regular(value / 2),
                .regular((value + 1) / 2)
            )
            return true
        } else {
            guard case var .pair(lhs, rhs) = self else { return false }

            if lhs.split() {
                self = .pair(lhs, rhs)
                return true
            }

            let rhsSplit = rhs.split()
            self = .pair(lhs, rhs)
            return rhsSplit
        }
    }
}

enum ExplodePathComponent: Equatable {
    case root(_ number: SnailfishNumber)
    case left
    case right

    var inverted: ExplodePathComponent {
        switch self {
        case .left: return .right
        case .right: return .left
        case .root: return self
        }
    }
}

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)
    .map(SnailfishNumber.init)

// MARK: - Part 1

let finalSumMagnitude = input
    .dropFirst()
    .reduce(input.first!) { result, number in
        (result + number).reduced()
    }
    .magnitude

print("-- Part 1")
print("Final sum magnitude: \(finalSumMagnitude)")

// MARK: - Part 2

let maxPairSumMagnitude = input
    .combinations(ofCount: 2)
    .map { combination -> Int in
        let magnitude = (combination[0] + combination[1])
            .reduced()
            .magnitude
        let inverseMagnitude = (combination[1] + combination[0])
            .reduced()
            .magnitude
        return max(magnitude, inverseMagnitude)
    }
    .max()!

print("-- Part 2")
print("Maximum magnitude of all pair sums: \(maxPairSumMagnitude)")


// MARK: - Debug

extension SnailfishNumber: CustomStringConvertible {
    var description: String {
        switch self {
        case let .regular(value):
            return "\(value)"
        case let .pair(lhs, rhs):
            return "[\(lhs.description),\(rhs.description)]"
        }
    }
}
