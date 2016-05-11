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
	
	
	convenience init(response: GIGURLResponse) {
		self.init()
		
		guard
			response.success,
			let data = response.data
			else {
				self.statusCode = response.error.code ?? -1
				self.error = response.error
				self.status = self.parseError(self.error)
				return
		}
		
		self.statusCode = 200
		self.status = .Success
		self.body = data
	}
	
	convenience init(response: GIGURLJSONResponse) {
		self.init()
		
		self.body = response.json
		
		if response.success {
			guard let json = response.json as? [String: AnyObject] else {
				self.status = .ErrorParsingJson
				return
			}
			
			guard let status = self.parseStatus(json) else {
				self.error = response.error
				self.status = self.parseError(self.error)
				return
			}
			
			if status != true {
				self.status = self.parseError(json)
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
	
	private func parseStatus(json: [String: AnyObject]) -> Bool? {
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
	
	private func parseError(json: [String: AnyObject]) ->  ResponseStatus {
		let error = json["error"] as? [String: AnyObject] ?? json
		
		guard
			let code = error["code"] as? Int,
			let message = error["message"] as? String
			else { return .UnknownError }
		
		let userInfo = [kGIGNetworkErrorMessage: message]
		self.error = NSError(domain: kGIGNetworkErrorDomain, code: code, userInfo: userInfo)
		
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


public enum ResponseError: ErrorType {
	case BodyNil
}

public extension Response {
	
	public func json() throws -> JSON {
		guard let json = self.body else {
			throw ResponseError.BodyNil
		}
		
		return JSON(json: json)
	}
	
	public func image() throws -> UIImage {
		guard let image = self.body as? UIImage else {
			throw ResponseError.BodyNil
		}
		
		return image
	}
	
}