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

/// Should only be used with your own custom classes
public protocol CustomInitiable { init() }

public protocol Initiable { init() }

extension Decimal: Initiable { }
extension Int8   : Initiable { }
extension Int16  : Initiable { }
extension Int32  : Initiable { }
extension Int64  : Initiable { }
extension Int    : Initiable { }
extension UInt8  : Initiable { }
extension UInt16 : Initiable { }
extension UInt32 : Initiable { }
extension UInt64 : Initiable { }
extension UInt   : Initiable { }
extension Float32 : Initiable { }
extension Float64 : Initiable { }
#if arch(x86_64) || arch(i386)
extension Float80 : Initiable { }
#endif
extension String: Initiable {}
extension NSObject: Initiable {}
// extension UIView: Initiable {} (already conforms because it inherits (at least for now) from NSObject)
