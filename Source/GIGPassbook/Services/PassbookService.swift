//
//  PassbookService.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 8/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation
import GIGLibrary
import PassKit


enum PassbookServiceResult {
	case Success(PKPass)
	case Error(NSError)
	case UnsupportedVersionError(NSError)
}


class PassbookService {
	
	func fetchPassFromURL(url: NSURL, completionHandler: PassbookServiceResult -> Void) {
		let request = Request(
			method: "GET",
			baseUrl: url.absoluteString,
			endpoint: ""
		)
		
		request.fetchData { response in
			switch response.status {
				
			case .Success:
				self.onSuccess(response, completionHandler: completionHandler)
				
			default:
				self.onFail(response, completionHandler: completionHandler)
			}
		}
	}
	
	
	// MARK: - Private Helpers
	
	private func onSuccess(response: Response, completionHandler: PassbookServiceResult -> Void) {
		guard let data = response.body as? NSData else {
			let error = self.errorUnknown()
			
			completionHandler(.Error(error))
			return
		}
		
		var error: NSError?
		let pass = PKPass(data: data, error: &error)
		
		if let errorUnwrap = error {
			switch errorUnwrap.code {
				
			case PKPassKitErrorCode.UnsupportedVersionError.rawValue:
				completionHandler(.UnsupportedVersionError(errorUnwrap))
				
			default:
				completionHandler(.Error(errorUnwrap))
			}
		}
		else {
			completionHandler(.Success(pass))
		}
		
	}
	
	private func onFail(response: Response, completionHandler: PassbookServiceResult -> Void) {
		guard let error = response.error else {
			let error = self.errorUnknown()
			
			completionHandler(.Error(error))
			return
		}
		
		completionHandler(.Error(error))
	}
	
	private func errorUnknown() -> NSError {
		let error = NSError(
			domain: kGIGPassbookErrorDomain,
			code: -1,
			userInfo: [kGIGPassbookErrorMessage: "Unknown error"]
		)
		
		return error
	}
	
}