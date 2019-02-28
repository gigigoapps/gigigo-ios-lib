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
        self.manageKeyboardChangeFrameEvent()
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
    func keyboardChangeFrame(){}
	
	
	// MARK: - Private Helpers
    
    fileprivate func manageKeyboardChangeFrameEvent() {
        Keyboard.willChange { notification in
            guard let size = Keyboard.size(notification) else {
                return LogWarn("Couldn't get keyboard size")
            }
            
            self.keyboardChangeFrame()
            
            self.animateKeyboardChanges(notification,
                                        changes: {
                                            if var appHeight = UIApplication.shared.keyWindow?.height() {
                                                if self.navigationController != nil {
                                                    appHeight = appHeight - (self.navigationController?.navigationBar.frame.size.height ?? 0)
                                                }
                                                if #available(iOS 11.0, *) {
                                                    let safeAreaInsetsBottomHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
                                                    let safeAreaInsetsTopHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
                                                    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                                                    self.view.setHeight(appHeight - safeAreaInsetsBottomHeight + safeAreaInsetsTopHeight - statusBarHeight - size.height)
                                                } else {
                                                    self.view.setHeight(appHeight - size.height)
                                                }
                                            }
            },
                                        onCompletion: {
                                            self.keyboardChangeFrame()
            }
            )
        }
    }
	
	fileprivate func manageKeyboardShowEvent() {
		Keyboard.willShow { notification in
			guard let size = Keyboard.size(notification) else {
				return LogWarn("Couldn't get keyboard size")
			}
			
			self.keyboardWillShow()
			
			/* self.animateKeyboardChanges(notification,
				changes: {
                    if var appHeight = UIApplication.shared.keyWindow?.height() {
                        if self.navigationController != nil {
                            appHeight = appHeight - (self.navigationController?.navigationBar.frame.size.height ?? 0)
                        }
                        if #available(iOS 11.0, *) {
                            let safeAreaInsetsBottomHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
                            let safeAreaInsetsTopHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
                            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                            self.view.setHeight(appHeight - safeAreaInsetsBottomHeight + safeAreaInsetsTopHeight - statusBarHeight - size.height)
                        } else {
                            self.view.setHeight(appHeight - size.height)
                        }
                    }
				},
				onCompletion: {
					self.keyboardDidShow()
				}
			) */
		}
	}
	
	fileprivate func manageKeyboardHideEvent() {
		Keyboard.willHide { notification in
			self.keyboardWillHide()
			
			self.animateKeyboardChanges(notification,
				changes:  {
                    if var appHeight = UIApplication.shared.keyWindow?.height() {
                        if self.navigationController != nil {
                            appHeight = appHeight - (self.navigationController?.navigationBar.frame.size.height ?? 0)
                        }
                        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                        self.view.setHeight(appHeight - statusBarHeight)
                    }
				},
				onCompletion: {
					self.keyboardDidHide()
				}
			)
		}
	}
	
	fileprivate func animateKeyboardChanges(_ notification: Notification, changes: @escaping () -> Void, onCompletion: @escaping () -> Void) {
		let duration = Keyboard.animationDuration(notification)
		let curve = Keyboard.animationCurve(notification)
		
		UIView.animate(
			withDuration: duration,
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
	
	fileprivate static var observers: [AnyObject] = []
	
	class func removeObservers() {
		for observer in self.observers {
			NotificationCenter.default.removeObserver(observer)
		}
		
		self.observers.removeAll()
	}
	
	class func willShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardWillShowNotification.rawValue, notificationHandler: notificationHandler)
	}
	
	class func didShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardDidShowNotification.rawValue, notificationHandler: notificationHandler)
	}
	
	class func willHide(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardWillHideNotification.rawValue, notificationHandler: notificationHandler)
	}
    
    class func willChange(_ notificationHandler: @escaping (Notification) -> Void) {
        self.keyboardEvent(UIResponder.keyboardWillChangeFrameNotification.rawValue, notificationHandler: notificationHandler)
    }
	
	class func size(_ notification: Notification) -> CGSize? {
		guard
			let info = (notification as NSNotification).userInfo,
			let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
			else { return nil }
		
		return frame.cgRectValue.size
	}
	
	class func animationDuration(_ notification: Notification) -> TimeInterval {
		guard
			let info = (notification as NSNotification).userInfo,
			let value = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				LogWarn("Couldn't get keyboard animation duration")
				return 0
		}
		
		return value.doubleValue
	}
	
    class func animationCurve(_ notification: Notification) -> UIView.AnimationOptions {
		guard
			let info = (notification as NSNotification).userInfo,
            let curveInt = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveInt)
			else {
				LogWarn("Couldn't get keyboard animation curve")
				return .curveEaseIn
		}
		
		return curve.toOptions()
	}
	
	
	// MARK - Private Helpers
	
	fileprivate class func keyboardEvent(_ event: String, notificationHandler: @escaping (Notification) -> Void) {
		let observer = NotificationCenter.default
			.addObserver(
				forName: NSNotification.Name(rawValue: event),
				object: nil,
				queue: OperationQueue.main,
				using: notificationHandler
		)
        
		self.observers.append(observer)
	}
	
}

extension UIView.AnimationCurve {
    func toOptions() -> UIView.AnimationOptions {
        return UIView.AnimationOptions(rawValue: UInt(rawValue << 16))
	}
}
