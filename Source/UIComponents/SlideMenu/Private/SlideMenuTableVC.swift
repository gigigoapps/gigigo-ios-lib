//
//  SlideMenuTableVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


protocol MenuTableDelegate {
	func tableDidSelecteSection(menuSection: MenuSection, index: Int)
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
	
	
	private var indexToShow: Int?
	
    
    @IBOutlet weak private var tableView: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let index = self.indexToShow {
			self.selectSection(index)
			self.indexToShow = nil
		}
	}
	
	
	// MARK - Public Methods
	
	func selectSection(index: Int) {
		guard self.tableView != nil else {
			self.indexToShow = index
			return
		}
		
		let indexPath = NSIndexPath(forRow: index, inSection: 0)
		self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
	}
	
    
    // MARK: - TableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? MenuSectionCell,
            let menuSection = self.sections?[indexPath.row]
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
                return cell!
        }
        
        cell.bindMenuSection(menuSection)
        
        return cell
    }
    
    
    // MARK: - TableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let menuSection = self.sections?[indexPath.row],
            let delegate = self.menuTableDelegate
            else {
                return
        }
        
        delegate.tableDidSelecteSection(menuSection, index: indexPath.row)
    }
    
}
