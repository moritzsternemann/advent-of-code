extension Collection where Iterator.Element: RandomAccessCollection {
    func transposed() -> [[Iterator.Element.Iterator.Element]] {
        guard let first else { return [] }
        assert(allSatisfy({ $0.count == first.count }), "all sub-collections need to have the same element count")

        return first.indices.map { index in
            map { $0[index] }
        }
    }
}
