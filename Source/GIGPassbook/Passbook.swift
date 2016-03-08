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
}


public class Passbook {
	
	public func addPassbookFromUrl(url: String, completionHandler: PassbookResult -> Void) {
		let error = NSError(
			domain: kGIGPassbookErrorDomain,
			code: -1,
			userInfo: [kGIGPassbookErrorMessage: "Not implemented yet"]
		)

		completionHandler(.Error(error))
	}
	
}