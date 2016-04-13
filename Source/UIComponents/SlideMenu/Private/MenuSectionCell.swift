//
//  MenuSectionCell.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

class MenuSectionCell: UITableViewCell {
    
    @IBOutlet weak private var imageMenuSection: UIImageView!
    @IBOutlet weak private var labelMenuSection: UILabel!
	@IBOutlet weak private var viewSelector: UIView!
	
	
	override func awakeFromNib() {
		self.viewSelector.backgroundColor = SlideMenuConfig.shared.sectionSelectorColor
	}
	
	
    func bindMenuSection(menuSection: MenuSection) {
        self.labelMenuSection.text = menuSection.name
        self.imageMenuSection.image = menuSection.icon
		self.viewSelector.alpha = 0
    }
	
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		UIView.animateWithDuration(0.4) { 
			if selected {
				self.viewSelector.alpha = 1
			}
			else {
				self.viewSelector.alpha = 0
			}
		}
	}

}
