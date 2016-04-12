//
//  SlideMenu.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


enum MenuState {
    case Open
    case Close
}


public class SlideMenu {
    
    public static let shared = SlideMenu()
    
    private lazy var menuViewController = SlideMenuVC.menuVC()
    private var menuState = MenuState.Close
    private var sections: [MenuSection] = []
    
    
    // MARK: - Public methods
    
    public func menuVC() -> UIViewController {
        guard let menuVC = self.menuViewController else {
            LogWarn("Couldn't instantiate menu")
            return UIViewController()
        }
        
        return menuVC
    }
    
    public func userDidTapMenu() {
        switch self.menuState {
        
        case .Open:
            self.closeMenu()
        
        case .Close:
            self.openMenu()
        }
    }
    
    public func openMenu() {
        self.menuViewController?.openMenu()
        self.menuState = .Open
    }
    
    public func closeMenu() {
        self.menuViewController?.closeMenu()
        self.menuState = .Close
    }
    
    public func addSection(section: MenuSection) {
        self.sections.append(section)
        self.menuViewController?.sections = self.sections
    }
    
    public func selectSection(index: Int) {
        var section = self.sections[index]
        self.menuViewController?.setSection(section.sectionController)
    }
    
}