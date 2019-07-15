//
//  MenuSection.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


open class MenuSection {
    
    public let name: String
    public let icon: UIImage
	public var badge: String?
    public let storyboard: String
    public let viewController: String?
    public let accessibilityIdentifier: String?
    public var completion: ((UIViewController) -> Void)?

    open var modeButtonType: Bool?
    open var completionButtonType: (() -> Void)?
    open var iconURLString: String?
    
    lazy var sectionController: UIViewController = self.instantiateViewController()
    
    
	public init(name: String, icon: UIImage, badge: String? = nil, storyboard: String, viewController: String? = nil, accessibilityIdentifier: String?, completion: ((UIViewController) -> Void)? = nil, modeButtonType: Bool? = nil,  completionButtonType: (() -> Void)? = nil) {
        self.name = name
        self.icon = icon
		self.badge = badge
        self.storyboard = storyboard
        self.viewController = viewController
        self.accessibilityIdentifier = accessibilityIdentifier
        self.completion = completion
        self.modeButtonType = modeButtonType
        self.completionButtonType = completionButtonType
    }
    
    public init(name: String, iconURLString: String, badge: String? = nil, iconPlaceholder: UIImage?, storyboard: String, viewController: String? = nil, accessibilityIdentifier: String?, completion: ((UIViewController) -> Void)? = nil, modeButtonType: Bool? = nil,  completionButtonType: (() -> Void)? = nil) {
        self.name = name
        if let placeholder = iconPlaceholder {
            self.icon = placeholder
        } else {
            self.icon = UIImage()
        }
        self.iconURLString = iconURLString
		self.badge = badge
        self.storyboard = storyboard
        self.viewController = viewController
        self.accessibilityIdentifier = accessibilityIdentifier
        self.completion = completion
        self.modeButtonType = modeButtonType
        self.completionButtonType = completionButtonType
    }
    
    
    fileprivate func instantiateViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: self.storyboard, bundle: Bundle.main)
        let sectionVC: UIViewController
        
        if let viewControllerName = self.viewController {
            sectionVC = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        }
        else {
            sectionVC = storyboard.instantiateInitialViewController()!
        }
        self.completion?(sectionVC)
        return sectionVC
    }
    
}
