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

#if canImport(UIKit)

import UIKit.UIColor

extension UIColor {
	
	/// Tries to use the wider gamut Display P3 if possible when creating a `UIColor`
	convenience init(displayP3ReadyRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0, forceP3IfAvailable: Bool = true) {
		if #available(iOS 10.0, *), forceP3IfAvailable {
			self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
		} else {
			self.init(red: red, green: green, blue: blue, alpha: alpha)
		}
	}
	
	/// Creates a color from a hex code
	convenience init(hex: UInt32, alpha: CGFloat = 1.0, useP3IfAvailable: Bool = true) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let blue = CGFloat(hex & 0xFF) / 255.0
		self.init(displayP3ReadyRed: red, green: green, blue: blue, alpha: alpha, forceP3IfAvailable: useP3IfAvailable)
	}
	
	/// Creates a color from a hex code, providing an rgb (0-255) value for the alpha channel
	convenience init(hex: UInt32, rgbAlpha: CGFloat, useP3IfAvailable: Bool = true) {
		self.init(hex: hex, alpha: rgbAlpha / 255.0, useP3IfAvailable: useP3IfAvailable)
	}
	
	/// Initializes a UIColor from RGBA values with ranges from 0 to 255
	convenience init(rgbRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 255, useP3IfAvailable: Bool = true) {
		self.init(displayP3ReadyRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha/255.0, forceP3IfAvailable: useP3IfAvailable)
	}
	
	/// Returns the components that form the current color in its different channels
	var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		return getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
	}
	
	/// Returns the components that form the current color in its different channels in RBBA values ranging from 0 to 255
	var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		return getRed(&r, green: &g, blue: &b, alpha: &a) ? (r * 255.0, g * 255.0, b * 255.0, a * 255.0) : nil
	}
}

#endif
