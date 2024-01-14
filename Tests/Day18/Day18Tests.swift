import XCTest
@testable import AdventOfCode

final class Day18Tests: XCTestCase, SolutionTest {
    typealias SUT = Day18

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 62)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 952408144115)
    }
}
