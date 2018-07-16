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

public extension Mirror {
	
	public static func deepChildren(of originalValue: Any) -> [String: Any] {
		
		var dictionary: [String: Any] = [:]
		
		for (label, value) in Mirror(reflecting: originalValue).children {
			
			var originalValueType = String(describing: originalValue.self).split(separator: ".") as [Substring]
			if originalValueType.count > 1 { originalValueType = [Substring](originalValueType.dropFirst()) }
			let name = "\(originalValueType.joined(separator: ".")).\(label ?? "\(value)")"
			
			/*let originalValueType = String(describing: originalValue.self)
			let name = "\(originalValueType).\(label ?? "\(value)")"*/
			
			if !Mirror(reflecting: value).children.isEmpty {
				dictionary[name] = Mirror.deepChildren(of: value)
			} else {
				//dictionary[label ?? "\(value)"] = value
				dictionary[name] = value
			}
		}
		return dictionary
	}
}
