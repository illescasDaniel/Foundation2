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
import class UIKit.UIAlertController
import enum UIKit.UIAlertActionStyle
import class UIKit.UIAlertAction
import class UIKit.UIViewController

public extension UIAlertController {
	/// Quickly adds an action to your `UIAlertController`
	/**
	(Original description)
	
	Create and return an action with the specified title and behavior.
	Actions are enabled by default when you create them.
	
	- Parameters:
		- title: The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil, except in a tvOS app where a nil title may be used with cancel.
		- style: Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in UIAlertActionStyle.
		- handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
	- Returns: A new alert action object.
	- SDKs:	iOS 8.0+, tvOS 9.0+
	*/
	@discardableResult
	public func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
		let alertAction = UIAlertAction(title: title, style: style, handler: handler)
		self.addAction(alertAction)
		return self
	}
	
	public func present(in viewController: UIViewController, completion: (() -> Void)? = nil) {
		viewController.present(self, animated: true, completion: completion)
	}
}
#endif
#endif
