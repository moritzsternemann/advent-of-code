struct NumberGrid: Grid {
    var storage: [Point: Int]

    init(_ values: [[Character]]) {
        self.storage = Dictionary(uniqueKeysWithValues:
            values.enumerated().flatMap { y, row in
                row.enumerated().compactMap { x, char in
                    guard let number = char.wholeNumberValue else { return nil }
                    return (Point(x: x, y: y), number)
                }
            }
        )
    }
}
