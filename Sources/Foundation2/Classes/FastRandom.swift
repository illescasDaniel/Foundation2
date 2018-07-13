/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

#if !os(watchOS)
import GameplayKit.GKRandomSource
#endif

public typealias Byte = UInt8

/// A class to manage big chunks of random numbers in an easy and very fast way.
///
/// # Usage
///
/// ## Example 1:
/** ```
	FastRandom<Int8>(bufferSize: 5_000_000).useAndFree { random in
		for _ in 0..<5 {
			print(random.nextNumber)
		}
	}
	```
*/
/// ## Example 2:
/** ```
	FastRandom.standard.useAndFree { random in
		for _ in 0..<5 {
			print(random.nextNumber)
		}
	}
	```
*/
/// ## Example 3:
/** ```
	let random1 = FastRandom.standard.nextElement
	let random2 = FastRandom.standard.nextElement
	...
	FastRandom.standard.freeMemory() // Optional, use it when you stop using the generator
	```
*/
public final class FastRandom<T: Initiable> {
	
	public typealias Element = T
	
	private var randomElements: [Element] = []
	private let bufferSize: Int
	private var internalCount = 0
	
	init(bufferSize: Int = 100_000) {
		self.bufferSize = abs(bufferSize)
	}
	
	public var nextNumber: Element {
		self.internalCount -= 1
		if self.internalCount <= 0 {
			self.randomElements = TrueRandom.arrayOf(nElements: self.bufferSize)
			self.internalCount = self.bufferSize - 1
		}
		return self.randomElements[self.internalCount]
	}
	
	public func useAndFree(block: (FastRandom) -> ()) {
		block(self)
		self.freeMemory()
	}
	
	/// Frees the internal elements array. Use it when you stop using this random number generator.
	public func freeMemory() {
		self.randomElements.removeAll()
		self.internalCount = 0
	}
}

public extension FastRandom where FastRandom.Element == Int {
	/// A FastRandom object of integers
	static let standard = FastRandom<Int>()
	/// A FastRandom object of integers with buffer size of 5.000.000
	static let bigStandard = FastRandom<Int>(bufferSize: 5_000_000)
}
public extension FastRandom where FastRandom.Element == Byte {
	/// A FastRandom object of bytes
	static let bytes = FastRandom<Byte>()
	/// A FastRandom object of bytes with buffer size of 50.000.000
	static let lotsOfBytes = FastRandom<Byte>(bufferSize: 50_000_000)
}

/// An easy way of getting 'true' random numbers and big arrays.
struct TrueRandom {
	
	public static func arrayOf(nBytes numberOfBytes: Int) -> [Byte] {
		var randomBytes = [Byte](repeating: 0, count: numberOfBytes)
		return (SecRandomCopyBytes(kSecRandomDefault, numberOfBytes, &randomBytes) == errSecSuccess) ? randomBytes : []
	}
	
	public static func arrayOf<T: Initiable>(nElements: Int) -> [T] {
		var randomBytes = [T](repeating: T(), count: nElements)
		let bytesPerElement = MemoryLayout<T>.size
		return (SecRandomCopyBytes(kSecRandomDefault, nElements * bytesPerElement, &randomBytes) == errSecSuccess) ? randomBytes : []
	}
	
	public static var seed: Data {
		let randomBytes = TrueRandom.arrayOf(nBytes: MemoryLayout<Int>.size)
		return Data(bytes: randomBytes)
	}
	
	#if !os(watchOS)
	@available(iOS 9.0, macOS 10.11, *)
	public static func nextInt(upperBound: Int, seed: Data = TrueRandom.seed) -> Int {
		return GKARC4RandomSource(seed: seed).nextInt(upperBound: upperBound)
	}
	#endif
}
