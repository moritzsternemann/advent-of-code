extension String {
    func index(before i: Index, limitedBy limit: Index) -> Index? {
        guard i > limit else { return nil }
        return index(before: i)
    }

    func index(after i: Index, limitedBy limit: Index) -> Index? {
        guard i < limit else { return nil }
        return index(after: i)
    }
}
