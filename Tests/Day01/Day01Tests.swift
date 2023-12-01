import XCTest
@testable import AdventOfCode

final class Day01Tests: XCTestCase, SolutionTest {
    typealias SUT = Day01

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 209)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 281)
    }
}
