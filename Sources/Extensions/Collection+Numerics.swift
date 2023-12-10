import Numerics

extension Collection where Element: BinaryInteger {
    @inlinable
    func gcd() -> Element {
        guard let first else { return .zero }
        return dropFirst().reduce(first) { IntegerUtilities.gcd($0, $1) }
    }

    @inlinable
    func lcm() -> Element {
        func _lcm<T: BinaryInteger>(_ a: T, _ b: T) -> T {
            let x = T(a.magnitude)
            let y = T(b.magnitude)

            let z = IntegerUtilities.gcd(x, y)

            guard z != 0 else { return 0 }
            return x * (y / z)
        }

        guard let first else { return .zero }
        return dropFirst().reduce(first) { _lcm($0, $1) }
    }
}
