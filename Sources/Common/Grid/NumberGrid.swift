struct NumberGrid: Grid {
    var storage: [Point: Int]
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int

    init(_ values: [[Character]]) {
        self.storage = Dictionary(uniqueKeysWithValues:
            values.enumerated().flatMap { y, row in
                row.enumerated().compactMap { x, char in
                    guard let number = char.wholeNumberValue else { return nil }
                    return (Point(x: x, y: y), number)
                }
            }
        )

        self.minX = self.storage.keys.map(\.x).min() ?? 0
        self.minY = self.storage.keys.map(\.y).min() ?? 0
        self.maxX = self.storage.keys.map(\.x).max() ?? 0
        self.maxY = self.storage.keys.map(\.y).max() ?? 0
    }
}
