protocol Solution {
    static var day: Int { get }
    init(input: String)

    associatedtype Output2: CustomStringConvertible
    func runPartOne() -> Output1

    associatedtype Output1: CustomStringConvertible
    func runPartTwo() -> Output2
}
