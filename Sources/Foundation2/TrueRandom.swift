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

#if os(watchOS)
#else
import GameplayKit.GKRandomSource
#endif

/// Very useful type which handles millions of random numbers.
///
/// On the first call on `nextNumber` it will initialize an interal array of `maxSize` random values.
///
/// - Note: keep in mind that the initial generation of the values would take a little bit, but the later access for those numbers is super fast.
public struct TrueRandom {
	
	public typealias Byte = UInt32
	public typealias Element = UInt8 // UInt32, etc
	
	public static func arrayOf(nBytes numberOfBytes: Int) -> [Byte] {
		var randomBytes = [Byte](repeating: 0, count: numberOfBytes)
		return (SecRandomCopyBytes(kSecRandomDefault, numberOfBytes, &randomBytes) == errSecSuccess) ? randomBytes : []
	}
	
	public static func arrayOf<Type: Initiable>(nElements: Int) -> [Type] {
		var randomBytes = [Type](repeating: Type(), count: nElements)
		let bytesPerElement = MemoryLayout<Type>.size
		return (SecRandomCopyBytes(kSecRandomDefault, nElements * bytesPerElement, &randomBytes) == errSecSuccess) ? randomBytes : []
	}
	
	private static var randomBytes: [Element] = [] // TrueRandom.arrayOf(nElements: maxSize)
	
	private static let maxSize = 50_000_000
	private static var internalCount = 0 // maxSize
	
	public static var seed: Data {
		let randomBytes = TrueRandom.arrayOf(nBytes: MemoryLayout<Int>.size)
		let data = NSData(bytes: randomBytes, length: MemoryLayout<Int>.size)
		return data as Data
	}
	
	#if os(watchOS)
	#else
	@available(iOS 9.0, macOS 10.11, *)
	public static func nextInt(upperBound: Int, seed: Data) -> Int {
		return GKARC4RandomSource(seed: seed).nextInt(upperBound: upperBound)
	}
	#endif
	
	public static var nextNumber: Element {
		internalCount -= 1
		if internalCount <= 0 {
			randomBytes = TrueRandom.arrayOf(nElements: maxSize)
			internalCount = maxSize - 1
		}
		return randomBytes[internalCount]
	}
	
	/// It generates a random number between 0 and upperbound.
	/// As the random generator can't exceed values above Element.max, this function uses an interpolation (upperbound / MaximumGeneratorValue)...
	public static func nextInt(upperBound: Int) -> Int {
		return (upperBound <= Element.max)
			? (Int(nextNumber) % upperBound)
			: (upperBound / Int(Element.max)) > Int(Element.max)
			? ((upperBound / Int(Element.max)) * Int(nextNumber))
			: ((((upperBound / Int(Element.max)) * Int(nextNumber)) * 1043587) % upperBound)
		// Alternative:
		// return (upperBound <= Byte.max) ? (Int(nextByte) % upperBound) : nextInt(upperBound: upperBound, seed: TrueRandom.seed)
	}
}
