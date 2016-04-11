//
//  SlideMenuVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

class SlideMenuVC: UIViewController {

    
    class func menuVC() -> SlideMenuVC? {
        let menuVC = UIStoryboard.initialVC("SlideMenu") as? SlideMenuVC
        
        return menuVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
