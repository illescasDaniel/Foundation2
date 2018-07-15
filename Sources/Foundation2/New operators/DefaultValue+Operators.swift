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

/// Provides a default value for most Optional values.
postfix operator ..

public postfix func .. <T: Numeric>(lhs: T?) -> T {
	return lhs ?? 0
}
public postfix func .. <T: Initiable>(lhs: T?) -> T { // Might give some issue with types that conforms to Initiable or other but not sure
	return lhs ?? T()
}
public postfix func .. (lhs: String?) -> String {
	return lhs ?? ""
}
public postfix func .. <T: ExpressibleByStringLiteral>(lhs: T?) -> T {
	return lhs ?? ""
}
public postfix func .. <T: ExpressibleByIntegerLiteral>(lhs: T?) -> T {
	return lhs ?? 0
}
public postfix func .. <T: ExpressibleByFloatLiteral>(lhs: T?) -> T {
	return lhs ?? 0.0
}
public postfix func .. <T: ExpressibleByArrayLiteral>(lhs: T?) -> T {
	return lhs ?? []
}
public postfix func .. <T: ExpressibleByBooleanLiteral>(lhs: T?) -> T {
	return lhs ?? false
}
public postfix func .. <T: ExpressibleByDictionaryLiteral>(lhs: T?) -> T {
	return lhs ?? [:]
}

/// Changes its value for the default one if is `nil`, then it returns itself
postfix operator ..|

@discardableResult
public postfix func ..| <T: Numeric>(lhs: inout T?) -> T {
	if lhs == nil { lhs = 0 }
	return lhs..
}
@discardableResult
public postfix func ..| <T: Initiable>(lhs: inout T?) -> T {
	if lhs == nil { lhs = T() }
	return lhs..
}
@discardableResult
public postfix func ..| (lhs: inout String?) -> String {
	if lhs == nil { lhs = "" }
	return lhs..
}
@discardableResult
public postfix func ..| <T: ExpressibleByStringLiteral>(lhs: inout T?) -> T {
	if lhs == nil { lhs = "" }
	return lhs..
}
@discardableResult
public postfix func ..| <T: ExpressibleByIntegerLiteral>(lhs: inout T?) -> T {
	if lhs == nil { lhs = 0 }
	return lhs..
}
@discardableResult
public postfix func ..| <T: ExpressibleByFloatLiteral>(lhs: inout T?) -> T {
	if lhs == nil { lhs = 0.0 }
	return lhs..
}
@discardableResult
public postfix func ..| <T: ExpressibleByArrayLiteral>(lhs: inout T?) -> T {
	if lhs == nil { lhs = [] }
	return lhs..
}
@discardableResult
public postfix func ..| <T: ExpressibleByBooleanLiteral>(lhs: inout T?) -> T {
	if lhs == nil { lhs = false }
	return lhs..
}
@discardableResult
public postfix func ..| <T: ExpressibleByDictionaryLiteral>(lhs: inout T?) -> T {
	if lhs == nil { lhs = [:] }
	return lhs..
}
