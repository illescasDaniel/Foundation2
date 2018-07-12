import XCTest
@testable import Foundation2

final class Foundation2Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
		let test = "hi"
        XCTAssertEqual("hi", test)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
