import Collections

struct Day16: Solution {
    static let day = 16

    private let grid: CharacterGrid

    init(input: String) {
        self.grid = CharacterGrid(input: input)
    }

    func runPartOne() -> Int {
        solve(from: Beam(.east, .zero))
    }

    func runPartTwo() -> Int {
        let (minX, maxX, minY, maxY) = grid.limits()
        let (topLeft, topRight, bottomLeft, bottomRight) = grid.corners()

        let startBeams = grid.allPoints
            .filter {
                // only edges
                $0.x == minX || $0.y == minY || $0.x == maxX || $0.y == maxY
            }
            .flatMap { point -> [Beam] in
                return if point == topLeft {
                    [Direction.east, .south].map { Beam($0, point) }
                } else if point == topRight {
                    [Direction.west, .south].map { Beam($0, point) }
                } else if point == bottomLeft {
                    [Direction.east, .north].map { Beam($0, point) }
                } else if point == bottomRight {
                    [Direction.west, .north].map { Beam($0, point) }
                } else if point.y == minY {
                    [Beam(.south, point)]
                } else if point.y == maxY {
                    [Beam(.north, point)]
                } else if point.x == minX {
                    [Beam(.east, point)]
                } else if point.x == maxX {
                    [Beam(.west, point)]
                } else {
                    []
                }
            }

        return startBeams
            .map { solve(from: $0) }
            .max() ?? 0
    }

    private func solve(from start: Beam) -> Int {
        var beamQueue = Deque([start])
        var visited = Set<Beam>([start])

        while let beam = beamQueue.popFirst() {
            var newBeams: [Beam] = []
            if let current = grid[beam.location] {
                if current == "."
                    || (current == "|" && beam.direction.isVertical)
                    || (current == "-" && beam.direction.isHorizontal) {
                    newBeams.append(beam.movedForward())
                } else if current == "\\" {
                    let newDirection = beam.direction.turned(clockwise: beam.direction.isVertical)
                    newBeams.append(beam.moved(to: newDirection))
                } else if current == "/" {
                    let newDirection = beam.direction.turned(clockwise: beam.direction.isHorizontal)
                    newBeams.append(beam.moved(to: newDirection))
                } else if (current == "|" && beam.direction.isHorizontal)
                    || (current == "-" && beam.direction.isVertical) {
                    newBeams.append(beam.moved(to: beam.direction.turnedCounterclockwise))
                    newBeams.append(beam.moved(to: beam.direction.turnedClockwise))
                }
            }

            for beam in newBeams {
                if !visited.contains(beam) && grid.contains(beam.location) {
                    beamQueue.append(beam)
                    visited.insert(beam)
                }
            }
        }

        return visited
            .map(\.location)
            .asSet()
            .count
    }
}

extension Day16 {
    struct Beam: Hashable {
        var direction: Direction
        var location: Point

        init(_ direction: Direction, _ location: Point) {
            self.direction = direction
            self.location = location
        }

        func movedForward() -> Beam {
            Beam(direction, location.moved(into: direction))
        }

        func moved(to direction: Direction) -> Beam {
            Beam(direction, location.moved(into: direction))
        }
    }
}
