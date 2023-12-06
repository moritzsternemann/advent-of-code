extension Collection where Element: Numeric {
    @inlinable
    func product() -> Element {
        reduce(1) { $0 * $1 }
    }
}

extension Collection {
    @inlinable
    func product<Value: Numeric>(by: (Element) -> Value) -> Value {
        reduce(1) { $0 * by($1) }
    }
}
