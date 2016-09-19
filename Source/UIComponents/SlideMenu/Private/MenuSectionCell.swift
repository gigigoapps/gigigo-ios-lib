//
//  MenuSectionCell.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

class MenuSectionCell: UITableViewCell {
    
    @IBOutlet weak fileprivate var imageMenuSection: UIImageView!
    @IBOutlet weak fileprivate var labelMenuSection: UILabel!
	@IBOutlet weak fileprivate var viewSelector: UIView!
	
	
	override func awakeFromNib() {
		self.viewSelector.backgroundColor = SlideMenuConfig.shared.sectionSelectorColor
	}
	
	
    func bindMenuSection(_ menuSection: MenuSection) {
        self.labelMenuSection.text = menuSection.name
        self.imageMenuSection.image = menuSection.icon
		self.viewSelector.alpha = 0
    }
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		UIView.animate(withDuration: 0.4, animations: { 
			if selected {
				self.viewSelector.alpha = 1
			}
			else {
				self.viewSelector.alpha = 0
			}
		}) 
	}

}
