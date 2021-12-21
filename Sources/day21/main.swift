//
//  main.swift
//  day21
//
//  Created by Moritz Sternemann on 21.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")

let player1Start = Int(input[0].suffix(1))!
let player2Start = Int(input[1].suffix(1))!

var player1Score = 0
var player2Score = 0

var player1CurrentField = player1Start
var player2CurrentField = player2Start

func walkField(from: Int, by: Int) -> Int {
    (from + by - 1) % 10 + 1
}

// MARK: - Part 1

struct DeterministicDie {
    private(set) var rollCount: Int = 0
    private var lastRoll: Int = 0

    mutating func roll() -> Int {
        if lastRoll == 100 {
            lastRoll = 1
        } else {
            lastRoll += 1
        }

        rollCount += 1

        return lastRoll
    }

    mutating func rollThreeTimes() -> Int {
        (0..<3)
            .map { _ in roll() }
            .reduce(0, +)
    }
}

let part1ScoreToWin = 1000

var deterministicDie = DeterministicDie()

while true {
    // Player 1
    let player1Roll = deterministicDie.rollThreeTimes()
    player1CurrentField = walkField(from: player1CurrentField, by: player1Roll)
    player1Score += player1CurrentField

    if player1Score >= part1ScoreToWin {
        break
    }

    // Player 2
    let player2Roll = deterministicDie.rollThreeTimes()
    player2CurrentField = walkField(from: player2CurrentField, by: player2Roll)
    player2Score += player2CurrentField

    if player2Score >= part1ScoreToWin {
        break
    }
}

let part1 = deterministicDie.rollCount * min(player1Score, player2Score)

print("-- Part 1")
print("Roll count * losing player score: \(part1)")

// MARK: - Part 2

struct DiracDie {
    let rolls: [Int: Int]

    init() {
        let singleRoll = 1...3

        rolls = singleRoll
            .flatMap { first in
                singleRoll
                    .flatMap { second in
                        singleRoll
                            .map { first + second + $0 }
                    }
            }
            .reduce(into: [:]) { counts, roll in
                counts[roll, default: 0] += 1
            }
    }
}

struct Move: Hashable {
    var turn: Int
    var positionP1: Int
    var positionP2: Int
    var scoreP1: Int
    var scoreP2: Int

    init(
        turn: Int = 0,
        positionP1: Int,
        positionP2: Int,
        scoreP1: Int = 0,
        scoreP2: Int = 0
    ) {
        self.turn = turn
        self.positionP1 = positionP1
        self.positionP2 = positionP2
        self.scoreP1 = scoreP1
        self.scoreP2 = scoreP2
    }
}

let part2ScoreToWin = 21
let diracDie = DiracDie()

var moveCache: [Move: (p1: Int, p2: Int)] = [:]

func recurseWinCounts(from currentMove: Move) -> (p1: Int, p2: Int) {
    if currentMove.scoreP1 >= part2ScoreToWin {
        return (currentMove.turn % 2, (currentMove.turn + 1) % 2)
    }
    if currentMove.scoreP2 >= part2ScoreToWin {
        return ((currentMove.turn + 1) % 2, currentMove.turn % 2)
    }

    return diracDie.rolls
        .map { roll, count -> (p1: Int, p2: Int) in
            let newPlayerPosition = walkField(from: currentMove.positionP1, by: roll)
            let nextMove = Move(
                turn: (currentMove.turn + 1) % 2,
                positionP1: currentMove.positionP2,
                positionP2: newPlayerPosition,
                scoreP1: currentMove.scoreP2,
                scoreP2: currentMove.scoreP1 + newPlayerPosition
            )

            let winCounts = moveCache[nextMove] ?? recurseWinCounts(from: nextMove)
            moveCache[nextMove] = (winCounts.p1, winCounts.p2)

            // use roll count as weight
            return (winCounts.p1 * count, winCounts.p2 * count)
        }
        .reduce((0, 0)) { totalWinCounts, winCounts -> (p1: Int, p2: Int) in
            (totalWinCounts.p1 + winCounts.p1, totalWinCounts.p2 + winCounts.p2)
        }
}

let winCounts = recurseWinCounts(from: .init(positionP1: player1Start, positionP2: player2Start))
let maxWinCount = max(winCounts.p1, winCounts.p2)

print("-- Part 2")
print("Maximum win count: \(maxWinCount)")
