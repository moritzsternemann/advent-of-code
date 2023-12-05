import XCTest
@testable import AdventOfCode

final class Day04Tests: XCTestCase, SolutionTest {
    typealias SUT = Day04

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 13)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 30)
    }
}
