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
				self.menu.updateBadge(to: "1", atSection: "Section 2")

				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
					self.menu.clearBadges()
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
            iconURLString: "https://d84sonex3w38u.cloudfront.net/media/image/configuration$k3XB0pE1/200/200/original?country=br",
            iconPlaceholder: UIImage(named: "menu_section_stickers")!,
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
        
        let section4 = MenuSection(
            name: "Section 4",
            iconURLString: "https://d84sonex3w38u.cloudfront.net/media/image/home$q2XzgLfV/750/629/90?country=br",
            iconPlaceholder: UIImage(named: "menu_section_stickers")!,
            storyboard: "Main",
            viewController: "SlideMenuSection4",
            accessibilityIdentifier: "SlideMenuSection4",
            completion: { (sectionVC) in
                print("Instantiated section: 4")
        }
        )
        
        let section5 = MenuSection(
            name: "Section 5",
            icon: UIImage(),
            storyboard: "Main",
            accessibilityIdentifier: "SlideMenuSection5",
            completion: { (sectionVC) in
                print("Instantiated section: 5")
        }
        )
        
        let section6 = MenuSection(
            name: "Section 6",
            iconURLString: "https://d84sonex3w38u.cloudfront.net/media/image/configuration$kdXSP17v/200/200/original?country=br",
            iconPlaceholder: UIImage(named: "menu_section_stickers")!,
            storyboard: "Main",
            viewController: "SlideMenuSection6",
            accessibilityIdentifier: "SlideMenuSection6",
            completion: { (sectionVC) in
                print("Instantiated section: 6")
        })
        
        let section7 = MenuSection(
            name: "Section 7",
            icon: UIImage(),
            storyboard: "Main",
            accessibilityIdentifier: "SlideMenuSection7",
            completion: { (sectionVC) in
                print("Instantiated section: 7")
        }
        )
        
        
        let section8 = MenuSection(
            name: "Section 8",
            icon: UIImage(),
            storyboard: "Main",
            accessibilityIdentifier: "SlideMenuSection8",
            completion: { (sectionVC) in
                print("Instantiated section: 8")
        }
        )
        
        
        let section9 = MenuSection(
            name: "Section 9",
            iconURLString: "https://d84sonex3w38u.cloudfront.net/media/image/configuration$k3XB0pE1/200/200/original?country=br",
            iconPlaceholder: UIImage(named: "menu_section_stickers")!,
            storyboard: "Main",
            viewController: "SlideMenuSection9",
            accessibilityIdentifier: "SlideMenuSection9",
            completion: { (sectionVC) in
                print("Instantiated section: 9")
        })
        
        self.menu.addSection(section1)
        self.menu.addSection(section2)
		self.menu.addSection(section3)
        self.menu.addSection(section4)
        self.menu.addSection(section5)
        self.menu.addSection(section6)
        self.menu.addSection(section7)
        self.menu.addSection(section8)
        self.menu.addSection(section9)
        
        self.menu.selectSection(0)
    }
}
