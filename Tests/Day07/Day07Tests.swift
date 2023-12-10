import XCTest
@testable import AdventOfCode

final class Day07Tests: XCTestCase, SolutionTest {
    typealias SUT = Day07

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 6440)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 5905)
    }
}
