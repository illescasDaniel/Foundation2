import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Foundation2Tests.allTests),
    ]
}
#endif