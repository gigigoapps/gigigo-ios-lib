//
//  SlideMenuVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


class SlideMenuVC: UIViewController {
    
    var sections: [MenuSection] = [] {
        didSet {
            if let menuTableView = self.menuTableView {
                menuTableView.sections = sections
            }
        }
    }
    
    weak var menuTableView: SlideMenuTableVC?
    @IBOutlet weak private var customContentContainer: UIView!
    
    
    class func menuVC() -> SlideMenuVC? {
        let menuVC = UIStoryboard.initialVC("SlideMenu") as? SlideMenuVC
        
        return menuVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let menuTableView = segue.destinationViewController as? SlideMenuTableVC where segue.identifier == "SlideMenuTableVC" else {
            return
        }
        
        self.menuTableView = menuTableView
        self.menuTableView?.sections = self.sections
    }
    
    
    // MARK: - Public Methods
    func openMenu() {
        let xPos = self.view.width() - (self.view.width() * 0.2)
        let tTranslate = CGAffineTransformMakeTranslation(xPos, 0)
        self.customContentContainer.transform = CGAffineTransformConcat(CGAffineTransformIdentity, tTranslate)
    }
    
    
    func closeMenu() {
        self.customContentContainer.transform = CGAffineTransformIdentity
    }
    
    
    func setSection(viewController: UIViewController) {
        self.addChildViewController(viewController)
        self.customContentContainer.addSubviewWithAutolayout(viewController.view)
    }
    
    
    

}
