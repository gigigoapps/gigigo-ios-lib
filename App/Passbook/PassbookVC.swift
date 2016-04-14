//
//  PassbookVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 9/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGPassbook
import GIGLibrary


class PassbookVC: UIViewController {

	private let passbook = Passbook()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		LogManager.shared.appName = "GIGPassbook"
		LogManager.shared.logLevel = .Debug
	}
	
	
	@IBAction func onButtonDownloadTap(sender: AnyObject) {
		let url = "http://mcd.s.gigigoapps.com/campaign/0l1vMBmWEpi6RzJ5n49R/coupon/ZDqmBrJZbJceBELnM9aW/passbook"
		
		self.passbook.addPassbookFromUrl(url) { result in
			switch result {
			
			case .Success:
				print("Passbook: downloaded successfully")
				
			case .UnsupportedVersionError(_):
				print("Passbook: Unsupported version")
				
			case .Error(let error):
				LogError(error)
				print("Passbook: Error")
			}
		}
	}
	
}
