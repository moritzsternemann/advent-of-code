extension Collection where Element: AdditiveArithmetic {
    @inlinable
    func sum() -> Element {
        reduce(.zero) { $0 + $1 }
    }
}

extension Collection {
    @inlinable
    func sum<Value: AdditiveArithmetic>(by: (Element) -> Value) -> Value {
        reduce(.zero) { $0 + by($1) }
    }
}
