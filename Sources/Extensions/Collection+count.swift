extension Collection {
    func count(where isIncluded: (Element) -> Bool) -> Int {
        filter(isIncluded).count
    }
}
