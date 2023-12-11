import XCTest
@testable import AdventOfCode

final class Day09Tests: XCTestCase, SolutionTest {
    typealias SUT = Day09

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 114)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 2)
    }
}
