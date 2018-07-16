/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel/HapticFeedbackPlayer>

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
import UIKit

public extension DispatchTime {
	public static func +=(lhs: inout DispatchTime, interval: DispatchTimeInterval) {
		lhs = lhs + interval
	}
}

#if os(iOS)
@available(iOS 10.0, *)
public typealias FeedbackGenerator = HapticFeedback.FeedbackGenerator

/// Create simple haptic feedback patters easily.
/// # Usage
/**
	## Example 1:
	```
	HapticFeedback()
		.selectionChanged.then(after: .milliseconds(200))
		.selectionChanged.then(after: .milliseconds(200))
		.selectionChanged.then(after: .milliseconds(200))
	.play()
	```
 	## Example 2:
	```
	HapticFeedback(after: .milliseconds(100))
		.selectionChanged.then(after: .milliseconds(200))
	.replay(times: 3)
	```
 	## Example 3:
	```
	HapticFeedback()
		.selectionChanged.replay(times: 2, withInterval: .milliseconds(300)).then(after: .milliseconds(150))
		.impactOcurredWith(style: .light).then(after: .seconds(1))
		.notificationOcurredOf(type: .success)
	.play()
	```
*/
@available(iOS 10.0, *)
public final class HapticFeedback {
	
	fileprivate enum HapticEffect {
		case none
		case selectionChanged
		case lightImpact
		case mediumImpact
		case heavyImpact
		case notificationSuccess
		case notificationError
		case notificationWarning
	}
	
	public struct FeedbackGenerator {
		
		public static let lightImpact = UIImpactFeedbackGenerator(style: .light)
		public static let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
		public static let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
		public static let notification = UINotificationFeedbackGenerator()
		public static let selection = UISelectionFeedbackGenerator()

		public static func impactOcurredWith(style: UIImpactFeedbackStyle) {
			switch(style) {
			case .light: FeedbackGenerator.lightImpact.impactOccurred()
			case .medium: FeedbackGenerator.mediumImpact.impactOccurred()
			case .heavy: FeedbackGenerator.heavyImpact.impactOccurred()
			}
		}
		
		public static func notificationOcurredOf(type: UINotificationFeedbackType) {
			FeedbackGenerator.notification.notificationOccurred(type)
		}
		
		public static func selectionChanged() {
			FeedbackGenerator.selection.selectionChanged()
		}
	}
	
	private var accumulatedTime: DispatchTime = .now()
	private var lastHaptic: HapticEffect = .none
	private var lastInterval: DispatchTimeInterval = .milliseconds(0)
	
	public init() {}
	
	public init(after: DispatchTimeInterval) {
		self.accumulatedTime += after
	}
	
	public var selectionChanged: HapticFeedback {
		
		self.lastHaptic = .selectionChanged
		
		FeedbackGenerator.selection.prepare()
		
		DispatchQueue.main.asyncAfter(deadline: self.accumulatedTime) {
			FeedbackGenerator.selectionChanged()
		}
		return self
	}
	
	public func impactOcurredWith(style: UIImpactFeedbackStyle) -> HapticFeedback {
		
		switch style {
		case .light: FeedbackGenerator.lightImpact.prepare(); self.lastHaptic = .lightImpact
		case .medium: FeedbackGenerator.mediumImpact.prepare(); self.lastHaptic = .mediumImpact
		case .heavy: FeedbackGenerator.heavyImpact.prepare(); self.lastHaptic = .heavyImpact
		}
		
		DispatchQueue.main.asyncAfter(deadline: self.accumulatedTime) {
			FeedbackGenerator.impactOcurredWith(style: style)
		}
		return self
	}
	
	public func notificationOcurredOf(type: UINotificationFeedbackType) -> HapticFeedback {
		
		switch type {
		case .success: self.lastHaptic = .notificationSuccess
		case .error: self.lastHaptic = .notificationError
		case .warning: self.lastHaptic = .notificationWarning
		}
		
		FeedbackGenerator.notification.prepare()
		
		DispatchQueue.main.asyncAfter(deadline: self.accumulatedTime) {
			FeedbackGenerator.notificationOcurredOf(type: type)
		}
		return self
	}
	
	public func then(after: DispatchTimeInterval) -> HapticFeedback {
		self.accumulatedTime += after
		self.lastInterval = after
		return self
	}
	
	public var then: HapticFeedback {
		return self
	}
	
	public func replay(times: UInt) {
		
		guard times > 0 else { return }
		
		for _ in 0..<times-1 {
			
			switch self.lastHaptic {
			case .none: break
			case .selectionChanged: let _ = self.selectionChanged
			case .lightImpact: let _ = self.impactOcurredWith(style: .light)
			case .mediumImpact: let _ = self.impactOcurredWith(style: .medium)
			case .heavyImpact: let _ = self.impactOcurredWith(style: .heavy)
			case .notificationSuccess: let _ = self.notificationOcurredOf(type: .success)
			case .notificationError: let _ = self.notificationOcurredOf(type: .error)
			case .notificationWarning: let _ = self.notificationOcurredOf(type: .warning)
			}
			
			self.accumulatedTime += self.lastInterval
		}
		
		self.play()
	}
	
	public func replay(times: UInt, withInterval interval: DispatchTimeInterval) -> HapticFeedback {
		
		guard times > 0 else { return self }
		
		for _ in 0..<times-1 {
			
			self.accumulatedTime += interval
			
			switch self.lastHaptic {
			case .none: break
			case .selectionChanged: let _ = self.selectionChanged
			case .lightImpact: let _ = self.impactOcurredWith(style: .light)
			case .mediumImpact: let _ = self.impactOcurredWith(style: .medium)
			case .heavyImpact: let _ = self.impactOcurredWith(style: .heavy)
			case .notificationSuccess: let _ = self.notificationOcurredOf(type: .success)
			case .notificationError: let _ = self.notificationOcurredOf(type: .error)
			case .notificationWarning: let _ = self.notificationOcurredOf(type: .warning)
			}
		}
		
		return self
	}
	
	public func play() {
		self.accumulatedTime = .now()
	}
}

#endif
#endif
