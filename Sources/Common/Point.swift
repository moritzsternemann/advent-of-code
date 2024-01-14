struct Point: Equatable, Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static var zero: Point { Point(x: 0, y: 0) }

    func moved(to direction: Direction, by distance: Int = 1) -> Point {
        return switch direction {
        case .north: Point(x: x, y: y - distance)
        case .west: Point(x: x - distance, y: y)
        case .south: Point(x: x, y: y + distance)
        case .east: Point(x: x + distance, y: y)
        }
    }

    func distance(to other: Point) -> Int {
        abs(other.x - x) + abs(other.y - y)
    }

    var description: String {
        "[\(x),\(y)]"
    }
}
