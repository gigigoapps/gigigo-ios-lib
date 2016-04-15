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


enum MenuDirection {
    case Left
    case Right
}


class SlideMenuVC: UIViewController, MenuTableDelegate {
    
    // MARK: - Constants
    private let kPercentMenuOpeness: CGFloat = 0.8
    private let kVelocityThreshold: CGFloat = 500
    private let kAnimationDuration: NSTimeInterval = 0.4
    private let kAnimationDurationFast: NSTimeInterval = 0.2
    
    
    // MARK: - Public Properties
    var sections: [MenuSection] = [] {
        didSet {
            if let menuTableView = self.menuTableView {
                menuTableView.sections = sections
            }
        }
    }
	
	var statusBarStyle: UIStatusBarStyle = .Default
    
    
    // MARK: - Private Properties
    private var menuState = MenuState.Close
    private var currentController: UIViewController?
    private weak var sectionControllerToShow: UIViewController?
	private var sectionIndexToShow: Int?
	private lazy var buttonClose = UIButton()
    weak private var menuTableView: SlideMenuTableVC?
    @IBOutlet weak private var customContentContainer: UIView!
    
    
    // Panning
    private var lastX: CGFloat = 0
    @IBOutlet private var panGesture: UIPanGestureRecognizer!
    
    
    class func menuVC() -> SlideMenuVC? {
        let menuVC = UIStoryboard.GIGInitialVC("SlideMenu") as? SlideMenuVC
        
        return menuVC
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customContentContainer.addSubview(self.buttonClose)
        self.buttonClose.addTarget(self, action: #selector(closeMenuAnimated), forControlEvents: .TouchUpInside)

        if let sectionController = self.sectionControllerToShow {
            self.setSection(sectionController, index: self.sectionIndexToShow ?? 0)
            self.sectionControllerToShow = nil
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setShadowOnContainer()
        self.buttonClose.frame = self.customContentContainer.frame
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
    
    
    // MARK: - Gesture
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.customContentContainer)

        switch sender.state {
        case .Began:
            self.panGestureBegan()
        
        case .Changed:
            self.panGestureStateChanged(translation)
            
        case .Ended:
            self.panGestureEnded(sender)
            
        default:
            break
        }

    }
    
    private func panGestureBegan() {
        self.lastX = self.customContentContainer.x();
    }
    
    private func panGestureStateChanged(translation: CGPoint) {
        var newXPosition = self.lastX + translation.x
        
        // Check if position crossed the left bounds
        newXPosition = max(0, newXPosition)
        
        self.translateContent(min(newXPosition, self.view.width() * self.kPercentMenuOpeness))
    }
    
    private func panGestureEnded(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocityInView(self.customContentContainer)
        let currentXPos = self.customContentContainer.x()
        
        let direction = self.determineDirectoWithVelocity(velocity, position: currentXPos)
        
        switch direction {
        case .Left:
            self.animateFast(closeMenu)
        
        case .Right:
            self.animateFast(openMenu)
        }
    }
    
    private func determineDirectoWithVelocity(velocity: CGPoint, position: CGFloat) -> MenuDirection {
        if velocity.x < -self.kVelocityThreshold {
            return .Left
        }
        else if velocity.x > self.kVelocityThreshold {
            return .Right
        }
        else {
            if position < ((self.view.width() * self.kPercentMenuOpeness) / 2) {
                return .Left
            }
            else {
                return .Right
            }
        }
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
        
        self.customContentContainer.bringSubviewToFront(self.buttonClose)
    }
    
    private func animateFast(code: () -> Void) {
        UIView.animateWithDuration(self.kAnimationDurationFast) {
            code()
        }
    }
    
    private func animate(code: () -> Void) {
        UIView.animateWithDuration(self.kAnimationDuration) {
            code()
        }
    }
    
    private func translateContent(xPos: CGFloat) {
        let tTranslate = CGAffineTransformMakeTranslation(xPos, 0)
        self.customContentContainer.transform = CGAffineTransformConcat(CGAffineTransformIdentity, tTranslate)
    }
    
    private func openMenu() {
        self.menuState = .Open
        self.buttonClose.enabled = true
        
        let xPos = self.view.width() - (self.view.width() * (1 - self.kPercentMenuOpeness))
        self.translateContent(xPos)
    }
    
    func closeMenuAnimated() {
        self.animate(closeMenu)
    }
    
    private func closeMenu() {
        self.menuState = .Close
        self.buttonClose.enabled = false
        
        self.translateContent(0)
    }

}
