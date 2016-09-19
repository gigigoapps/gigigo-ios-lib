//
//  Response.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public let kGIGNetworkErrorDomain = "com.gigigo.network";
public let kGIGNetworkErrorMessage = "GIGNETWORK_ERROR_MESSAGE"


public enum ResponseStatus {
	case success
	case errorParsingJson
	case sessionExpired
	case timeout
	case noInternet
	case apiError
	case unknownError
}


open class Response {
	
	open var status: ResponseStatus
	open var statusCode: Int
	open var body: AnyObject?
	open var error: NSError?
	
	
	// MARK: - Initializers
	
	init() {
		self.status = .unknownError
		self.statusCode = 0
	}
	
	
	convenience init(response: GIGURLResponse) {
		self.init()
		
		guard
			response.success,
			let data = response.data
			else {
				self.statusCode = response.error._code
				self.error = response.error as NSError?
                self.status = self.parse(error: self.error)
				return
		}
		
		self.statusCode = 200
		self.status = .success
		self.body = data as AnyObject?
	}
	
	convenience init(response: GIGURLJSONResponse) {
		self.init()
		
		self.body = response.json as AnyObject?
		
		if response.success {
			guard let json = response.json as? [String: AnyObject] else {
				self.status = .errorParsingJson
				return
			}
			
			guard let status = self.parseStatus(json) else {
				self.error = response.error as NSError?
                self.status = self.parse(error: self.error!)
				return
			}
			
			if status != true {
                self.status = self.parse(json: json)
			}
			else {
				self.status = .success
				self.body = json["data"]
			}
		}
		else {
            self.status = self.parse(error: response.error as NSError)
		}
	}
	
	convenience init(response: GIGURLImageResponse) {
		self.init()
		
		if response.success {
			guard let image = response.image else {
				self.status = .unknownError
				return
			}
			self.status = .success
			self.body = image
		}
		else {
            self.status = self.parse(error: response.error as NSError)
		}
	}
	
	
	// MARK: - Private Helpers
	
	fileprivate func parseStatus(_ json: [String: AnyObject]) -> Bool? {
		if let statusBool = json["status"] as? Bool {
			return statusBool
		}
		else if let statusString = json["status"] as? String {
			return statusString == "OK"
		}
		else {
			return nil
		}
	}
	
	fileprivate func parse(json: [String: AnyObject]) ->  ResponseStatus {
		let error = json["error"] as? [String: AnyObject] ?? json
		
		guard
			let code = error["code"] as? Int,
			let message = error["message"] as? String
			else { return .unknownError }
		
		let userInfo = [kGIGNetworkErrorMessage: message]
		self.error = NSError(domain: kGIGNetworkErrorDomain, code: code, userInfo: userInfo)
		
        return self.parse(error: self.error)
	}
	
	fileprivate func parse(error: NSError?) -> ResponseStatus {
		guard let err = error else { return .unknownError }
		
		self.statusCode = err.code
		
		switch err.code {
		case 401:
			return .sessionExpired
		case -1001:
			return .timeout
		case -1009:
			return .noInternet
		case 10000...20000:
			return .apiError
		default:
			return .unknownError
		}
	}
	
}


public enum ResponseError: Error {
	case bodyNil
}

public extension Response {
	
	public func json() throws -> JSON {
		guard let json = self.body else {
			throw ResponseError.bodyNil
		}
		
		return JSON(json: json)
	}
	
	public func image() throws -> UIImage {
		guard let image = self.body as? UIImage else {
			throw ResponseError.bodyNil
		}
		
		return image
	}
	
}
