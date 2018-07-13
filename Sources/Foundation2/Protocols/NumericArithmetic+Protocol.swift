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

public protocol NumericArithmetic: ExpressibleByIntegerLiteral {
	static func +(lhs: Self, rhs: Self) -> Self
	static func -(lhs: Self, rhs: Self) -> Self
	static func *(lhs: Self, rhs: Self) -> Self
	static func /(lhs: Self, rhs: Self) -> Self
	
	static func +=(lhs: inout Self, rhs: Self)
	static func -=(lhs: inout Self, rhs: Self)
	static func *=(lhs: inout Self, rhs: Self)
	static func /=(lhs: inout Self, rhs: Self)
}

public protocol ModulusArithmetic {
	static func %(lhs: Self, rhs: Self) -> Self
	static func %=(lhs: inout Self, rhs: Self)
}

public protocol SignedNumericArithmetic: NumericArithmetic {
	prefix static func -(value: Self) -> Self
}

public protocol BinaryIntegerArithmetic: NumericArithmetic, ModulusArithmetic, BinaryInteger { }
public protocol BinarySignedIntegerArithmetic: SignedNumericArithmetic, BinaryIntegerArithmetic { }
public protocol BinaryFloatingPointArithmetic: SignedNumericArithmetic, BinaryFloatingPoint { }
public protocol FloatingPointArithmetic: SignedNumericArithmetic, FloatingPoint {}

extension Int8   : BinarySignedIntegerArithmetic { }
extension Int16  : BinarySignedIntegerArithmetic { }
extension Int32  : BinarySignedIntegerArithmetic { }
extension Int64  : BinarySignedIntegerArithmetic { }
extension Int    : BinarySignedIntegerArithmetic { }
extension UInt8  : BinaryIntegerArithmetic { }
extension UInt16 : BinaryIntegerArithmetic { }
extension UInt32 : BinaryIntegerArithmetic { }
extension UInt64 : BinaryIntegerArithmetic { }
extension UInt   : BinaryIntegerArithmetic { }
extension Float32 : BinaryFloatingPointArithmetic, FloatingPointArithmetic { }
extension Float64 : BinaryFloatingPointArithmetic, FloatingPointArithmetic { }
#if arch(x86_64) || arch(i386)
extension Float80 : BinaryFloatingPointArithmetic, FloatingPointArithmetic { }
#endif
