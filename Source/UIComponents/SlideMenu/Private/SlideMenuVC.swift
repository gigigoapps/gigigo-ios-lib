//
//  SlideMenuVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


enum MenuState {
    case Open
    case Close
}


class SlideMenuVC: UIViewController, MenuTableDelegate {
    
    var sections: [MenuSection] = [] {
        didSet {
            if let menuTableView = self.menuTableView {
                menuTableView.sections = sections
            }
        }
    }
	
	var statusBarStyle: UIStatusBarStyle = .Default
    
    private var menuState = MenuState.Close
    private var currentController: UIViewController?
    private weak var sectionControllerToShow: UIViewController?
	private var sectionIndexToShow: Int?
	
    
    weak var menuTableView: SlideMenuTableVC?
    @IBOutlet weak private var customContentContainer: UIView!
    
    
    class func menuVC() -> SlideMenuVC? {
        let menuVC = UIStoryboard.GIGInitialVC("SlideMenu") as? SlideMenuVC
        
        return menuVC
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let sectionController = self.sectionControllerToShow {
            self.setSection(sectionController, index: self.sectionIndexToShow ?? 0)
            self.sectionControllerToShow = nil
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setShadowOnContainer()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let menuTableView = segue.destinationViewController as? SlideMenuTableVC where segue.identifier == "SlideMenuTableVC" else {
            return
        }
        
        self.menuTableView = menuTableView
        self.menuTableView?.sections = self.sections
        self.menuTableView?.menuTableDelegate = self
		
		if let index = self.sectionIndexToShow {
			self.menuTableView?.selectSection(index)
			self.sectionIndexToShow = nil
		}
    }
	
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return self.statusBarStyle
	}
    
    
    // MARK: - Public Methods
    
    func userDidTapMenuButton() {
        switch self.menuState {
            
        case .Open:
            self.animate(closeMenu)
            
        case .Close:
            self.animate(openMenu)
        }
    }
    
    
	func setSection(viewController: UIViewController, index: Int) {
        guard self.customContentContainer != nil else {
            self.sectionControllerToShow = viewController
			self.sectionIndexToShow = index
            return
        }
        
        self.setViewController(viewController)
		
		guard self.menuTableView != nil else {
			self.sectionIndexToShow = index
			return
		}
		
		self.menuTableView?.selectSection(index)
    }
    
    
    // MARK: - MenuTableDelegate
    
	func tableDidSelecteSection(menuSection: MenuSection, index: Int) {
        self.setSection(menuSection.sectionController, index: index)
        self.animate(closeMenu)
    }
    
    
    // MARK: - Private Methods
    
    private func setShadowOnContainer() {
        let layer = self.customContentContainer.layer
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -5, height: 2)
        layer.shadowPath = UIBezierPath(rect: self.customContentContainer.bounds).CGPath
    }
    
    private func setViewController(viewController: UIViewController) {
        self.currentController = viewController
        self.addChildViewController(viewController)
        self.customContentContainer.addSubviewWithAutolayout(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    private func animate(code: () -> Void) {
        UIView.animateWithDuration(0.4) { 
            code()
        }
    }
    
    private func openMenu() {
        self.menuState = .Open
        
        let xPos = self.view.width() - (self.view.width() * 0.2)
        let tTranslate = CGAffineTransformMakeTranslation(xPos, 0)
        self.customContentContainer.transform = CGAffineTransformConcat(CGAffineTransformIdentity, tTranslate)
    }
    
    private func closeMenu() {
        self.menuState = .Close
        
        self.customContentContainer.transform = CGAffineTransformIdentity
    }

}
