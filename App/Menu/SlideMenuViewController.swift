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
    
    
    lazy var menu = SlideMenu()
    
    @IBOutlet weak var viewContainer: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let menuVC = self.menu.menuVC()
        self.addChild(menuVC)
        self.viewContainer.addSubviewWithAutolayout(menuVC.view)

			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
				self.menu.updateBadge(to: "5", atSection: "Section 1")

				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
					self.menu.updateBadge(to: nil, atSection: "Section 1")
				}
			}
    }
    
    
    @IBAction func onMenuButtonTap(_ sender: AnyObject) {
        self.menu.userDidTapMenu()
    }

    override var preferredStatusBarStyle:  UIStatusBarStyle  {
        return self.children.first?.preferredStatusBarStyle ?? .default
    }
    
    fileprivate func prepareMenu() {
        
        //-- Optional Style --
		self.menu.sectionSelectorColor = UIColor.blue
		self.menu.menuBackgroundColor = UIColor(fromHex: 0x242424)
        self.menu.menuTitleColor = UIColor.purple
        self.menu.menuHighlightColor = UIColor.red
		
        //-- Element --
        let section1 = MenuSection(
            name: "Section 1",
            icon: UIImage(named: "menu_section_stickers")!,
						badge: "!",
            storyboard: "Main",
            viewController: "SlideMenuSection1",
            accessibilityIdentifier: "SlideMenuSection1",
            completion: { (sectionVC) in
                print("Instantiated section: 1")
            }
        )
        
        let section2 = MenuSection(
            name: "Section 2",
            iconURLString: "https://squigglepark.com/wp-content/uploads/2017/01/circle_heart-800x509.png",
            iconPlaceholder: nil,
            storyboard: "Main",
            viewController: "SlideMenuSection2",
            accessibilityIdentifier: "SlideMenuSection2",
            completion: { (sectionVC) in
                print("Instantiated section: 2")
            }
        )
        
		
		let section3 = MenuSection(
			name: "Section 3",
			icon: UIImage(),
			storyboard: "Main",
            accessibilityIdentifier: "SlideMenuSection3",
            completion: { (sectionVC) in
                print("Instantiated section: 3")
            }
		)
        
        self.menu.addSection(section1)
        self.menu.addSection(section2)
		self.menu.addSection(section3)
        
        self.menu.selectSection(0)
    }
}
