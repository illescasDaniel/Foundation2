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

import Foundation.NSString

public extension CustomStringConvertible {
	public var description: String {
		return String(describing: Self.self) + "(" + Mirror(reflecting: self).children.map({ ($0 ?? "Unknown") + ": \($1)" }).joined(separator: ", ") + ")"
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
		return (self as NSString).deletingPathExtension
	}
	
	/// Retuns a localized string with an empty comment
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}
