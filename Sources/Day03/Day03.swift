struct Day03: Solution {
    static let day = 03

    private let input: String
    private let potentialPartNumbers: [Range<String.Index>]
    private let lineLength: Int

    init(input: String) {
        self.input = input

        self.potentialPartNumbers = input.ranges(of: #/(\d+)/#)
        guard let firstLineBreakIndex = input.firstIndex(of: "\n") else { fatalError() }
        self.lineLength = input.distance(from: input.startIndex, to: firstLineBreakIndex) + 1 // +1 for \n
    }

    func runPartOne() -> Int {
        var partNumbers: [Int] = []
        forEachAdjacentTo(potentialPartNumbers) { char, index, potentialPartNumber in
            if char != "." && !char.isNumber {
                guard let partNumber = Int(input[potentialPartNumber]) else { fatalError() }

                partNumbers.append(partNumber)
                return false
            }
            return true
        }

        return partNumbers.sum()
    }

    func runPartTwo() -> Int {
        var gearAdjacentPartNumbers: [String.Index: [Int]] = [:]
        forEachAdjacentTo(potentialPartNumbers) { char, index, potentialPartNumber in
            if char == "*" {
                guard let partNumber = Int(input[potentialPartNumber]) else { fatalError() }

                gearAdjacentPartNumbers[index, default: []].append(partNumber)
                return false
            }
            return true
        }

        return gearAdjacentPartNumbers.values
            .filter { $0.count == 2 }
            .map { $0[0] * $0[1] }
            .sum()
    }

    private func forEachAdjacentTo(_ potentialPartNumbers: [Range<String.Index>], body: (Character, String.Index, Range<String.Index>) -> Bool) {
        for potentialPartNumber in potentialPartNumbers {
            for adjacentIndex in adjacentFields(to: potentialPartNumber, of: input, lineLength: lineLength) {
                if !body(input[adjacentIndex], adjacentIndex, potentialPartNumber) {
                    break
                }
            }
        }
    }

    private func adjacentFields(to range: Range<String.Index>, of string: String, lineLength: Int) -> [String.Index] {
        let lastIndex = string.index(before: string.endIndex) // index of the last character

        // left
        let leftIndex = string.index(before: range.lowerBound, limitedBy: string.startIndex)

        // right
        let rightIndex = string.index(range.upperBound, offsetBy: 0, limitedBy: lastIndex)

        // top-left
        let topLeftIndex = leftIndex.flatMap { string.index($0, offsetBy: -lineLength, limitedBy: string.startIndex) }

        // top-right
        let topRightIndex = rightIndex.flatMap { string.index($0, offsetBy: -lineLength, limitedBy: string.startIndex) }

        // bottom-left
        let bottomLeftIndex = leftIndex.flatMap { string.index($0, offsetBy: lineLength, limitedBy: lastIndex) }

        // bottom-right
        let bottomRightIndex = rightIndex.flatMap { string.index($0, offsetBy: lineLength, limitedBy: lastIndex) }

        // all above
        let topIndices = offsetRange(range, of: string, by: -lineLength)
            .map { allIndicies(in: $0, of: string) } ?? []

        // all below
        let bottomIndices = offsetRange(range, of: string, by: lineLength)
            .map { allIndicies(in: $0, of: string) } ?? []

        return ([leftIndex, rightIndex, topLeftIndex, topRightIndex, bottomLeftIndex, bottomRightIndex] + topIndices + bottomIndices)
            .compactMap { $0 }
            .filter { string[$0] != "\n" }
    }

    private func offsetRange(_ range: Range<String.Index>, of string: String, by offset: Int) -> Range<String.Index>? {
        let limit = offset < 0 ? string.startIndex : string.index(before: string.endIndex)
        guard let newLower = string.index(range.lowerBound, offsetBy: offset, limitedBy: limit),
              let newUpper = string.index(range.upperBound, offsetBy: offset, limitedBy: limit)
        else { return nil }

        return newLower..<newUpper
    }

    private func allIndicies(in range: Range<String.Index>, of string: String) -> [String.Index] {
        var result: [String.Index] = []
        var index = range.lowerBound
        repeat {
            result.append(index)
            index = string.index(after: index)
        } while index < range.upperBound
        return result
    }
}
