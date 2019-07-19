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
        self.accessibilityIdentifier = menuSection.accessibilityIdentifier
        if let iconFromURL = menuSection.iconURLString {
            self.imageMenuSection.imageFromURL(
                urlString: iconFromURL,
                placeholder: menuSection.icon)
        } else {
            self.imageMenuSection.image = menuSection.icon
        }

		if #available(iOS 9.0, *) {
			if let badge = menuSection.badge {
				self.addBadge(badge)
			} else {
				self.removeBadge()
			}
		}
        
        guard let modeButtonType = menuSection.modeButtonType else {
            return
        }
        
        if modeButtonType {
            self.viewSelector.backgroundColor = UIColor.clear
        } else {
            self.viewSelector.backgroundColor = SlideMenuConfig.shared.sectionSelectorColor
        }
        
        if let menuTitleColor = SlideMenuConfig.shared.menuTitleColor {
            self.labelMenuSection.textColor = menuTitleColor
        }


    }
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
        if selected {
            self.viewSelector.alpha = 1
            
            if let colorHightLight = SlideMenuConfig.shared.menuHighlightColor {
                self.labelMenuSection.textColor = colorHightLight
            }
        } else {
            self.viewSelector.alpha = 0
            
            if let menuTitleColor = SlideMenuConfig.shared.menuTitleColor {
                self.labelMenuSection.textColor = menuTitleColor
            }
        }
	}

	// MARK: - Private

	private let badgeViewIdentifier = "badge"

	@available(iOS 9.0, *)
	private func addBadge(_ badge: String) {
		let label = UILabel()
		label.text = "\(badge.first ?? "!")"
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .red
		label.sizeToFit()
		
		let size = max(label.bounds.height, label.bounds.width)
		label.clipsToBounds = true
		label.layer.cornerRadius = size / 2

		self.imageMenuSection.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.widthAnchor.constraint(equalToConstant: size),
			label.heightAnchor.constraint(equalToConstant: size),
			label.topAnchor.constraint(equalTo: self.imageMenuSection.topAnchor, constant: -(size/2)),
			label.rightAnchor.constraint(equalTo: self.imageMenuSection.rightAnchor, constant: ((1/3)*size))
			])

		label.accessibilityIdentifier = badgeViewIdentifier
	}

	private func removeBadge() {
		guard let badgeLabel = self.imageMenuSection.subviews.first(where: {
			$0.accessibilityIdentifier == badgeViewIdentifier
		}) else { return }

		badgeLabel.removeFromSuperview()
	}
}
