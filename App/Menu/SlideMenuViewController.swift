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
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let section = MenuSection(
            name: "Section1",
            storyboard: "Main",
            viewController: "SlideMenuSection1"
        )
        
        self.menu.addSection(section)
        self.menu.selectSection(0)
    }

    
    @IBAction func onMenuButtonTap(sender: AnyObject) {
        self.menu.userDidTapMenu()
    }

}
