import XCTest
@testable import AdventOfCode

final class Day10Tests: XCTestCase, SolutionTest {
    typealias SUT = Day10

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 8)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 10)
    }
}
