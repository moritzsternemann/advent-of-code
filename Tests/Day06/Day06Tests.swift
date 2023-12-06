import XCTest
@testable import AdventOfCode

final class Day06Tests: XCTestCase, SolutionTest {
    typealias SUT = Day06

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 288)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 71503)
    }
}
