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
import class Foundation.NSRegularExpression
import struct Foundation.NSRange

public extension Optional where Wrapped == String {
	
	/// This is the oposite of string?.nonBlankPresence
	public var isNullOrBlank: Bool {
		if let value = self {
			return value.isBlank
		}
		return true
	}
	
	/// This is the oposite of string?.presence
	public var isNullOrEmpty: Bool {
		if let value = self {
			return value.isEmpty
		}
		return true
	}
}

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
	
	/// ```
	/// "Look at the %@. It is %d ft tall.".formatted(args: "Empire State building", 1250)
	/// // results in: Look at the Empire State building. It is 1250 ft tall.
	/// ```
	public func formatted(args arguments: CVarArg...) -> String {
		return String(format: self, arguments: arguments)
	}
	
	/// ```
	/// let data = ["Empire State building", 1250]
	/// "Look at the %@. It is %d ft tall.".formatted(args: data)
	/// // results in: Look at the Empire State building. It is 1250 ft tall.
	/// ```
	public func formatted(args arguments: [CVarArg]) -> String {
		return String(format: self, arguments: arguments)
	}

	public var isBlank: Bool {
		return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
	
	public var isNotBlank: Bool {
		return !self.isBlank
	}
	
	/// Returns a value from 0.0 to 1.0 indicating the similarity to other string.
	public func levenshteinDistanceScoreTo(string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Float {
		
		guard !self.isEmpty && !string.isEmpty else { return 0.0 }
		if self.count == string.count && self == string { return 1.0 }
		
		var firstString = self
		var secondString = string
		
		if ignoreCase {
			firstString = firstString.lowercased()
			secondString = secondString.lowercased()
			if firstString.count == secondString.count && firstString == secondString { return 1.0 }
		}
		if trimWhiteSpacesAndNewLines {
			firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
			secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
			guard !firstString.isEmpty && !secondString.isEmpty else { return 0.0 }
			if firstString.count == secondString.count && firstString == secondString { return 1.0 }
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
	
	// Regular expressions
	
	public func matchesEntire(regex: String) -> Bool {
		let stringRange = self.startIndex..<self.endIndex
		return self.range(of: regex, options: .regularExpression) == stringRange
	}
	
	public func rangeOf(regex: String) -> Range<String.Index>? {
		return self.range(of: regex, options: .regularExpression)
	}
	public func valueInrangeOf(regex: String) -> String {
		guard let range = self.range(of: regex, options: .regularExpression) else { return self }
		return String(self[range])
	}
	
	public func matches(for regex: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex)
			let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
			let finalResult: [String] = results.compactMap {
				if let range = Range($0.range, in: self) {
					return String(self[range])
				}
				return nil
			}
			return finalResult
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}
	
	public func replacingFirstOcurrence(of target: String, with replaceString: String) -> String {
		if let range = self.range(of: target) {
			return self.replacingCharacters(in: range, with: replaceString)
		}
		return self
	} 
}
