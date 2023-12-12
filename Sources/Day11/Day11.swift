import Algorithms

struct Day11: Solution {
    static let day = 11

    private let universe: Universe

    init(input: String) {
        self.universe = Universe(input)
    }

    func runPartOne() -> Int {
        universe.expandedForAge(1)
            .galaxies
            .combinations(ofCount: 2)
            .map { $0[1].distance(to: $0[0]) }
            .sum()
    }

    func runPartTwo() -> Int {
        universe.expandedForAge(999_999)
            .galaxies
            .combinations(ofCount: 2)
            .map { $0[1].distance(to: $0[0]) }
            .sum()
    }
}

extension Day11 {
    struct Universe {
        private(set) var galaxies: Set<Location>

        var rows: Int {
            galaxies.map(\.row).max().map { $0 + 1 } ?? 0
        }

        var columns: Int {
            galaxies.map(\.column).max().map { $0 + 1 } ?? 0
        }

        init(_ string: String) {
            self.galaxies = string.split(separator: "\n").enumerated()
                .flatMap { rowIndex, row in
                    row.enumerated()
                        .filter { $0.element == "#" }
                        .map { Location(rowIndex, $0.offset) }
                }
                .asSet()
        }

        private init(galaxies: Set<Location>) {
            self.galaxies = galaxies
        }

        func expandedForAge(_ age: Int) -> Universe {
            let emptyColumns = (0..<columns)
                .filter { column in
                    !galaxies.contains { $0.column == column }
                }

            let emptyRows = (0..<rows)
                .filter { row in
                    !galaxies.contains { $0.row == row }
                }

            let movedGalaxies = galaxies
                .map { galaxy in
                    let shift = Location(
                        emptyRows.count(where: { $0 < galaxy.row }),
                        emptyColumns.count(where: { $0 < galaxy.column })
                    )

                    return galaxy + (age * shift)
                }
                .asSet()

            return Universe(galaxies: movedGalaxies)
        }
    }

    struct Location: Hashable {
        var row: Int
        var column: Int
        
        init(_ row: Int, _ column: Int) {
            self.row = row
            self.column = column
        }

        func distance(to other: Location) -> Int {
            abs(other.column - column) + abs(other.row - row)
        }

        static func +(lhs: Location, rhs: Location) -> Location {
            Location(lhs.row + rhs.row, lhs.column + rhs.column)
        }

        static func *(multiplier: Int, location: Location) -> Location {
            Location(multiplier * location.row, multiplier * location.column)
        }
    }
}
