//
//  PassbookService.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 8/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation
import PassKit


enum PassbookServiceResult {
	case Success(PKPass)
	case Error(NSError)
}


class PassbookService {
	
	func fetchPassFromURL(url: NSURL, completionHandler: PassbookServiceResult -> Void) {		
		let error = NSError(
			domain: kGIGPassbookErrorDomain,
			code: -1,
			userInfo: [kGIGPassbookErrorMessage: "Not implemented yet"]
		)
		
		completionHandler(.Error(error))
	}
	
}