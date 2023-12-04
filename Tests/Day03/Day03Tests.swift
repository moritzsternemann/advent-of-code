import XCTest
@testable import AdventOfCode

final class Day03Tests: XCTestCase, SolutionTest {
    typealias SUT = Day03

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 4361)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 467835)
    }
}
