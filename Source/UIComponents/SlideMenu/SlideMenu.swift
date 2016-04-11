//
//  SlideMenu.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public class SlideMenu {
    
    public static let shared = SlideMenu()
    
    
    public func menuVC() -> UIViewController {
        guard let menuVC = SlideMenuVC.menuVC() else {
            LogWarn("Couldn't instantiate menu")
            return UIViewController()
        }
        
        return menuVC
    }
    
}