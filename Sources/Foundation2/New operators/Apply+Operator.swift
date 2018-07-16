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

infix operator =>: AssignmentPrecedence

/// # Usage
///	```
/// let daniel = Human() => { it in
///	    it.name = "Daniel"
///	    it.age = 10
///	}
/// ```
/// ---
/// Reference: [https://stackoverflow.com/a/43831363]()
/// - Parameters:
///   - lhs: The object you want to modify.
///   - rhs: The closure in which the object is modified.
/// - Returns: The modified object.
/// - Requires:
///		- `T` must be a class in order to modify its values.
///		- `T` obviosly needs to have a default empty constructor.
public func =><T>(lhs: T, rhs: (T) ->()) -> T {
	rhs(lhs)
	return lhs
}

/// # Usage
///	```
/// let daniel = with(Human()) { it in
///	    it.name = "Daniel"
///	    it.age = 10
///	}
/// ```
/// ---
/// More info: [https://stackoverflow.com/a/43831363]()
/// - Parameters:
///   - lhs: The object you want to modify.
///   - rhs: The closure in which the object is modified.
/// - Returns: The modified object.
/// - Requires:
///		- `T` must be a class in order to modify its values.
///		- `T` obviosly needs to have a default empty constructor.
@discardableResult
public func with<T>(_ lhs: T, _ rhs: (T) ->()) -> T {
	rhs(lhs)
	return lhs
}

//

/// # Usage
/**
	class Person: Initiable {
		var name: String = ""
		var age: UInt8 = 0
		required init() {}
	}

	let daniel = Person.self => { it in
		it.name = "Daniel"
		it.age = 21
	}
	print(daniel.name)
*/
public func =><T: CustomInitiable>(lhs: T.Type, rhs: (T) ->()) -> T {
	let initializedlhs = lhs.init()
	rhs(initializedlhs)
	return initializedlhs
}
