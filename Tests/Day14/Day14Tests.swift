import XCTest
@testable import AdventOfCode

final class Day14Tests: XCTestCase, SolutionTest {
    typealias SUT = Day14

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 136)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 64)
    }
}
