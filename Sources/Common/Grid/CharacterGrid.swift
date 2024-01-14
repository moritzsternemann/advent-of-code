struct CharacterGrid: Grid {
    var storage: [Point: Character]

    init(_ values: [[Character]]) {
        self.storage = Dictionary(uniqueKeysWithValues:
            values.enumerated().flatMap { y, row in
                row.enumerated().map { x, char in
                    (Point(x: x, y: y), char)
                }
            }
        )
    }
}
