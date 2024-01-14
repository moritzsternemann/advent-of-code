struct CharacterGrid: Grid {
    var storage: [Point: Character]
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int

    init(_ values: [[Character]]) {
        self.storage = Dictionary(uniqueKeysWithValues:
            values.enumerated().flatMap { y, row in
                row.enumerated().map { x, char in
                    (Point(x: x, y: y), char)
                }
            }
        )

        self.minX = self.storage.keys.map(\.x).min() ?? 0
        self.minY = self.storage.keys.map(\.y).min() ?? 0
        self.maxX = self.storage.keys.map(\.x).max() ?? 0
        self.maxY = self.storage.keys.map(\.y).max() ?? 0
    }
}
