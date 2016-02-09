//
//  Response.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public let kGigNetworkErrorMessage = "GIGNETWORK_ERROR_MESSAGE"

public enum ResponseStatus {
	case Success
	case ErrorParsingJson
	case SessionExpired
	case Timeout
	case NoInternet
	case ApiError
	case UnknownError
}


public class Response {
	
	public var status: ResponseStatus
	public var statusCode: Int
	public var body: AnyObject?
	public var error: NSError?
	
	
	// MARK: - Initializers
	
	init() {
		self.status = .UnknownError
		self.statusCode = 0
	}
	
	convenience init(response: GIGURLJSONResponse) {
		self.init()
		
		if response.success {
			guard let json = response.json as? [String: AnyObject] else {
				self.status = .ErrorParsingJson
				return
			}
			
			guard let status = json["status"] as? Bool else {
				self.error = response.error
				self.status = self.parseError(self.error)
				return
			}
			
			if status != true {
				self.parseError(json)
			}
			else {
				self.status = .Success
				self.body = json["data"]
			}
		}
		else {
			self.status = self.parseError(response.error)
		}
	}
	
	convenience init(response: GIGURLImageResponse) {
		self.init()
		
		if response.success {
			guard let image = response.image else {
				self.status = .UnknownError
				return
			}
			self.status = .Success
			self.body = image
		}
		else {
			self.status = self.parseError(response.error)
		}
	}

	
	// MARK: - Private Helpers
	private func parseError(json: [String: AnyObject]) ->  ResponseStatus {
		guard let error = json["error"] as? [String: AnyObject] else { return .UnknownError }
		
		guard
			let code = error["code"] as? Int,
			let message = error["message"] as? String
			else { return .UnknownError }
		
		let userInfo = [kGigNetworkErrorMessage: message]
		self.error = NSError(domain: "com.giglibrary.network", code: code, userInfo: userInfo)
		
		return self.parseError(self.error)
	}
	
	private func parseError(error: NSError?) -> ResponseStatus {
		guard let err = error else { return .UnknownError }
		
		self.statusCode = err.code
		
		switch err.code {
		case 401:
			return .SessionExpired
		case -1001:
			return .Timeout
		case -1009:
			return .NoInternet
		case 10000...20000:
			return .ApiError
		default:
			return .UnknownError
		}
	}
	
}