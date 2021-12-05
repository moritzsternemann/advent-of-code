import Collections
import Foundation

let inputURL = Bundle.module.url(forResource: "input", withExtension: "txt")!
let input = try Data(contentsOf: inputURL)
var lines = String(decoding: input, as: UTF8.self)
    .split(separator: "\n")
    .map(String.init)

//var lines = """
//7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
//
//22 13 17 11  0
// 8  2 23  4 24
//21  9 14 16  7
// 6 10  3 18  5
// 1 12 20 15 19
//
// 3 15  0  2 22
// 9 18 13 17  5
//19  8  7 25 23
//20 11 10 24  4
//14 21 16 12  6
//
//14 21 17 24  4
//10 16 15  9 19
//18  8 23 26 20
//22 11 13  6  5
// 2  0 12  3  7
//""".split(separator: "\n").map(String.init)

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
