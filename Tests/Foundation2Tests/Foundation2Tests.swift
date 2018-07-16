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
		let number: Int? = nil
		print(number..)
		
		print(10**2)
		
		let number2: Double = 10
		print(number2 ** 2)
		
		let number3: Float = 10
		print(Double(number3) ** 2)
	}
	
    static var allTests = [
        ("testMeasureFastRandom", testMeasureFastRandom),
    ]
}
