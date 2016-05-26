//
//  Keyboard.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit


public protocol KeyboardAdaptable {
	
	func keyboardWillShow()
	func keyboardDidShow()
	
	func keyboardWillHide()
	func keyboardDidHide()
	
}


public extension KeyboardAdaptable where Self: UIViewController {
	
	// MARK: - Public Methods
	
	/// Must call this method on viewWillAppear
	public func startKeyboard() {
		self.manageKeyboardShowEvent()
		self.manageKeyboardHideEvent()
	}
	
	/// Must call this method on viewWillDisappear
	public func stopKeyboard() {
		Keyboard.removeObservers()
	}
	
	// MARK: - Optional Public Methods
	func keyboardWillShow(){}
	func keyboardDidShow(){}
	func keyboardWillHide(){}
	func keyboardDidHide(){}
	
	
	// MARK: - Private Helpers
	
	private func manageKeyboardShowEvent() {
		Keyboard.willShow { notification in
			guard let size = Keyboard.size(notification) else {
				return LogWarn("Couldn't get keyboard size")
			}
			
			self.keyboardWillShow()
			
			self.animateKeyboardChanges(notification,
				changes: {
					var appHeight = UIApplication.sharedApplication().keyWindow?.height()
					if self.navigationController != nil {
						appHeight = appHeight! - 64
					}
					self.view.setHeight(appHeight! - size.height)
				},
				onCompletion: {
					self.keyboardDidShow()
				}
			)
		}
	}
	
	private func manageKeyboardHideEvent() {
		Keyboard.willHide { notification in
			self.keyboardWillHide()
			
			self.animateKeyboardChanges(notification,
				changes:  {
					var appHeight = UIApplication.sharedApplication().keyWindow?.height()
					if self.navigationController != nil {
						appHeight = appHeight! - 64
					}
					self.view.setHeight(appHeight!)
				},
				onCompletion: {
					self.keyboardDidHide()
				}
			)
		}
	}
	
	private func animateKeyboardChanges(notification: NSNotification, changes: () -> Void, onCompletion: () -> Void) {
		let duration = Keyboard.animationDuration(notification)
		let curve = Keyboard.animationCurve(notification)
		
		UIView.animateWithDuration(
			duration,
			delay: 0,
			options: curve,
			animations: {
				changes()
				self.view.layoutIfNeeded()
			},
			completion: { _ in
				onCompletion()
			}
		)
	}
}


class Keyboard {
	
	private static var observers: [AnyObject] = []
	
	class func removeObservers() {
		for observer in self.observers {
			NSNotificationCenter.defaultCenter().removeObserver(observer)
		}
		
		self.observers.removeAll()
	}
	
	class func willShow(notificationHandler: (NSNotification) -> Void) {
		self.keyboardEvent(UIKeyboardWillShowNotification, notificationHandler: notificationHandler)
	}
	
	class func didShow(notificationHandler: (NSNotification) -> Void) {
		self.keyboardEvent(UIKeyboardDidShowNotification, notificationHandler: notificationHandler)
	}
	
	class func willHide(notificationHandler: (NSNotification) -> Void) {
		self.keyboardEvent(UIKeyboardWillHideNotification, notificationHandler: notificationHandler)
	}
	
	class func size(notification: NSNotification) -> CGSize? {
		guard
			let info = notification.userInfo,
			let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
			else { return nil }
		
		return frame.CGRectValue().size
	}
	
	class func animationDuration(notification: NSNotification) -> NSTimeInterval {
		guard
			let info = notification.userInfo,
			let value = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				LogWarn("Couldn't get keyboard animation duration")
				return 0
		}
		
		return value.doubleValue
	}
	
	class func animationCurve(notification: NSNotification) -> UIViewAnimationOptions {
		guard
			let info = notification.userInfo,
			let curveInt = info[UIKeyboardAnimationCurveUserInfoKey] as? Int,
			let curve = UIViewAnimationCurve(rawValue: curveInt)
			else {
				LogWarn("Couldn't get keyboard animation curve")
				return .CurveEaseIn
		}
		
		return curve.toOptions()
	}
	
	
	// MARK - Private Helpers
	
	private class func keyboardEvent(event: String, notificationHandler: (NSNotification) -> Void) {
		let observer = NSNotificationCenter.defaultCenter()
			.addObserverForName(
				event,
				object: nil,
				queue: .mainQueue(),
				usingBlock: notificationHandler
		)
		
		self.observers.append(observer)
	}
	
}

extension UIViewAnimationCurve {
	func toOptions() -> UIViewAnimationOptions {
		return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
	}
}