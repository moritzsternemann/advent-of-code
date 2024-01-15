import XCTest
@testable import AdventOfCode

final class Day19Tests: XCTestCase, SolutionTest {
    typealias SUT = Day19

    func testPartOne() throws {
        try XCTAssertEqual(sut.runPartOne(), 19114)
    }

    func testPartTwo() throws {
        try XCTAssertEqual(sut.runPartTwo(), 167409079868000)
    }
}
