import Algorithms

struct Day05: Solution {
    static let day = 05

    private let seeds: [Int]
    private let maps: [Map]

    init(input: String) {
        guard let firstNewlineIndex = input.firstIndex(of: "\n") else { fatalError() }
        let seedsLine = input[..<firstNewlineIndex].dropFirst(7) // drop "seeds: "
        self.seeds = seedsLine.split(separator: " ").compactMap({ Int($0) })

        self.maps = input[firstNewlineIndex...]
            .split(separator: "\n\n")
            .map { Map($0) }
    }

    func runPartOne() -> Int {
        seeds.map { maps.resolve(seedNumber: $0) }
            .min() ?? Int.max
    }

    func runPartTwo() -> Int {
        assert(seeds.count % 2 == 0)

        let seeds = seeds.chunks(ofCount: 2)
            .map { chunk in
                let start = chunk[chunk.startIndex]
                let length = chunk[chunk.startIndex + 1]
                return Range(lower: start, upper: start + length - 1)
            }

        return maps.resolve(seedNumbers: seeds)
            .min(by: { $0.lower < $1.lower })?.lower ?? Int.max
    }
}

extension Day05 {
    struct Range {
        var lower: Int
        var upper: Int
        var delta: Int

        init(lower: Int, upper: Int, delta: Int = 0) {
            self.lower = lower
            self.upper = upper
            self.delta = delta
        }

        init(_ string: Substring) {
            guard let match = string.wholeMatch(of: #/(\d+) (\d+) (\d+)/#),
                  let dst = Int(match.output.1),
                  let src = Int(match.output.2),
                  let len = Int(match.output.3)
            else { fatalError() }

            self.init(lower: src, upper: src + len - 1, delta: dst - src)
        }

        func contains(_ value: Int) -> Bool {
            value >= lower && value <= upper
        }

        var isValid: Bool {
            lower <= upper
        }
    }

    struct Map {
        var mappings: [Range]

        init(_ string: Substring) {
            self.mappings = string.split(separator: "\n")
                .dropFirst()
                .map { Range($0) }
                .sorted { $0.lower < $1.lower }
        }

        func resolve(_ source: Int) -> Int {
            guard let range = mappings.first(where: { $0.contains(source) }) else { return source }
            return source + range.delta
        }

        func resolve(_ sources: [Range]) -> [Range] {
            var result: [Range] = []

            for source in sources {
                var source = source
                for mapping in mappings {
                    if source.lower < mapping.lower {
                        result.append(Range(lower: source.lower, upper: min(source.upper, mapping.lower - 1)))
                        source = Range(lower: mapping.lower, upper: source.upper)
                        if !source.isValid {
                            break
                        }
                    }
                    if source.lower <= mapping.upper {
                        result.append(Range(lower: source.lower + mapping.delta, upper: min(source.upper, mapping.upper) + mapping.delta))
                        source = Range(lower: mapping.upper + 1, upper: source.upper)
                        if !source.isValid {
                            break
                        }
                    }
                }
                if source.isValid {
                    result.append(source)
                }
            }

            return result
        }
    }
}

extension Collection where Element == Day05.Map {
    func resolve(seedNumber: Int) -> Int {
        reduce(seedNumber) { src, map in
            map.resolve(src)
        }
    }

    func resolve(seedNumbers: [Day05.Range]) -> [Day05.Range] {
        reduce(seedNumbers) { ranges, map in
            map.resolve(ranges)
        }
    }
}
