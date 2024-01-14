protocol Grid {
    associatedtype Value
    var storage: [Point: Value] { get }

    init(_ values: [[Character]])
    init(input string: String, separator: String)

    var minX: Int { get }
    var maxX: Int { get }
    var minY: Int { get }
    var maxY: Int { get }
    var topLeft: Point { get }
    var topRight: Point { get }
    var bottomLeft: Point { get }
    var bottomRight: Point { get }
    var allPoints: [Point] { get }
    var width: Int { get }
    var height: Int { get }
    func contains(_ point: Point) -> Bool
    subscript(_ point: Point) -> Value? { get }
}

extension Grid {
    init(input string: String, separator: String = "\n") {
        self.init(
            string.split(separator: separator)
                .map { row in row.map { $0 }}
        )
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

    var allPoints: [Point] {
        Array(storage.keys)
    }

    var width: Int {
        maxX + 1 - minX
    }

    var height: Int {
        maxY + 1 - minY
    }

    func contains(_ point: Point) -> Bool {
        storage.keys.contains(point)
    }

    subscript(_ point: Point) -> Value? {
        storage[point]
    }
}
