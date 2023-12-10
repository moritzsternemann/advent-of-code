import XCTest
@testable import AdventOfCode

final class Day08Tests: XCTestCase, SolutionTest {
    typealias SUT = Day08

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 6)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 6)
    }
}
