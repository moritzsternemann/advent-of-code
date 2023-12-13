import XCTest
@testable import AdventOfCode

final class Day12Tests: XCTestCase, SolutionTest {
    typealias SUT = Day12

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 21)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 525152)
    }
}
