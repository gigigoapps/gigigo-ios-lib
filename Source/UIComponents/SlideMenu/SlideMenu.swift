//
//  SlideMenu.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


open class SlideMenu {
	
	open var sectionSelectorColor: UIColor = UIColor.white {
		didSet {
			SlideMenuConfig.shared.sectionSelectorColor = self.sectionSelectorColor
		}
	}
	
	open var menuBackgroundColor: UIColor = UIColor.black {
		didSet {
			SlideMenuConfig.shared.menuBackgroundColor = self.menuBackgroundColor
		}
    }
    
    open var menuHighlightColor: UIColor = UIColor.white {
        didSet {
            SlideMenuConfig.shared.menuHighlightColor = self.menuHighlightColor
        }
    }
    
    open var menuTitleColor: UIColor = UIColor.white {
        didSet {
            SlideMenuConfig.shared.menuTitleColor = self.menuTitleColor
        }
    }
    
    open var menuSectionBasedStatusBarStyle: Bool = false {
        didSet {
            SlideMenuConfig.shared.menuSectionBasedStatusBarStyle = self.menuSectionBasedStatusBarStyle
        }
    }
    
    open var accessibilityIdentifier: String = "SlideMenuView" {
        didSet {
            SlideMenuConfig.shared.accessibilityIdentifier = self.accessibilityIdentifier
        }
    }
    
    fileprivate lazy var menuViewController = SlideMenuVC.menuVC()
    fileprivate var sections: [MenuSection] = []
    
	
	public init() { }
	
    // MARK: - Public methods
    
    open func menuVC(_ statusBarStyle: UIStatusBarStyle = .default, completion: (() -> Void)? = nil) -> UIViewController {
        guard let menuVC = self.menuViewController else {
            LogWarn("Couldn't instantiate menu")
            return UIViewController()
        }
		
		self.menuViewController?.statusBarStyle = statusBarStyle
        self.menuViewController?.completion = completion
        
        return menuVC
    }
    
    open func userDidTapMenu() {
        self.menuViewController?.userDidTapMenuButton()
    }
    
    open func addSection(_ section: MenuSection) {
        self.sections.append(section)
        self.menuViewController?.sections = self.sections
    }
    
    open func selectSection(_ index: Int) {
		guard index >= 0 && index < self.sections.count else { return }
        let section = self.sections[index]
        self.menuViewController?.setSection(section.sectionController, index: index)
    }
    
}
