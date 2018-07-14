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

public extension Swift.Collection {
	/// A custom subscript operator to safely get an element.
	///
	/// # Usage
	/// ```
	///	if let validElement = numbers[safe: 130] {
	/// 	// ...
	/// }
	/// ```
	/// - Parameter index: The position of the element to access.
	/// - Returns: The element if it is found, in other case `nil`.
	public subscript (safe index: Index) -> Element? {
		return self.indices.contains(index) ? self[index] : nil
	}
}

public extension Swift.Collection where Element: Numeric {
	/// [1,2,3] => 6
	public var sum: Element {
		return self.reduce(0, +)
	}
}
