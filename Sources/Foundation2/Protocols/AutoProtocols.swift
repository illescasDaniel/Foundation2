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

public protocol AutoEquatable: Equatable {}
public extension AutoEquatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		for (lhsMirror, rhsMirror) in zip(Mirror(reflecting: lhs).children, Mirror(reflecting: rhs).children) {
			if ("\(lhsMirror.value)" != "\(rhsMirror.value)") {
				return false
			}
		}
		return true
	}
}

public protocol AutoCustomStringConvertible: CustomStringConvertible {}
public extension AutoCustomStringConvertible {
	public var description: String {
		let labelsAndValues: [String] = Mirror(reflecting: self).children.map { child in
			var modifiedValue = child.value
			if Mirror(reflecting: modifiedValue).subjectType == String.self {
				modifiedValue = "\"\(modifiedValue)\""
			}
			return "\(child.label ?? "Unknown"): \(modifiedValue)"
		}
		return String(describing: Self.self) + "(" + labelsAndValues.joined(separator: ", ") + ")"
	}
}

public protocol AutoComparable: Comparable {}
public extension AutoComparable {
	public static func <(lhs: Self, rhs: Self) -> Bool {
		for (lhsMirror, rhsMirror) in zip(Mirror(reflecting: lhs).children, Mirror(reflecting: rhs).children) {
			if let lhsValueNumber = NumberFormatter(decimalSeparator: ".").number(from: "\(lhsMirror.value)"),
				let rhsValueNumber = NumberFormatter(decimalSeparator: ".").number(from: "\(rhsMirror.value)") {
				return lhsValueNumber.compare(rhsValueNumber) == .orderedAscending
			}
		}
		return false
	}
}
