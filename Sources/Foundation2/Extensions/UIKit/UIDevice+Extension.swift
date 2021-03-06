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
#if !os(watchOS)
import class UIKit.UIDevice
import class UIKit.UIApplication
import struct Darwin.POSIX.sys.utsname
import func Darwin.POSIX.sys.utsname.uname
import var Darwin.POSIX.sys.utsname._SYS_NAMELEN
import struct Foundation.Data

public extension UIDevice {
	
	public var modelName: String {
		
		var sysinfo = utsname()
		uname(&sysinfo)
		
		if let bytes = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii) {
			return bytes.trimmingCharacters(in: .controlCharacters)
		}
		return "Unknown".localized
	}
	
	public var hasNotchOrExtraInsets: Bool {
		if #available(iOS 11.0, *) {
			return UIApplication.shared.windows.first?.safeAreaInsets != .zero
		}
		return false
	}
}
#endif
#endif
