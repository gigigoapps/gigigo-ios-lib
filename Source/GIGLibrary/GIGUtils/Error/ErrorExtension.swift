//
//  ErrorExtension.swift
//  
//
//  Created by Alejandro Jiménez Agudo on 11/03/2020.
//

import Foundation

extension NSError {
	
	convenience init(domain: String = Bundle.main.bundleIdentifier ?? "com.gigigo.giglibrary", code: Int = 0, message: String?) {
		let userInfo = message.map { [NSLocalizedDescriptionKey: $0] }
		
		self.init(domain: domain, code: code, userInfo: userInfo)
	}
	
	
	class func errorWith(domain: String = Bundle.main.bundleIdentifier ?? "com.gigigo.giglibrary", code: Int = 0, message: String?) -> NSError {
		NSError(domain: domain, code: code, message: message)
	}
	
}
