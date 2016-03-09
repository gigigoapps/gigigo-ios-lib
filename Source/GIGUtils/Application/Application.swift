//
//  Application.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 9/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public class Application {
	
	public init(){}
	
	public func presentModal(viewController: UIViewController) {
		let topVC = self.topViewController()
		topVC?.presentViewController(viewController, animated: true, completion: nil)
	}
	
	private func topViewController() -> UIViewController? {
		let app = UIApplication.sharedApplication()
		let window = app.keyWindow
		var rootVC = window?.rootViewController
		while let presentedController = rootVC?.presentedViewController {
			rootVC = presentedController
		}
		
		return rootVC
	}
	
}