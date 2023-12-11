import Algorithms

struct Day09: Solution {
    static let day = 09

    private let histories: [MeasurementHistory]

    init(input: String) {
        self.histories = input.split(separator: "\n")
            .map { MeasurementHistory($0) }
    }

    func runPartOne() -> Int {
        histories
            .map { $0.extrapolateForwards() }
            .sum()
    }

    func runPartTwo() -> Int {
        histories
            .map { $0.extrapolateBackwards() }
            .sum()
    }
}

extension Day09 {
    struct MeasurementHistory {
        let measurements: [Int]

        init(_ string: Substring) {
            self.measurements = string.split(separator: " ").compactMap { Int($0) }
        }

        func extrapolateForwards() -> Int {
            extrapolate(at: \.last)
        }

        func extrapolateBackwards() -> Int {
            extrapolate(at: \.first)
        }

        private func extrapolate(at edge: KeyPath<[Int], Int?>) -> Int {
            assert(edge == \.first || edge == \.last, "only .first and .last are supported")

            var steps = calculateDifferences()

            for (index, step) in steps.reversed().enumerated() {
                guard let stepEdgeValue = step[keyPath: edge] else { fatalError("empty step") }
                let previousStepEdgeValue = steps[safe: steps.count - index]?[keyPath: edge] ?? 0

                if edge == \.first {
                    steps[steps.count - index - 1].insert(stepEdgeValue - previousStepEdgeValue, at: 0)
                } else if edge == \.last {
                    steps[steps.count - index - 1].append(stepEdgeValue + previousStepEdgeValue)
                } else {
                    fatalError()
                }
            }

            guard let newMeasuerment = steps.first?[keyPath: edge] else { fatalError() }
            return newMeasuerment
        }

        private func calculateDifferences() -> [[Int]] {
            var steps: [[Int]] = [measurements]
            var differences: [Int] = measurements
            repeat {
                differences = differences.adjacentPairs().map { $1 - $0 }
                steps.append(differences)
            } while !differences.allSatisfy({ $0 == 0 })

            return steps
        }

        private func printSteps(_ steps: [[Int]]) {
            let separator = String(repeating: " ", count: steps.count)
            for (index, step) in steps.enumerated() {
                let leading = String(repeating: " ", count: index * 2)
                print(leading + step.map({ "\($0)" }).joined(separator: separator))
            }
        }
    }
}
