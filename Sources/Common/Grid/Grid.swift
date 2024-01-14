protocol Grid: CustomStringConvertible {
    associatedtype Value
    var storage: [Point: Value] { get }

    init(_ values: [[Character]])
    init(input string: String, separator: String)

    func minX() -> Int
    func maxX() -> Int
    func minY() -> Int
    func maxY() -> Int
    func limits() -> (minX: Int, maxX: Int, minY: Int, maxY: Int)
    func topLeft() -> Point
    func topRight() -> Point
    func bottomLeft() -> Point
    func bottomRight() -> Point
    func corners() -> (topLeft: Point, topRight: Point, bottomLeft: Point, bottomRight: Point)
    func width() -> Int
    func height() -> Int
    var allPoints: [Point] { get }
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

    func minX() -> Int {
        storage.keys.map(\.x).min() ?? 0
    }

    func maxX() -> Int {
        storage.keys.map(\.y).min() ?? 0
    }

    func minY() -> Int {
        storage.keys.map(\.x).max() ?? 0
    }

    func maxY() -> Int {
        storage.keys.map(\.y).max() ?? 0
    }

    func limits() -> (minX: Int, maxX: Int, minY: Int, maxY: Int) {
        let (minX, maxX) = storage.keys.minAndMax(by: { $0.x < $1.x }).map { ($0.min.x, $0.max.x) } ?? (0, 0)
        let (minY, maxY) = storage.keys.minAndMax(by: { $0.y < $1.y }).map { ($0.min.y, $0.max.y) } ?? (0, 0)
        return (minX, maxX, minY, maxY)
    }

    func topLeft() -> Point {
        Point(x: minX(), y: minY())
    }

    func topRight() -> Point {
        Point(x: maxX(), y: minY())
    }

    func bottomLeft() -> Point {
        Point(x: minX(), y: maxY())
    }

    func bottomRight() -> Point {
        Point(x: maxX(), y: maxY())
    }

    func corners() -> (topLeft: Point, topRight: Point, bottomLeft: Point, bottomRight: Point) {
        let (minX, maxX, minY, maxY) = limits()
        return (
            Point(x: minX, y: minY),
            Point(x: maxX, y: minY),
            Point(x: minX, y: maxY),
            Point(x: maxX, y: maxY)
        )
    }

    var allPoints: [Point] {
        Array(storage.keys)
    }

    func width() -> Int {
        maxX() + 1 - minX()
    }

    func height() -> Int {
        maxY() + 1 - minY()
    }

    func contains(_ point: Point) -> Bool {
        storage.keys.contains(point)
    }

    subscript(_ point: Point) -> Value? {
        storage[point]
}

extension Grid {
    var description: String {
        let (minX, maxX, minY, maxY) = limits()
        return (minY...maxY).map { y in
            (minX...maxX).map { x in
                guard let value = storage[Point(x: x, y: y)] else { return "." }
                return String(describing: value)
            }
            .joined()
        }
        .joined(separator: "\n")
    }
}
