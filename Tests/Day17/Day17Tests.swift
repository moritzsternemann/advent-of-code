import XCTest
@testable import AdventOfCode

final class Day17Tests: XCTestCase, SolutionTest {
    typealias SUT = Day17

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 102)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 94)
    }
}
