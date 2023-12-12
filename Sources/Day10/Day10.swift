import Collections

struct Day10: Solution {
    static let day = 10

    private let directions: [Character: [Direction]] = [
        "|": [.y(1), .y(-1)],
        "-": [.x(1), .x(-1)],
        "J": [.y(-1), .x(-1)],
        "F": [.y(1), .x(1)],
        "7": [.y(1), .x(-1)],
        "L": [.y(-1), .x(1)],
    ]

    private let board: [Point: Character]
    private let lineCount: Int
    private let columnCount: Int

    init(input: String) {
        let lines = input.split(separator: "\n")
        self.lineCount = lines.count
        self.columnCount = lines.first?.count ?? 0
        var board = Dictionary<Point, Character>(minimumCapacity: self.lineCount * self.columnCount)
        for (i, line) in lines.enumerated() {
            for (j, character) in line.enumerated() {
                board[Point(j, i)] = character
            }
        }
        self.board = board
    }

    func runPartOne() -> Int {
        let (maxDistance, _) = findLongestDistancePoint()
        return maxDistance
    }

    func runPartTwo() -> Int {
        let directions: Set<Point> = [
            Point(-1, -1),
            Point(-1, 0),
            Point(-1, 1),
            Point(0, -1),
            Point(0, 1),
            Point(1, -1),
            Point(1, 0),
            Point(1, 1),
        ]

        var graph = Graph()

        // Double the size of the board to allow squeezing between pipes
        // and pad outside to be able to get around.
        for i in -1..<(2 * lineCount + 1) {
            for j in -1..<(2 * columnCount + 1) {
                for dz in directions {
                    let z = Point(j, i)
                    graph.addEdge(from: z, to: z + dz)
                }
            }
        }

        let (_, toRemove) = findLongestDistancePoint()
        for point in toRemove {
            graph.removeNode(point)
        }

        let tiles: Set<Point> = graph.connectedComponents()
            .filter { $0.contains(Point(-1, -1)) }
            .flatMap { $0 }
            .asSet()

        // Only count "physical" aka even points
        return tiles
            .filter { $0.x % 2 == 0 && $0.y % 2 == 0 }
            .count
    }

    private func findStartPointDirections() -> (start: Point, directions: [Direction]) {
        guard let start = board.first(where: { $1 == "S" })?.key else { fatalError("no start") }

        // figure out what character S resembles
        let directionOfStart = directions.first { directionEntry in
            directionEntry.value.allSatisfy { direction in
                let adjacent = start.adjusted(by: direction)

                // adjacent needs to point back at S
                guard let adjacentCharacter = board[adjacent],
                      let adjacentDirections = directions[adjacentCharacter]
                else { return false }

                return adjacentDirections.contains { adjacent.adjusted(by: $0) == start }
            }
        }

        guard let directionOfStart else { fatalError("S doesn't resemble any character") }
        return (start, directionOfStart.value)
    }

    private func findLongestDistancePoint() -> (distance: Int, toRemove: Set<Point>) {
        let (start, startDirections) = findStartPointDirections()
        var directions = directions
        directions["S"] = startDirections

        // walk the board graph and increase the distance until max distance is reached
        var maxDistance = 0
        var seen = Set([start])
        var toRemove = Set<Point>()
        var queue = Deque([(start, 0)]) // tuple of point and distance to that point
        while let (point, distance) = queue.popFirst() {
            guard let character = board[point],
                  let directionsFromPoint = directions[character]
            else { fatalError() }

            maxDistance = distance
            for directionFromPoint in directionsFromPoint {
                let newPoint = point.adjusted(by: directionFromPoint)
                if !seen.contains(newPoint) {
                    queue.append((newPoint, distance + 1))
                    seen.insert(newPoint)
                }

                toRemove.formUnion([
                    2 * point,
                    (2 * point).adjusted(by: directionFromPoint),
                    (2 * point).adjusted(by: 2 * directionFromPoint)
                ])
            }
        }

        return (maxDistance, toRemove)
    }
}

extension Day10 {
    struct Point: Hashable {
        var x: Int
        var y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        func adjusted(by direction: Direction) -> Point {
            switch direction {
            case let .x(delta):
                return Point(x + delta, y)
            case let .y(delta):
                return Point(x, y + delta)
            }
        }

        static func +(lhs: Point, rhs: Point) -> Point {
            Point(lhs.x + rhs.x, lhs.y + rhs.y)
        }

        static func *(multiplier: Int, point: Point) -> Point {
            Point(multiplier * point.x, multiplier * point.y)
        }
    }

    enum Direction {
        case x(Int), y(Int)

        static func *(multiplier: Int, direction: Direction) -> Direction {
            switch direction {
            case let .x(x):
                return .x(multiplier * x)
            case let .y(y):
                return .y(multiplier * y)
            }
        }
    }

    struct Graph {
        var adjacency: [Point: Set<Point>] = [:]

        mutating func addEdge(from: Point, to: Point) {
            adjacency[from, default: []].insert(to)
        }

        mutating func removeNode(_ node: Point) {
            adjacency.removeValue(forKey: node)
        }

        func connectedComponents() -> [Set<Point>] {
            var visited = Set<Point>()
            var components: [Set<Point>] = []

            func dfs(_ node: Point, component: inout Set<Point>) {
                visited.insert(node)
                component.insert(node)

                guard let neighbors = adjacency[node] else { return }
                for neighbor in neighbors {
                    guard !visited.contains(neighbor) else { continue }
                    dfs(neighbor, component: &component)
                }
            }

            for node in adjacency.keys {
                guard !visited.contains(node) else { continue }

                var component = Set<Point>()
                dfs(node, component: &component)
                components.append(component)
            }

            return components
        }
    }
}
