//
//  SlideMenuTableVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 12/4/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

class SlideMenuTableVC: UIViewController, UITableViewDataSource {
    
    var sections: [MenuSection]? {
        didSet {
            guard let tableView = self.tableView else {
                return
            }
            
            tableView.reloadData()
        }
    }
    
    
    @IBOutlet weak private var tableView: UITableView!
    
    
    
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
    
}
