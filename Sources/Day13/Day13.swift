import Algorithms

struct Day13: Solution {
    static let day = 13

    private let patterns: [Substring]

    init(input: String) {
        self.patterns = input.split(separator: "\n\n")
    }

    func runPartOne() -> Int {
        solve(desiredDifferenceCount: 0)
    }

    func runPartTwo() -> Int {
        solve(desiredDifferenceCount: 1)
    }

    private func solve(desiredDifferenceCount: Int) -> Int {
        patterns
            .map { pattern in
                let rowMap = pattern.split(separator: "\n")
                    .map { row in
                        row.map { $0 }
                    }
                let columnMap = rowMap.transposed()

                return findMirror(in: columnMap, desiredDifferenceCount: desiredDifferenceCount)
                    + findMirror(in: rowMap, desiredDifferenceCount: desiredDifferenceCount) * 100
            }
            .sum()
    }

    private func findMirror(in pattern: [[Character]], desiredDifferenceCount: Int) -> Int {
        let patternKeyRange = 0..<pattern.count
        
        return pattern.enumerated()
            .adjacentPairs()
            .filter { adjacent -> Bool in
                // Number of different characters between both pair elements
                let adjacentDifferenceCount = zip(adjacent.0.element, adjacent.1.element)
                    .filter { $0.0 != $0.1 }
                    .count

                // Iterate outwards (- and +) from the current adjacent pair and
                // filter out elements where either before or after are outside
                // the range of all elements
                let potentialMirrorOutwardPairs = (0..<adjacent.0.offset)
                    .map { (adjacent.0.offset - $0 - 1, adjacent.1.offset + $0 + 1) }
                    .filter { patternKeyRange.contains($0.0) && patternKeyRange.contains($0.1) }

                // Sum of the number of different characters between each of the outwards pairs
                let outwardPairsDifferenceCount = potentialMirrorOutwardPairs
                    .flatMap { zip(pattern[$0.0], pattern[$0.1]) }
                    .filter { $0.0 != $0.1 }
                    .count

                return adjacentDifferenceCount + outwardPairsDifferenceCount == desiredDifferenceCount
            }
            .map { $0.1.offset }
            .max() ?? 0
    }
}
