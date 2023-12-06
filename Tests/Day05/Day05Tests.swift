import XCTest
@testable import AdventOfCode

final class Day05Tests: XCTestCase, SolutionTest {
    typealias SUT = Day05

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 35)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 46)
    }
}
