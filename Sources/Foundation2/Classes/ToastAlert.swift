/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel/ToastAlert>

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
import UIKit

/// A basic toast-like alert, similar to what to find in Android.
///
/// # Usage
/// ## Example 1:
/**
	```
	ToastAlert.present(message: "Hello", withLength: .short, in: self)
	```
	## Example 2:
	```
	ToastAlert
		.makeWith(message: "Look!", length: .init(timeInterval: .milliseconds(780)))
		.present(in: self, onCompletion: {
			print("presented")
		})
	```
	## Asynchronous example
	```
	ToastAlert.present(onSuccess: "Saved", onError: "Error while saving", withLength: .short,
						playHapticFeedback: true, in: self, operation: {
	// do something that takes time to complete, return if the operation succeeded
		return SetOfTopics.shared.save(topic: TopicEntry(name: quiz.options?.name ?? "", content: quiz))
	}, onCompletion: {
		print("completed")
	})
	```
*/
public struct ToastAlert {
	
	public struct Length {
		let timeInterval: DispatchTimeInterval
		static let short = Length(timeInterval: .milliseconds(250))
		static let long = Length(timeInterval: .milliseconds(500))
	}
	
	private let alertController: UIAlertController
	private let length: ToastAlert.Length
	
	@discardableResult
	public static func present(message: String, withLength length: ToastAlert.Length, in viewController: UIViewController, onCompletion: @escaping () -> () = {}) -> Bool {
		return ToastAlert.makeWith(message: message, length: length).present(in: viewController, onCompletion: onCompletion)
	}
	
	/// You must put UI code inside `DispatchQueue.main.async {}` in `operation` parameter
	public static func present(onSuccess onSuccessMessage: String, onError onErrorMessage: String, withLength length: ToastAlert.Length,
						playHapticFeedback: Bool = true, in viewController: UIViewController,
						operation: @escaping () -> Bool, onCompletion: @escaping () -> () = {}) {
		
		DispatchQueue.global().async {
			let operationSuccess = operation()
			DispatchQueue.main.async {
				#if os(iOS)
				if #available(iOS 10.0, *), playHapticFeedback {
					UINotificationFeedbackGenerator().notificationOccurred(operationSuccess ? .success : .error)
				}
				#endif
				ToastAlert.makeWith(message: operationSuccess ? onSuccessMessage : onErrorMessage, length: length).present(in: viewController, onCompletion: onCompletion)
			}
		}
	}
	
	/// You must put UI code inside `DispatchQueue.main.async {}` in `operation` parameter
	public static func presentAsynchronously(message: String, withLength length: ToastAlert.Length, in viewController: UIViewController,
									  operation: @escaping () -> (), onCompletion: @escaping () -> () = {}) {
		
		DispatchQueue.global().async {
			operation()
			DispatchQueue.main.async {
				ToastAlert.makeWith(message: message, length: length).present(in: viewController, onCompletion: onCompletion)
			}
		}
	}
	
	public static func makeWith(message: String, length: ToastAlert.Length) -> ToastAlert {
		return ToastAlert(alertController: UIAlertController(title: nil, message: NSLocalizedString(message, comment: ""), preferredStyle: .alert),
						  length: length)
	}
	
	@discardableResult
	public func present(in viewController: UIViewController, onCompletion: @escaping () -> () = {}) -> Bool {
		
		guard viewController.presentedViewController == nil else { return false }
		
		viewController.present(self.alertController, animated: true) {
			DispatchQueue.main.asyncAfter(deadline: .now() + self.length.timeInterval) {
				self.alertController.dismiss(animated: true, completion: onCompletion)
			}
		}
		return true
	}
}
#endif
#endif
