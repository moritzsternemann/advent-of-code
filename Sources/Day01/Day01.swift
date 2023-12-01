struct Day01: Solution {
    static let day = 01

    private let spelledOutNumbers: [String: Int] = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9,
    ]

    private let lines: [Substring]

    init(input: String) {
        self.lines = input.split(separator: "\n")
    }

    func runPartOne() -> Int {
        lines
            .map { line in
                line.compactMap { Int("\($0)") }
            }
            .compactMap { digits -> Int? in
                guard let first = digits.first,
                      let last = digits.last
                else { return nil }

                return first * 10 + last
            }
            .reduce(0, +)
    }

    func runPartTwo() -> Int {
        let possibleStrings = spelledOutNumbers.keys + spelledOutNumbers.values.map { "\($0)" }

        return lines
            .compactMap { line -> Int? in
                guard let firstNumberRange = singleRange(of: possibleStrings, in: line, by: { $0.lowerBound < $1.lowerBound }),
                      let lastNumberRange = singleRange(of: possibleStrings, in: line, by: { $0.upperBound > $1.upperBound })
                else { return nil }

                let firstNumberString = String(line[firstNumberRange])
                let lastNumberString = String(line[lastNumberRange])

                guard let firstNumber = spelledOutNumbers[firstNumberString] ?? Int(firstNumberString),
                      let lastNumber = spelledOutNumbers[lastNumberString] ?? Int(lastNumberString)
                else { return nil }

                return firstNumber * 10 + lastNumber
            }
            .reduce(0, +)
    }

    private func singleRange(of collection: [String], in str: Substring, by cmp: (Range<Substring.Index>, Range<Substring.Index>) -> Bool) -> Range<Substring.Index>? {
        collection.flatMap({ str.ranges(of: $0) }).min(by: cmp)
    }
}
