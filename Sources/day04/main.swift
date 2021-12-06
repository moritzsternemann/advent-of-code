//
//  main.swift
//  day04
//
//  Created by Moritz Sternemann on 04.12.21.
//

import Collections
import Common
import Foundation

var lines = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)

let draw = lines.removeFirst().split(separator: ",").compactMap { Int($0) }

typealias BoardEntry = (number: Int, marked: Bool)
var boards: [[BoardEntry]] = []
var currentBoard: [BoardEntry] = []
for line in lines {
    if currentBoard.count == 25 {
        boards.append(currentBoard)
        currentBoard = []
    }
    
    let scanner = Scanner(string: String(line))
    scanner.charactersToBeSkipped = .whitespaces
    
    var n = -1
    while scanner.scanInt(&n) {
        if n == -1 { break }
        currentBoard.append((n, false))
    }
}
boards.append(currentBoard)

// MARK: - Part 1

func mark(number: Int, in boards: [[BoardEntry]]) -> [[BoardEntry]] {
    return boards
        .map { board in
            board.map { entry in
                if entry.number == number {
                    return (entry.number, true)
                }
                return entry
            }
        }
}

func checkWin(in boards: [[BoardEntry]]) -> (index: Int, board: [BoardEntry])? {
    for (index, board) in boards.enumerated() {
        if checkWin(in: board) {
            return (index, board)
        }
    }
    
    return nil
}

func checkWin(in board: [BoardEntry]) -> Bool {
    // check row
    for row in 0..<5 {
        let range = (row * 5)..<(row * 5 + 5)
        if board[range].allSatisfy(\.marked) {
            return true
        }
    }
    
    // check columns
    for column in 0..<5 {
        let win = stride(from: column, to: board.count, by: 5)
            .map { board[$0] }
            .allSatisfy(\.marked)
        if win {
            return true
        }
    }
    
    return false
}

var markedBoards = boards
var winners = OrderedDictionary<Int, [BoardEntry]>()
for number in draw {
    // Mark number in all boards
    markedBoards = mark(number: number, in: markedBoards)
    
    // Check all boards for winners
    while let winner = checkWin(in: markedBoards) {
        if winners[number] == nil {
            winners[number] = winner.board
        }
        markedBoards.remove(at: winner.index)
    }
    
    // Break if all boards have a winner
    if winners.count == markedBoards.count {
        break
    }
}

// MARK: - Part 1

let firstWinner = winners.values[0]
let firstWinnerNumber = winners.keys[0]
let firstWinnerSum = firstWinner
    .filter { !$0.marked }
    .map(\.number)
    .reduce(0, +)
print("-- Part 1")
print("Number: \(firstWinnerNumber), Board sum: \(firstWinnerSum), Product: \(firstWinnerNumber * firstWinnerSum)")

// MARK: - Part 2

let lastWinner = winners.values[winners.values.count - 1]
let lastWinnerNumber = winners.keys[winners.keys.count - 1]
let lastWinnerSum = lastWinner
    .filter { !$0.marked }
    .map(\.number)
    .reduce(0, +)
print("-- Part 2")
print("Number: \(lastWinnerNumber), Board sum: \(lastWinnerSum), Product: \(lastWinnerNumber * lastWinnerSum)")
