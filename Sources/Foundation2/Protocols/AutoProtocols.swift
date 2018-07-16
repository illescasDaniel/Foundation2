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

import class Foundation.NSNumberFormatter.NumberFormatter

/// Compares all properties of the object, including the properties of the objects of the properties too (making a deep search).
///
/// When one value of `lhs` doesn't match with its corresponding in `rhs`, it returns `false`.
///
/// If `lhs` and `rhs` are classes and are the exact same object (`===`) it will return `true` without further comparisons.
/// - Complexity:
///		* Ω(1) when is the same object.
///		* O(*n*) worst case trying to find a property that is different before making the deep search.
///		* Probably not a good idea to use on classes with lots of properties which are objects of classes which has also other properties, because it will try to make a deep search of all the subproperties until finds one which value differs from `rhs`.
public protocol AutoEquatable: Equatable {}
public extension AutoEquatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		guard (lhs as AnyObject) !== (rhs as AnyObject) else { return true }
		for (lhsChildren, rhsChildren) in zip(Mirror(reflecting: lhs).children, Mirror(reflecting: rhs).children) {
			if "\(lhsChildren.value)" != "\(rhsChildren.value)" { return false }
		}
		for (lhsChildren, rhsChildren) in zip(Mirror.deepChildren(of: lhs), Mirror.deepChildren(of: rhs)) {
			if "\(lhsChildren.value)" != "\(rhsChildren.value)" { return false }
		}
		return true
	}
}

public protocol AutoCustomDebugStringConvertible: CustomDebugStringConvertible {}
public extension AutoCustomDebugStringConvertible {
	public var debugDescription: String {
		let className = String(describing: Self.self)
		let labelsAndValues = Mirror.deepChildren(of: self).lazy.map {
			let childValue = Mirror(reflecting: $0.value).subjectType == String.self ? "\"\($0.value)\"" : $0.value
			return "\($0.key.replacingOccurrences(of: className + ".", with: "")): \(childValue)"
			}.joined(separator: ", ")
		return String(describing: Self.self) + "(" + labelsAndValues + ")"
	}
}

// THESE below might not be very accurate

/// Offers a basic representation of the properties inside the type. For a more detailed representation use `AutoCustomDebugStringConvertible`.
public protocol AutoCustomStringConvertible: CustomStringConvertible {}
public extension AutoCustomStringConvertible {
	public var description: String {
		
		let labelsAndValues: [String] = Mirror(reflecting: self).children.map { child in
			var childValue = child.value
			if Mirror(reflecting: childValue).subjectType == String.self {
				childValue = "\"\(childValue)\""
			}
			let childValueString = "\(childValue)".split(separator: ".").last
			return "\(child.label ?? "Unknown"): \(childValueString ?? childValue)"
		}
		return String(describing: Self.self) + "(" + labelsAndValues.joined(separator: ", ") + ")"
	}
}

/// Takes the first property of `lhs` that is a number and compare it with the corresponding value in `rhs`.
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
