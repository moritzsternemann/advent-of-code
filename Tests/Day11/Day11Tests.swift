import XCTest
@testable import AdventOfCode

final class Day11Tests: XCTestCase, SolutionTest {
    typealias SUT = Day11

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 374)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 82000210)
    }
}
