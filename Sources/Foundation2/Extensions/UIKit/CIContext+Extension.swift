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

#if os(iOS)
import class CoreImage.CIContext
import class OpenGLES.EAGL.EAGLContext
import func Metal.MTLDevice.MTLCreateSystemDefaultDevice

public extension CIContext {
	
	/// Returns the best `CIContext` possible. It will use `Metal` if available or OpenGL 3, or OpenGL 2 or the default context.
	///
	/// Using `CIContext.init()` has a similar effect because it tries to use the best options, but this ensures the following order: Metal > OpenGL 3 > OpenGL 2 > OpenGL 1 > default.
	public static var best: CIContext {
		return ContextManager.shared.bestContext
	}
	
	/// Returns a CIContext using `Metal` if possible. `CIContext.best` is the recommended way of using this.
	public static var metal: CIContext? {
		return ContextManager.metal
	}
	
	/// Returns the best `OpenGL` context. It is multithreaded too.
	public static var openGL: CIContext? {
		return ContextManager.metal
	}
	
	/// Returns true if the device can handle a CIContext by using `Metal`.
	public static var hasMetal: Bool {
		return ContextManager.shared.hasMetal
	}
}

internal class ContextManager {
	
	internal let bestContext: CIContext
	internal let hasMetal: Bool
	
	internal static let shared = ContextManager()
	
	fileprivate init() {
		if let validMetalContext = ContextManager.metal {
			self.hasMetal = true
			self.bestContext = validMetalContext
		}
		else if let validOpenGLContext =  ContextManager.openGL {
			self.bestContext = validOpenGLContext
			self.hasMetal = false
		}
		else {
			self.bestContext =  ContextManager.default
			self.hasMetal = false
		}
	}
	
	// - Convenience
	
	internal static var metal: CIContext? {
		if #available(iOS 9.0, *) {
			if let validMetalDevice = MTLCreateSystemDefaultDevice() {
				return CIContext(mtlDevice: validMetalDevice)
			}
		}
		return nil
	}
	
	internal static var eagl: EAGLContext? {
		
		var openGLContext: EAGLContext? = nil
		
		if let openGLContext3 = EAGLContext(api: .openGLES3) {
			openGLContext = openGLContext3
		}
		else if let openGLContext2 = EAGLContext(api: .openGLES2) {
			openGLContext = openGLContext2
		}
		else if let openGLContext1 = EAGLContext(api: .openGLES1) { // I assume OGL 1 is better than the default context (?)
			openGLContext = openGLContext1
		}
		openGLContext?.isMultiThreaded = true
		
		return openGLContext
	}
	
	internal static var openGL: CIContext? {
		if let validEAGLContext = self.eagl {
			return CIContext(eaglContext: validEAGLContext)
		}
		return nil
	}
	
	internal static var `default`: CIContext {
		return CIContext()
	}
}
#endif
