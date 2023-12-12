extension Sequence where Element: Hashable {
    func asSet() -> Set<Element> {
        Set(self)
    }
}
