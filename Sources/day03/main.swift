//
//  main.swift
//  day03
//
//  Created by Moritz Sternemann on 03.12.21.
//

import Common
import Foundation

let numbers = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)

func mostCommonCharacter(in numbers: [String], at index: Int) -> Character? {
    var countZeros = 0
    var countOnes = 0
    for number in numbers {
        let character = number[index]
        if character == "0" {
            countZeros += 1
        } else if character == "1" {
            countOnes += 1
        }
    }
    return countOnes == countZeros ? nil
        : countOnes > countZeros ? "1" : "0"
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

// MARK: - Part 1

var gammaChars: [Character] = []
var epsilonChars: [Character] = []
for index in 0..<numbers[0].count {
    let character = mostCommonCharacter(in: numbers, at: index)
    gammaChars.append(character == "1" ? "1" : "0")
    epsilonChars.append(character == "1" ? "0" : "1")
}

let gammaString = String(gammaChars)
let gamma = Int(gammaString, radix: 2)!
let epsilonString = String(epsilonChars)
let epsilon = Int(epsilonString, radix: 2)!

print("-- Part 1")
print("Gamma: \(gamma) [\(String(gammaChars))], Epsilon: \(epsilon) [\(epsilonString)], Product: \(gamma * epsilon)")

// MARK: - Part 2

enum Commonality {
    case most, least
}

func generatorRating(of numbers: [String], commonality: Commonality) -> String {
    var numbers = numbers
    for index in 0..<numbers[0].count {
        let character = mostCommonCharacter(in: numbers, at: index) ?? "1"
        numbers.removeAll(where: {
            switch commonality {
            case .most:
                return $0[index] != character
            case .least:
                return $0[index] == character
            }
        })
        
        if numbers.count == 1 {
            return numbers[0]
        }
    }
    fatalError()
}

let oxygenString = generatorRating(of: numbers, commonality: .most)
let oxygenRating = Int(oxygenString, radix: 2)!
let co2String = generatorRating(of: numbers, commonality: .least)
let co2Rating = Int(co2String, radix: 2)!

print("-- Part 2")
print("Oxygen: \(oxygenRating) [\(oxygenString)], CO2: \(co2Rating) [\(co2String)], Product: \(oxygenRating * co2Rating)")
