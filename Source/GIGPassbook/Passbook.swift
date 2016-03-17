//
//  Passbook.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 8/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public let kGIGPassbookErrorDomain = "com.giglibrary.passbook"
public let kGIGPassbookErrorMessage = "GIGPASSBOOK_ERROR_MESSAGE"

public enum PassbookResult {
	case Success
	case Error(NSError)
	case UnsupportedVersionError(NSError)
}

public class Passbook {
	
	private var service = PassbookService()
	private var passbookManager = PassbookManager()
	
	
	public init() {}
	
	public func addPassbookFromUrl(urlString: String, completionHandler: PassbookResult -> Void) {
		guard let url = NSURL(string: urlString) else {
			completionHandler(.Error(self.errorURLNotValid()))
			return
		}
		
		self.service.fetchPassFromURL(url) { result in
			switch result {
				
			case .Success(let pass):
				self.passbookManager.addPass(pass)
				completionHandler(.Success)
				
			case .UnsupportedVersionError(let error):
				completionHandler(.UnsupportedVersionError(error))
				
			case .Error(let error):
				completionHandler(.Error(error))
			}
		}
		
	}
	
	
	private func errorURLNotValid() -> NSError {
		let error = NSError(
			domain: kGIGPassbookErrorDomain,
			code: 10000,
			userInfo: [kGIGPassbookErrorMessage: "The url is not valid"]
		)
		
		return error
	}
}