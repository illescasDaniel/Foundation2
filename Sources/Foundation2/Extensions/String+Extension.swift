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

import class Foundation.NSString
import func Foundation.NSLocalizedString
import struct Foundation.NSCharacterSet.CharacterSet

public extension String {
	/// Accesses the element at the specified position.
	public subscript(index: Int) -> Character {
		let validIndex = self.index(self.startIndex, offsetBy: index)
		return self[validIndex]
	}
	
	/// (From `NSString`) A new string made by deleting the extension (if any, and only the last) from the receiver.
	public var deletingPathExtension: String {
		// or?: URL(string: self)?.deletingPathExtension().absoluteString
		return (self as NSString).deletingPathExtension
	}
	
	/// Returns the string with white spaces and new lines trimmed from both ends of the strings
	var trimmed: String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	/// Retuns a localized string with an empty comment.
	///
	/// You also have `RawRepresentable.rawLocalized` to accesss the localized versions of the raw strings values
	public var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
	public mutating func clear() {
		self = ""
	}
	
	public var isNumeric: Bool {
		return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
	}
	
	/// Returns a number from 0.0 to 1.0 indicating the similarity to other string.
	public func levenshteinDistanceScoreTo(string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Float {
		
		guard !self.isEmpty && !string.isEmpty else { return 0.0 }
		guard self != string else { return 1.0 }
		
		var firstString = self
		var secondString = string
		
		if ignoreCase {
			firstString = firstString.lowercased()
			secondString = secondString.lowercased()
			guard firstString != secondString else { return 1.0 }
		}
		if trimWhiteSpacesAndNewLines {
			firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
			secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
			guard firstString != secondString else { return 1.0 }
			guard !firstString.isEmpty && !secondString.isEmpty else { return 0.0 }
		}
		
		let empty = [Int](repeating:0, count: secondString.count)
		var last = [Int](0...secondString.count)
		
		for (i, tLett) in firstString.enumerated() {
			var cur = [i + 1] + empty
			for (j, sLett) in secondString.enumerated() {
				cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
			}
			last = cur
		}
		
		// maximum string length between the two
		let lowestScore = max(firstString.count, secondString.count)
		
		if let validDistance = last.last {
			return  1 - (Float(validDistance) / Float(lowestScore))
		}
		
		return 0.0
	}
}
