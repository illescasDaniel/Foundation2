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
	
	@available(iOS 10.0, OSX 10.12, *)
	func testMeasurements() {
		print(543.G, 462834.in(.kilo), 462834.in(.centi), 10.k)
		print(14_516_457.formatted, 10_000.formatted)
		print(10.M, 10_000.in(.kilo), 10_000.inMeasurement(unit: .kilo))
	}
	
    static var allTests = [
        ("testMeasureFastRandom", testMeasureFastRandom),
    ]
}
