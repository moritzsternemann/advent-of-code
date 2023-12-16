struct Grid {
    var grid: [Point: Character]
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int

    init(input string: String, separator: String = "\n") {
        self.init(
            string.split(separator: separator)
                .map { row in row.map { $0 }}
        )
    }

    init(_ grid: [[Character]]) {
        self.grid = Dictionary(uniqueKeysWithValues:
            grid.enumerated().flatMap { y, row in
                row.enumerated().map { x, char in
                    (Point(x: x, y: y), char)
                }
            }
        )

        self.minX = self.grid.keys.map(\.x).min() ?? 0
        self.minY = self.grid.keys.map(\.y).min() ?? 0
        self.maxX = self.grid.keys.map(\.x).max() ?? 0
        self.maxY = self.grid.keys.map(\.y).max() ?? 0
    }

    var allPoints: Dictionary<Point, Character>.Keys {
        grid.keys
    }

    var topLeft: Point {
        Point(x: minX, y: minY)
    }

    var topRight: Point {
        Point(x: maxX, y: minY)
    }

    var bottomLeft: Point {
        Point(x: minX, y: maxY)
    }

    var bottomRight: Point {
        Point(x: maxX, y: maxY)
    }

    var width: Int {
        maxX + 1 - minX
    }

    var height: Int {
        maxY + 1 - minY
    }

    func contains(_ point: Point) -> Bool {
        grid.keys.contains(point)
    }

    subscript(_ point: Point) -> Character? {
        grid[point]
    }
}

extension Grid {
    struct Point: Equatable, Hashable, CustomStringConvertible {
        var x: Int
        var y: Int

        static var zero: Point { Point(x: 0, y: 0) }

        func moved(to direction: Direction) -> Point {
            return switch direction {
            case .north: Point(x: x, y: y - 1)
            case .west: Point(x: x - 1, y: y)
            case .south: Point(x: x, y: y + 1)
            case .east: Point(x: x + 1, y: y)
            }
        }

        var description: String {
            "[\(x),\(y)]"
        }
    }
}
