//
//  SlideMenuViewController.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary


class SlideMenuViewController: UIViewController {
    
    
    lazy var menu = SlideMenu.shared
    
    @IBOutlet weak var viewContainer: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let menuVC = self.menu.menuVC()
        
        self.addChildViewController(menuVC)
        self.viewContainer.addSubviewWithAutolayout(menuVC.view)
        
        self.prepareMenu()
        
    }
    
    
    @IBAction func onMenuButtonTap(sender: AnyObject) {
        self.menu.userDidTapMenu()
    }

    
    private func prepareMenu() {
        let section1 = MenuSection(
            name: "Section 1",
            icon: UIImage(),
            storyboard: "Main",
            viewController: "SlideMenuSection1"
        )
        
        let section2 = MenuSection(
            name: "Section 2",
            icon: UIImage(),
            storyboard: "Main",
            viewController: "SlideMenuSection2"
        )
        
        self.menu.addSection(section1)
        self.menu.addSection(section2)
        
        self.menu.selectSection(0)
    }
}
