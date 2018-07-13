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
#if os(watchOS)
#else
import UIKit.UIImage

public extension UIImage {
	
	/// Initializes an UIImage from a URL containing an image
	public convenience init?(contentsOf url: URL?) {
		
		guard let validURL = url else { return nil }
		
		if let imageData = try? Data(contentsOf: validURL) {
			self.init(data: imageData)
			return
		}
		return nil
	}
	
	/// Manages the content of a remote image
	public static func manageContentsOf(_ url: URL?, completionHandler: @escaping ((UIImage, URL?) -> ()), errorHandler: (() -> ())? = nil) {
		DispatchQueue.global().async {
			if let validImage = UIImage(contentsOf: url) {
				DispatchQueue.main.async {
					completionHandler(validImage, url)
				}
			} else {
				DispatchQueue.main.async {
					errorHandler?()
				}
			}
		}
	}
	
	public var isLandscape: Bool {
		return self.size.width > self.size.height
	}
	
	public var isPortrait: Bool {
		return !self.isLandscape
	}
	
	@available(iOS 10.0, *)
	public func resizedImage(to targetSize: CGSize) -> UIImage {
		
		let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
		
		let renderFormat: UIGraphicsImageRendererFormat
		if #available(iOS 11.0, tvOS 11.0, *) {
			renderFormat = UIGraphicsImageRendererFormat.preferred()
		} else {
			renderFormat = UIGraphicsImageRendererFormat.default()
		}
		//renderFormat.opaque = true
		let renderer = UIGraphicsImageRenderer(size: targetSize, format: renderFormat)
		let newImage = renderer.image { context in
			self.draw(in: rect)
		}
		
		return newImage
	}
	
	public func resizedWith(width: CGFloat) -> UIImage? {
		
		let scale = width / self.size.width
		let newHeight = self.size.height * scale
		
		UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
		self.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	public func resizedWith(height: CGFloat) -> UIImage? {
		
		let scale = height / self.size.height
		let newWidth = self.size.width * scale
		
		UIGraphicsBeginImageContext(CGSize(width: newWidth, height: height))
		self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: height))
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	/// Returns the average color of the whole image, or nil if an error ocurred (the alpha channel is 1.0).
	public var averageColor: UIColor? {
		return self.averageColor(alphaAverage: false)
	}
	
	/// Returns the average color of the whole image, or nil if an error ocurred
	/// - Parameters:
	/// 	- alphaAverage: Indicated whether it uses the average alpha of the image or nor (Not recommended in most cases).
	public func averageColor(alphaAverage: Bool) -> UIColor? {
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		
		#if os(iOS)
		let context = CIContext.best
		#else
		let context = CIContext()
		#endif
		
		var validInputImage = CIImage()
		
		if let validCIImage = self.ciImage {
			validInputImage = validCIImage
		}
		else if let cgImage = self.cgImage {
			validInputImage = CIImage(cgImage: cgImage)
		}
		else { return nil }
		
		let extent = validInputImage.extent
		let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
		
		if let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: validInputImage, kCIInputExtentKey: inputExtent]), let outputImage = filter.outputImage {
			
			let outputExtent = outputImage.extent
			if outputExtent.size.width == 1 && outputExtent.size.height == 1 {
				context.render(outputImage,
							   toBitmap: &bitmap, rowBytes: 4,
							   bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
							   format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
				
				return alphaAverage
						? UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
						: UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: 1.0)
			}
		}
		return nil
	}
}
#endif
#endif
