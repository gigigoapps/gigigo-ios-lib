//
//  SlideMenuTableVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


protocol MenuTableDelegate {
	func tableDidSelecteSection(_ menuSection: MenuSection, index: Int)
}


class SlideMenuTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuTableDelegate: MenuTableDelegate?
	
    var sections: [MenuSection]? {
        didSet {
            guard let tableView = self.tableView else {
                return
            }
            
            tableView.reloadData()
        }
    }
	
	
	fileprivate var indexToShow: Int?
	
    
    @IBOutlet weak fileprivate var tableView: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
		self.view.backgroundColor = SlideMenuConfig.shared.menuBackgroundColor
		
		if let index = self.indexToShow {
			self.selectSection(index)
			self.indexToShow = nil
		}
	}
	
	
	// MARK - Public Methods
	
    func selectSection(_ index: Int, menuSectionClicked: MenuSection? = nil) {
        self.indexToShow = index
		guard self.tableView != nil else {
			return
		}
        self.setNeedsStatusBarAppearanceUpdate()

		let indexPath = IndexPath(row: index, section: 0)
        guard let modeButtonType = menuSectionClicked?.modeButtonType else {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            return
        }
        if modeButtonType {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        } else {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        }
	}

	func updateSection(at index: Int) {
		guard let tableView = self.tableView else { return }

		let indexPath = IndexPath(row: index, section: 0)
		guard tableView.cellForRow(at: indexPath) != nil else { return }

		DispatchQueue.main.async {
			tableView.reloadRows(at: [indexPath], with: .none)

			if index == self.indexToShow {
				 self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
			}
		}
	}
	
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MenuSectionCell,
            let menuSection = self.sections?[(indexPath as NSIndexPath).row]
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
                return cell!
        }
        
        cell.bindMenuSection(menuSection)
        
        return cell
    }
    
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let menuSection = self.sections?[(indexPath as NSIndexPath).row],
            let delegate = self.menuTableDelegate
            else {
                return
        }
        
        delegate.tableDidSelecteSection(menuSection, index: (indexPath as NSIndexPath).row)

        guard let modeButtonType = menuSection.modeButtonType else {
            self.indexToShow = indexPath.row
            return
        }
        
        if modeButtonType {
            guard let index = self.indexToShow else {
                return
            }
            self.selectSection(index, menuSectionClicked: menuSection)
        }
    }
}
