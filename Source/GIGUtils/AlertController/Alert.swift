//
//  GIGMainAlert.swift
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 2/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

protocol AlertInterface {
    func show()
    func addDefaultButton(title: String, usingAction:(String -> Void))
    func addCancelButton(title: String, usingAction:(String -> Void))
    func addDestructiveButton(title: String, usingAction:(String -> Void))
}

public class Alert: NSObject {
    
    internal var interface: AlertInterface!
    
    internal override init() {
        interface = AlertController()
    }
    
    public init(title: String, message: String) {
        interface = AlertController(title: title, message: message)
    }
    
    public func show() {
        self.interface.show()
    }
    
    public func addDefaultButton(title: String, usingAction:(String -> Void)) {
        self.interface.addDefaultButton(title, usingAction: usingAction)
    }
    
    public func addCancelButton(title: String, usingAction:(String -> Void)) {
        self.interface.addCancelButton(title, usingAction: usingAction)
    }
    
    public func addDestructiveButton(title: String, usingAction:(String -> Void)) {
        self.interface.addDestructiveButton(title, usingAction: usingAction)

    }
}
