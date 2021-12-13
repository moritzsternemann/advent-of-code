//
//  main.swift
//  day13
//
//  Created by Moritz Sternemann on 13.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)

struct Dot: Hashable {
    var x: Int
    var y: Int
}

enum FoldInstruction {
    case axisX(at: Int)
    case axisY(at: Int)
}

var dots: Set<Dot> = []
var foldInstructions: [FoldInstruction] = []
for line in input {
    if line.starts(with: "fold along") {
        let parts = line
            .replacingOccurrences(of: "fold along ", with: "")
            .split(separator: "=")
        guard let value = Int(parts[1]) else { fatalError() }
        if parts[0] == "x" {
            foldInstructions.append(.axisX(at: value))
        } else if parts[0] == "y" {
            foldInstructions.append(.axisY(at: value))
        }
        continue
    }
    
    let parts = line.split(separator: ",")
    guard let x = Int(parts[0]),
          let y = Int(parts[1])
    else { fatalError() }
    
    dots.insert(Dot(x: x, y: y))
}

func printDots(_ dots: Set<Dot>) {
    guard let maxX = dots.map(\.x).max(),
          let maxY = dots.map(\.y).max()
    else { fatalError() }
    
    for y in 0...maxY {
        let line = (0...maxX)
            .reduce("") { line, x in
                if dots.contains(Dot(x: x, y: y)) {
                    return line.appending("#")
                } else {
                    return line.appending(".")
                }
            }
        print(line)
    }
}

func foldTransparentPaper(dots: Set<Dot>, with instruction: FoldInstruction) -> Set<Dot> {
    // instructions say there will never be dots an the fold lines
    dots
        .reduce(into: Set<Dot>()) { dots, dot in
            switch instruction {
            case let .axisX(at):
                dots.insert(Dot(
                    x: dot.x < at ? dot.x : at - (dot.x - at),
                    y: dot.y
                ))
            case let .axisY(at):
                dots.insert(Dot(
                    x: dot.x,
                    y: dot.y < at ? dot.y : at - (dot.y - at)
                ))
            }
        }
}

// MARK: - Part 1

let dotsAfterFirstFold = foldTransparentPaper(dots: dots, with: foldInstructions.first!)
print("-- Part 1")
print("Dot count: \(dotsAfterFirstFold.count)")

// MARK: - Part 2

let dotsAfterAllFolds = foldInstructions
    .reduce(dots) { dots, instruction in
        foldTransparentPaper(dots: dots, with: instruction)
    }
print("-- Part 2")
printDots(dotsAfterAllFolds)
