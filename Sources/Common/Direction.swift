enum Direction {
    case north
    case west
    case south
    case east

    var isVertical: Bool {
        self == .north || self == .south
    }

    var isHorizontal: Bool {
        self == .east || self == .west
    }

    var turnedClockwise: Direction {
        return switch self {
        case .north: .west
        case .west: .south
        case .south: .east
        case .east: .north
        }
    }

    var turnedCounterclockwise: Direction {
        return switch self {
        case .north: .east
        case .west: .north
        case .south: .west
        case .east: .south
        }
    }

    func turned(clockwise: Bool) -> Direction {
        clockwise ? turnedClockwise : turnedCounterclockwise
    }
}

extension Direction: CustomStringConvertible {
    var description: String {
        return switch self {
        case .north: "N"
        case .west: "W"
        case .south: "S"
        case .east: "E"
        }
    }
}
