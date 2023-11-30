import ArgumentParser
import Foundation

@main
struct AdventOfCode: ParsableCommand {
    @Argument(help: "Run the solution for the provided day(s)")
    var days: [Int] = []

    func run() throws {
        let daysToRun: [Day]
        if days.isEmpty {
            print("No days specified. Running solution for all days.")
            daysToRun = allDays
        } else {
            daysToRun = days.map {
                allDays[$0 - 1]
            }
        }

        for day in daysToRun {
            try runDay(day)
        }
    }

    private func runDay<D: Solution>(_ day: D.Type) throws {
        let input = try getInputString(day: day.day)
        let solution = day.init(input: input)

        print("Day \(day.day)")
        print("\tPart One: \(solution.runPartOne())")
        print("\tPart Two: \(solution.runPartTwo())")
        print("\n")
    }

    private func getInputString(day: Int) throws -> String {
        guard let url = Bundle.module.url(forResource: "Day\(day.formatted(.number.precision(.integerLength(2))))", withExtension: "txt") else {
            fatalError("input data missing")
        }

        return try String(contentsOf: url)
    }
}

typealias Day = any (Solution.Type)
fileprivate let allDays: [Day] = [
    Day01.self,
    Day02.self,
    Day03.self,
    Day04.self,
    Day05.self,
    Day06.self,
    Day07.self,
    Day08.self,
    Day09.self,
    Day10.self,
    Day11.self,
    Day12.self,
    Day13.self,
    Day14.self,
    Day15.self,
    Day16.self,
    Day17.self,
    Day18.self,
    Day19.self,
    Day20.self,
    Day21.self,
    Day22.self,
    Day23.self,
    Day24.self,
    Day25.self,
]
