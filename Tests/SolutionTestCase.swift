import Foundation
import XCTest
@testable import AdventOfCode

protocol SolutionTest {
    associatedtype SUT: Solution
}

extension SolutionTest {
    var sut: SUT {
        get throws {
            try SUT(input: getTestData())
        }
    }

    func getTestData(filename: String? = nil) throws -> String {
        let resource = filename ?? "Day\(SUT.day.formatted(.number.precision(.integerLength(2))))"
        let url = try XCTUnwrap(Bundle.module.url(forResource: resource, withExtension: "txt"))
        return try String(contentsOf: url)
    }
}
