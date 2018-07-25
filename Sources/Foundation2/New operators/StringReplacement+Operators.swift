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

infix operator ~~> : TernaryPrecedence
infix operator ~~|> : TernaryPrecedence

/// # Example
/// ```
/// // Result: Are you FINE?
///	"Are you OK?" ~~> ("OK" ==> "FINE")
/// ```
public func ~~> (original: String, other: (target: String, replacement: String)) -> String {
	return original.replacingOccurrences(of: other.target, with: other.replacement)
}

/// # Example
/// ```
/// // Result: Are you FINE?
///	var youOK = "Are you OK?"
/// youOK ~~|> ("OK" ==> "FINE")
/// // YouOK is now "Are you FINE?"
/// ```
public func ~~|> (original: inout String, other: (target: String, replacement: String)) -> String {
	original = original.replacingOccurrences(of: other.target, with: other.replacement)
	return original
}

infix operator ==> : TernaryPrecedence

public func ==> (target: String, replacement: String) -> (target: String, replacement: String) {
	return (target, replacement)
}

//

infix operator %%

/// Formats the string with the provided arguments
/// Example: `"Take %d, Mr. %@" %% [40, "things"]`
func %% (format: String, arguments: [CVarArg]) -> String {
	return String(format: format, arguments: arguments)
}

/*

//I just don't like this thing lol, but it works

infix operator **-**

public func **-**<T: ExpressibleByStringLiteral> (original: String, replacement: T) -> String {
	return original.replacingOccurrences(of: "\\*\\*\\w+\\*\\*", with: "\(replacement)", options: .regularExpression)
}

public func **-**<T: ExpressibleByStringLiteral> (original: String, replacement: [T]) -> String {
	
	var replacedString = original
	let matches = original.matches(for: "\\*\\*\\w+\\*\\*")
	var replacementIterator = replacement.enumerated().makeIterator()
	
	guard matches.count == replacement.count else { return original }
	
	for match in matches {
		if let nextReplacement = replacementIterator.next()?.element {
			replacedString = replacedString.replacingFirstOcurrence(of: match, with: "\(nextReplacement)")
		}
	}
	
	return replacedString
}*/
