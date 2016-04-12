//
//  MenuSectionCell.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

class MenuSectionCell: UITableViewCell {
    
    @IBOutlet weak var imageMenuSection: UIImageView!
    @IBOutlet weak var labelMenuSection: UILabel!
    
    
    func bindMenuSection(menuSection: MenuSection) {
        self.labelMenuSection.text = menuSection.name
        self.imageMenuSection.image = menuSection.icon
    }

}
