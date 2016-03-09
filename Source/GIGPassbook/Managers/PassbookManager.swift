//
//  PassbookManager.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 8/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation
import PassKit
import GIGLibrary


class PassbookManager {
	
	private var app = Application()
	
	func addPass(pass: PKPass) {
		let addVC = PKAddPassesViewController(pass: pass)
		self.app.presentModal(addVC)
	}
	
}