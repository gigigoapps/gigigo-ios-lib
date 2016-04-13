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
	
	public var sectionSelectorColor: UIColor = UIColor.whiteColor() {
		didSet {
			SlideMenuConfig.shared.sectionSelectorColor = self.sectionSelectorColor
		}
	}
	
	public var menuBackgroundColor: UIColor = UIColor.blackColor() {
		didSet {
			SlideMenuConfig.shared.menuBackgroundColor = self.menuBackgroundColor
		}
	}
    
    private lazy var menuViewController = SlideMenuVC.menuVC()
    private var sections: [MenuSection] = []
    
    
    // MARK: - Public methods
    
	public func menuVC(statusBarStyle: UIStatusBarStyle = .Default) -> UIViewController {
        guard let menuVC = self.menuViewController else {
            LogWarn("Couldn't instantiate menu")
            return UIViewController()
        }
		
		self.menuViewController?.statusBarStyle = statusBarStyle
        
        return menuVC
    }
    
    public func userDidTapMenu() {
        self.menuViewController?.userDidTapMenuButton()
    }

    
    public func addSection(section: MenuSection) {
        self.sections.append(section)
        self.menuViewController?.sections = self.sections
    }
    
    public func selectSection(index: Int) {
        let section = self.sections[index]
        self.menuViewController?.setSection(section.sectionController, index: index)
    }
    
}