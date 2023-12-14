import XCTest
@testable import AdventOfCode

final class Day13Tests: XCTestCase, SolutionTest {
    typealias SUT = Day13

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 405)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 400)
    }
}
