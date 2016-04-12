//
//  MenuSection.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public struct MenuSection {
    
    public let name: String
    public let icon: UIImage
    public let storyboard: String
    public let viewController: String?
    
    lazy var sectionController: UIViewController! = self.instantiateViewController()
    
    
    public init(name: String, icon: UIImage, storyboard: String, viewController: String) {
        self.name = name
        self.icon = icon
        self.storyboard = storyboard
        self.viewController = viewController
    }
    
    
    private func instantiateViewController() -> UIViewController? {
        let storyboard = UIStoryboard(name: self.storyboard, bundle: NSBundle.mainBundle())
        let sectionVC: UIViewController?
        
        if let viewControllerName = self.viewController {
            sectionVC = storyboard.instantiateViewControllerWithIdentifier(viewControllerName)
        }
        else {
            sectionVC = storyboard.instantiateInitialViewController()
        }
        
        return sectionVC
    }
    
}
