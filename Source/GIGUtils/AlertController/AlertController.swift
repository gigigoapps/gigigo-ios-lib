//
//  File.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 1/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)
public class AlertController: NSObject, AlertInterface {
    
    var alert: UIAlertController
    
    public override init() {
        self.alert = UIAlertController()
    }
    
    public init(title: String, message: String) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    }
    
    internal init(title: String, message: String, style:UIAlertControllerStyle) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: style)
    }
    
    public func show() {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(self.alert, animated: true) {}
    }
    
    public func addDefaultButton(title: String, usingAction:(String -> Void)?) {
        let action = UIAlertAction(title: title, style: .Default) { action in
			guard let usingAction = usingAction else { return }
            usingAction(action.title!)
        }
        self.alert.addAction(action)
    }
    
    public func addCancelButton(title: String, usingAction:(String -> Void)?) {
        let action = UIAlertAction(title: title, style: .Cancel) { action in
			guard let usingAction = usingAction else { return }
            usingAction(action.title!)
        }
        self.alert.addAction(action)
    }
    
    public func addDestructiveButton(title: String, usingAction:(String -> Void)?) {
        let action = UIAlertAction(title: title, style: .Destructive) { action in
			guard let usingAction = usingAction else { return }
            usingAction(action.title!)
        }
        self.alert.addAction(action)
    }
}