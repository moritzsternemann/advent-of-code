struct Day12: Solution {
    static let day = 12

    private let springs: [(Substring, [Int])]

    init(input: String) {
        self.springs = input.split(separator: "\n")
            .map { line in
                let parts = line.split(separator: " ")
                let sizes = parts[1].split(separator: ",").compactMap { Int($0) }
                return (parts[0], sizes)
            }
    }

    func runPartOne() -> Int {
        return springs
            .map {
                // Append . as terminator
                memoizedCountSolutions(CountSolutionsParams(str: $0.0 + ".", groupCounts: $0.1))
            }
            .sum()
    }

    func runPartTwo() -> Int {
        return springs
            .map { str, counts in
                let repeatedStrings = Array(repeating: str, count: 5).joined(separator: "?")
                let groupCounts = Array(repeating: counts, count: 5).flatMap({ $0 })

                // Append . as terminator
                return memoizedCountSolutions(CountSolutionsParams(
                    str: repeatedStrings[...] + ".",
                    groupCounts: groupCounts
                ))
            }
            .sum()
    }

    struct CountSolutionsParams: Hashable {
        var str: Substring
        var groupCounts: [Int]
        var currentGroupCount: Int = 0
    }

    // The memoized solution function has an internal cache from input to output values
    private let memoizedCountSolutions: (CountSolutionsParams) -> Int =
        recursiveMemoize { (countSolutions, params: CountSolutionsParams) in
            guard let nextSpring = params.str.first else {
                // All groups handled
                return params.groupCounts.isEmpty && params.currentGroupCount == 0 ? 1 : 0
            }

            var count = 0

            // Branch depending on nextSpring. If '?', recurse for both possibilities
            if nextSpring == "#" || nextSpring == "?" {
                // nextSpring is the next damaged spring in the current group
                count += countSolutions(CountSolutionsParams(
                    str: params.str.dropFirst(),
                    groupCounts: params.groupCounts,
                    currentGroupCount: params.currentGroupCount + 1
                ))
            }
            if nextSpring == "." || nextSpring == "?" {
                if params.currentGroupCount > 0 {
                    // We are at the end of the current group, remove it for the next iteration
                    if params.groupCounts.first == params.currentGroupCount {
                        count += countSolutions(CountSolutionsParams(
                            str: params.str.dropFirst(),
                            groupCounts: Array(params.groupCounts[1...])
                        ))
                    }
                } else {
                    // Currently not in a group
                    count += countSolutions(CountSolutionsParams(
                        str: params.str.dropFirst(),
                        groupCounts: params.groupCounts
                    ))
                }
            }

            return count
        }
}
