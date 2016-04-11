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
    
    
    @IBOutlet weak var viewContainer: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let menu = SlideMenu.shared
        let menuVC = menu.menuVC()
        
        self.addChildViewController(menuVC)
        self.viewContainer.addSubviewWithAutolayout(menuVC.view)
        
    }


}
