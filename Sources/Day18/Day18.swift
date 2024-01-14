import Algorithms

struct Day18: Solution {
    static let day = 18

    typealias Instruction = (direction: Direction, length: Int, directionByColor: Direction, lengthByColor: Int)
    private let digPlan: [Instruction]

    init(input: String) {
        self.digPlan = input.split(separator: "\n")
            .compactMap { line -> Instruction? in
                guard let (_, dir, num, col) = line.wholeMatch(of: #/(.) (\d+) \(#([0-9a-f]{6})\)/#)?.output,
                      let direction = dir.first.flatMap({ Direction(directionCode: $0) }),
                      let length = Int(num),
                      let directionByColor = Self.parseDirection(col.last?.wholeNumberValue),
                      let lengthByColor = Int(col.prefix(5), radix: 16)
                else { return nil }

                return (direction, length, directionByColor, lengthByColor)
            }
    }

    private static func parseDirection(_ number: Int?) -> Direction? {
        return switch number {
        case 0: .east
        case 1: .south
        case 2: .west
        case 3: .north
        default: nil
        }
    }

    func runPartOne() -> Int {
        solve { point, instruction in
            point.moved(into: instruction.direction, by: instruction.length)
        }
    }

    func runPartTwo() -> Int {
        solve { point, instruction in
            point.moved(into: instruction.directionByColor, by: instruction.lengthByColor)
        }
    }

    private func solve(move: (Point, Instruction) -> Point) -> Int {
        var route: [Point] = []
        var outlineLength = 0
        var current = Point.zero
        for instruction in digPlan {
            let instructionEnd = move(current, instruction)
            route.append(instructionEnd)
            outlineLength += current.distance(to: instructionEnd)
            current = instructionEnd
        }

        return outlineLength / 2 + route.adjacentPairs()
            .map { ($0.0.y + $0.1.y) * ($0.0.x - $0.1.x) }
            .sum() / 2 + 1
    }
}
