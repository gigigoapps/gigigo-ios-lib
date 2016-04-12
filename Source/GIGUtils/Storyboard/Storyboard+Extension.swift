//
//  Storyboard+Extension.swift
//  Zeus
//
//  Created by Alejandro Jiménez Agudo on 30/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit


extension UIStoryboard {
	
    class func GIGStoryboard(name: String) -> UIStoryboard {
		return UIStoryboard(name: name, bundle: NSBundle(identifier: "com.gigigo.GIGLibrary"))
	}
	
	
    class func GIGInitialVC(name: String) -> UIViewController? {
		let storyboard = UIStoryboard.GIGStoryboard(name)
		guard let initialVC = storyboard.instantiateInitialViewController() else {
			LogWarn("Couldn't found initial view controller")
			return nil
		}
		
		return initialVC
	}
	
}