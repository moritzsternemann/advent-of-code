import XCTest
@testable import AdventOfCode

final class Day16Tests: XCTestCase, SolutionTest {
    typealias SUT = Day16

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 46)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 51)
    }
}
