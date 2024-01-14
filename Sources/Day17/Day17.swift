import Collections

struct Day17: Solution {
    static let day = 17

    private let city: NumberGrid

    init(input: String) {
        self.city = NumberGrid(input: input)
    }

    func runPartOne() -> Int {
        solve(isPart2: false)
    }

    func runPartTwo() -> Int {
        solve(isPart2: true)
    }

    private func solve(isPart2: Bool) -> Int {
        var queue = Heap<Cell>()
        var best: [BestPathKey: Int] = [:]

        queue.insert(Cell(dist: 0, location: .zero, directionCount: 0))

        let bottomRight = city.bottomRight()
        while let current = queue.popMin() {
            if current.location == bottomRight,
               (!isPart2 || current.directionCount >= 4) {
                return current.dist
            }

            for direction in Direction.allCases {
                if direction == current.lastDirection?.opposite { continue }
                if isPart2,
                   let lastDirection = current.lastDirection,
                   direction != lastDirection,
                   current.directionCount < 4
                { continue }

                let newDirectionCount: Int
                if direction == current.lastDirection {
                    newDirectionCount = current.directionCount + 1
                    if newDirectionCount == (isPart2 ? 11 : 4) { continue }
                } else {
                    newDirectionCount = 1
                }

                let newLocation = current.location.moved(into: direction)
                if let blockValue = city[newLocation] {
                    let newDistance = current.dist + blockValue
                    let bestKey = BestPathKey(location: newLocation, direction: direction, directionCount: newDirectionCount)
                    if newDistance >= best[bestKey, default: .max] {
                        continue
                    }
                    best[bestKey] = newDistance
                    queue.insert(Cell(dist: newDistance, location: newLocation, lastDirection: direction, directionCount: newDirectionCount))
                }
            }
        }

        return -1
    }
}

extension Day17 {
    struct Cell: Comparable {
        var dist: Int
        var location: Point
        var lastDirection: Direction?
        var directionCount: Int

        static func < (lhs: Cell, rhs: Cell) -> Bool {
            lhs.dist < rhs.dist
        }
    }

    struct BestPathKey: Hashable {
        var location: Point
        var direction: Direction
        var directionCount: Int
    }
}
