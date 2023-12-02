import XCTest
@testable import AdventOfCode

final class Day02Tests: XCTestCase, SolutionTest {
    typealias SUT = Day02

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 8)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 2286)
    }
}
