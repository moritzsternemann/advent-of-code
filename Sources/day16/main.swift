//
//  main.swift
//  day16
//
//  Created by Moritz Sternemann on 16.12.21.
//

import Common

extension String {
    mutating func removingFirst(_ k: Int) -> Substring {
        let prefix = self.prefix(k)
        removeFirst(k)
        return prefix
    }
}

struct Packet {
    struct Header {
        var version: Int
        var typeId: Int
    }
    
    enum Payload {
        case literal(_ number: Int)
        case sum(_ childPackets: [Packet])
        case product(_ childPackets: [Packet])
        case minimum(_ childPackets: [Packet])
        case maximum(_ childPackets: [Packet])
        case greaterThan(_ childPackets: [Packet])
        case lessThan(_ childPackets: [Packet])
        case equals(_ childPackets: [Packet])
        
        static func operation(with type: Int, childPackets: [Packet]) -> Payload {
            switch type {
            case 0: return .sum(childPackets)
            case 1: return .product(childPackets)
            case 2: return .minimum(childPackets)
            case 3: return .maximum(childPackets)
            case 5: return .greaterThan(childPackets)
            case 6: return .lessThan(childPackets)
            case 7: return .equals(childPackets)
            default: fatalError()
            }
        }
    }
    
    var header: Header
    var payload: Payload
}

func parsePacket(from bits: inout String) -> Packet {
    let typeId = Int(bits.dropFirst(3).prefix(3), radix: 2)!
    if typeId == 4 {
        return parseLiteralPacket(from: &bits)
    } else {
        return parseOperatorPacket(from: &bits)
    }
}

func parseLiteralPacket(from bits: inout String) -> Packet {
    let version = Int(bits.removingFirst(3), radix: 2)!
    let typeId = Int(bits.removingFirst(3), radix: 2)!

    var groups: [Substring] = []
    while bits.hasPrefix("1") {
        groups.append(bits.removingFirst(5))
    }

    // last group starting with a "0"
    groups.append(bits.removingFirst(5))

    let number = Int(groups.map({ $0.dropFirst() }).joined(), radix: 2)!

    return Packet(
        header: .init(version: version, typeId: typeId),
        payload: .literal(number)
    )
}

func parseOperatorPacket(from bits: inout String) -> Packet {
    let version = Int(bits.removingFirst(3), radix: 2)!
    let typeId = Int(bits.removingFirst(3), radix: 2)!

    var childPackets: [Packet] = []
    let childPacketsLengthType = bits.removeFirst()
    if childPacketsLengthType == "0" {
        let childPacketsBitCount = Int(bits.removingFirst(15), radix: 2)!
        let remainingLength = bits.count
        while (remainingLength - bits.count) < childPacketsBitCount {
            childPackets.append(parsePacket(from: &bits))
        }
    } else if childPacketsLengthType == "1" {
        let subpacketCount = Int(bits.removingFirst(11), radix: 2)!

        for _ in 0..<subpacketCount {
            childPackets.append(parsePacket(from: &bits))
        }
    } else {
        fatalError()
    }

    return Packet(
        header: .init(version: version, typeId: typeId),
        payload: .operation(with: typeId, childPackets: childPackets)
    )
}

var bits = try Input.loadInput(in: .module)
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .map { String(Int(String($0), radix: 16)!, radix: 2).leftPadding(toLength: 4, withPad: "0")}
    .joined()

let rootPacket = parsePacket(from: &bits)

// MARK: - Part 1

extension Packet {
    var versionSum: Int {
        header.version + payload.versionSum
    }
}

extension Packet.Payload {
    var versionSum: Int {
        switch self {
        case .literal:
            return 0
        case .sum(let c), .product(let c), .minimum(let c), .maximum(let c), .greaterThan(let c), .lessThan(let c), .equals(let c):
            return c.map(\.versionSum).reduce(0, +)
        }
    }
}

print("-- Part 1")
print("Sum of version numbers: \(rootPacket.versionSum)")

// MARK: - Part 2

extension Packet {
    var evaluationResult: Int {
        payload.evaluationResult
    }
}

extension Packet.Payload {
    var evaluationResult: Int {
        switch self {
        case .literal(let number):
            return number
        case .sum(let childPackets):
            return childPackets.map(\.evaluationResult).reduce(0, +)
        case .product(let childPackets):
            return childPackets.reduce(1) { $0 * $1.evaluationResult }
        case .minimum(let childPackets):
            return childPackets.map(\.evaluationResult).min()!
        case .maximum(let childPackets):
            return childPackets.map(\.evaluationResult).max()!
        case .greaterThan(let childPackets):
            let lhs = childPackets[0].evaluationResult
            let rhs = childPackets[1].evaluationResult
            return lhs > rhs ? 1 : 0
        case .lessThan(let childPackets):
            let lhs = childPackets[0].evaluationResult
            let rhs = childPackets[1].evaluationResult
            return lhs < rhs ? 1 : 0
        case .equals(let childPackets):
            let lhs = childPackets[0].evaluationResult
            let rhs = childPackets[1].evaluationResult
            return lhs == rhs ? 1 : 0
        }
    }
}

print("-- Part 2")
print("Result of evaluation: \(rootPacket.evaluationResult)")

// MARK: - Debug

extension Packet: CustomStringConvertible {
    var description: String {
        "[\(header)(\(payload)]"
    }
}

extension Packet.Header: CustomStringConvertible {
    var description: String {
        "version=\(version) typeId=\(typeId)"
    }
}

extension Packet.Payload: CustomStringConvertible {
    var description: String {
        switch self {
        case .literal(let number):
            return "number=\(number)"
        case .sum(let childPackets):
            return "SUM(\(childPackets.map(\.description).joined(separator: ", ")))"
        case .product(let childPackets):
            return "PROD(\(childPackets.map(\.description).joined(separator: ", ")))"
        case .minimum(let childPackets):
            return "MIN(\(childPackets.map(\.description).joined(separator: ", ")))"
        case .maximum(let childPackets):
            return "MAX(\(childPackets.map(\.description).joined(separator: ", ")))"
        case .greaterThan(let childPackets):
            return "GT(\(childPackets.map(\.description).joined(separator: ", ")))"
        case .lessThan(let childPackets):
            return "LT(\(childPackets.map(\.description).joined(separator: ", ")))"
        case .equals(let childPackets):
            return "EQ(\(childPackets.map(\.description).joined(separator: ", ")))"
        }
    }
}
