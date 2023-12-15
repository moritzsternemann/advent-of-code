struct Day14: Solution {
    static let day = 14

    private let platform: Platform

    init(input: String) {
        self.platform = Platform(input)
    }

    func runPartOne() -> Int {
        var platform = platform

        // slide rocks
        platform.tilt(.north)

        return platform.northSupportBeamLoad
    }

    func runPartTwo() -> Int {
        var platform = platform

        // instead of iterating 1_000_000_000 times, stop when the pattern repeats
        var seen: [Platform] = []
        var startIndex: Int?
        var iteration: Int = 0
        while true {
            platform.cycle()
            if let seenIndex = seen.firstIndex(of: platform) {
                startIndex = seenIndex
                break
            }
            seen.append(platform)
            iteration += 1
        }

        guard let startIndex else { fatalError() }

        return seen[(1_000_000_000 - iteration).remainder(dividingBy: startIndex - iteration) + iteration - 1]
            .northSupportBeamLoad
    }
}

extension Day14 {
    struct Platform: Equatable {
        let board: Set<Point>
        var roundedRocks: Set<Point>
        let cubeRocks: Set<Point>

        init(_ string: String) {
            let rocks = string.split(separator: "\n").enumerated()
                .flatMap { (rowIndex, row) in
                    row.enumerated().map { (columnIndex, rock) in
                        (rock, Point(columnIndex, rowIndex))
                    }
                }

            self.board = rocks.map(\.1).asSet()
            self.roundedRocks = rocks
                .filter { $0.0 == "O" }
                .map(\.1)
                .asSet()
            self.cubeRocks = rocks
                .filter { $0.0 == "#" }
                .map(\.1)
                .asSet()
        }

        var width: Int {
            board.max(by: { $0.x < $1.x }).map { $0.x + 1 } ?? 0
        }

        var height: Int {
            board.max(by: { $0.y < $1.y }).map { $0.y + 1 } ?? 0
        }

        mutating func cycle() {
            for direction in Direction.allCases {
                tilt(direction)
            }
        }

        mutating func tilt(_ direction: Direction) {
            while true {
                let free = board.subtracting(roundedRocks).subtracting(cubeRocks)

                let movedRocks = roundedRocks
                    .map { rock in
                        let moved = rock + direction.searchDelta
                        if free.contains(moved) {
                            return moved
                        } else {
                            return rock
                        }
                    }
                    .asSet()

                if movedRocks == roundedRocks {
                    return
                }
                roundedRocks = movedRocks
            }
        }

        var northSupportBeamLoad: Int {
            let height = height
            return roundedRocks.sum { height - $0.y }
        }

        static func ==(lhs: Platform, rhs: Platform) -> Bool {
            lhs.roundedRocks == rhs.roundedRocks
        }
    }

    struct Point: Hashable {
        var x: Int
        var y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        static func +(lhs: Point, rhs: Point) -> Point {
            Point(lhs.x + rhs.x, lhs.y + rhs.y)
        }
    }

    enum Direction: CaseIterable {
        case north, west, south, east

        var searchDelta: Point {
            switch self {
            case .north:
                return Point(0, -1)
            case .west:
                return Point(-1, 0)
            case .south:
                return Point(0, 1)
            case .east:
                return Point(1, 0)
            }
        }
    }
}
