import XCTest
@testable import Foundation2

final class Foundation2Tests: XCTestCase {
	
	func testMeasureFastRandom() {
		self.measure {
			FastRandom.bytes.useAndFree { random in
				for i in 0..<1_000_000 {
					let element = random.nextNumber
					if (i % 100_000 == 0) {
						print(element)
					}
				}
			}
		}
		if #available(iOS 9.0, macOS 10.11, *) {
			let value = TrueRandom.nextInt(upperBound: 1000)
			print(value)
		}
    }
	
	func testThings() {
		print("Message: <placeholder>" ~~> ("<placeholder>" ==> "Hi!"))
	}
	
	func testMathematics() {
		print(2 ** 4)
	}
	
	func testStrings() {
		
		let john: String? = ""
		let name: String? = "Daniel"
		
		if john.isNullOrBlank {
			print(john ?? "nope")
		}
		
		if john?.isBlank == true {
			print(john ?? "nope")
		}
		
		if name?.isNotEmpty == true {
			print(name ?? "nope")
		}
		
		if let validName = name.presence {
			print(validName)
		}
	}
	
    static var allTests = [
        ("testMeasureFastRandom", testMeasureFastRandom),
    ]
}
