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

#if swift(>=4.2)
#else

import Foundation
import GameplayKit.GKRandomSource // .shuffled

extension Array: Hashable where Element: Hashable {
	public var hashValue: Int {
		return self.reduce(5381) {
			($0 << 5) &+ $0 &+ $1.hashValue
		}
	}
}

public extension Collection {
	public func shuffled() -> [Iterator.Element] {
		let shuffledArray = (self as? NSArray)?.shuffled()
		let outputArray = shuffledArray as? [Iterator.Element]
		return outputArray ?? []
	}
	public mutating func shuffle() {
		if let selfShuffled = self.shuffled() as? Self {
			self = selfShuffled
		}
	}
}

/* OR:
public extension MutableCollection {
	/// Shuffles the contents of this collection.
	public mutating func shuffle() {
		let c = count
		guard c > 1 else { return }
		
		for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
			// Change `Int` in the next line to `IndexDistance` in < Swift 4.1
			let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
			let i = index(firstUnshuffled, offsetBy: d)
			swapAt(firstUnshuffled, i)
		}
	}
}

public extension Sequence {
	/// Returns an array with the contents of this sequence, shuffled.
	public var shuffled: [Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}*/

#endif
