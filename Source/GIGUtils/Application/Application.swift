//
//  Application.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 9/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


open class Application {
	
	public init(){}
	
	open func presentModal(_ viewController: UIViewController) {
		let topVC = self.topViewController()
        DispatchQueue.main.async(execute: {
            topVC?.present(viewController, animated: true, completion: nil)
        })
	}
	
	fileprivate func topViewController() -> UIViewController? {
		let app = UIApplication.shared
		let window = app.keyWindow
		var rootVC = window?.rootViewController
		while let presentedController = rootVC?.presentedViewController {
			rootVC = presentedController
		}
		
		return rootVC
	}
	
}
