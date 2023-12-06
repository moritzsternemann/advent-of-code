struct Day06: Solution {
    static let day = 06

    private let races: [Race]

    init(input: String) {
        let lines = input.split(separator: "\n")
        let times = Self.numbers(in: lines[0])
        let distances = Self.numbers(in: lines[1])
        self.races = zip(times, distances)
            .map { Race(timeAllowed: $0.0, distanceRecord: $0.1) }
    }

    private static func numbers(in line: Substring) -> [Int] {
        line.split(separator: ":")[1].split(separator: "  ").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }

    func runPartOne() -> Int {
        races
            .map { race in
                stride(from: 1, to: race.timeAllowed, by: 1)
                    .map { pressDuration in
                        // pressDuration is equal to the speed
                        let remainingTime = race.timeAllowed - pressDuration
                        let distanceTraveled = pressDuration * remainingTime
                        return distanceTraveled
                    }
                    .filter { $0 > race.distanceRecord }
                    .count
            }
            .product()
    }

    func runPartTwo() -> Int {
        let combinedRaceProps = races.reduce(("", "")) { acc, race in
            (acc.0 + "\(race.timeAllowed)", acc.1 + "\(race.distanceRecord)")
        }
        guard let timeAllowed = Int(combinedRaceProps.0),
              let distanceRecord = Int(combinedRaceProps.1)
        else { fatalError() }

        let (x1, x2) = solveQuadraticEquation(a: -1, b: timeAllowed, c: -distanceRecord)
        let max = Int(x2.rounded(.up)) - 1
        let min = Int(x1.rounded(.down)) + 1
        return max - min + 1
    }

    private func solveQuadraticEquation(a: Int, b: Int, c: Int) -> (x1: Double, x2: Double) {
        let a = Double(a), b = Double(b), c = Double(c)

        let sqrt = ((b * b) - 4 * a * c).squareRoot()
        let x1 = (-b - sqrt) / (2 * a)
        let x2 = (-b + sqrt) / (2 * a)
        return (
            min(x1, x2),
            max(x1, x2)
        )
    }
}

extension Day06 {
    struct Race {
        var timeAllowed: Int
        var distanceRecord: Int
    }
}
