//
//  Request.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public class Request: GIGURLCommunicator {
	
	public var method: String
	public var endpoint: String
	public var headers: [String: String]
	public var urlParams: [String: AnyObject]
	public var bodyParams: [String: AnyObject]
	public var verbose = false
	
	private var manager: GIGURLManager
	
	public init(method: String, host: String, endpoint: String, headers: [String: String] = [:], urlParams: [String: AnyObject] = [:], bodyParams: [String: AnyObject] = [:], verbose: Bool = false) {
		self.method = method
		self.endpoint = endpoint
		self.headers = headers
		self.urlParams = urlParams
		self.bodyParams = bodyParams
		self.verbose = verbose
		
		self.manager = GIGURLManager()
		self.manager.domain = GIGURLDomain(name: "domain", url: host)
		
		super.init(manager: self.manager)
	}
	
	
	// MARK: - Public Method
	
	public func fetchJson(completionHandler: (Response) -> Void) {
		let request = self.buildRequest()
		request.responseClass = self.jsonClass()
		
		self.sendRequest(request) { urlResponse in
			guard let jsonResponse = urlResponse as? GIGURLJSONResponse else {
				completionHandler(Response())
				return
			}
			
			let response = Response(response: jsonResponse)
			completionHandler(response)
		}
	}
	
	public func fetchImage(completionHandler: (Response) -> Void) {
		let request = self.buildRequest()
		request.responseClass = self.imageClass()
		
		self.sendRequest(request) { urlResponse in
			guard let imageResponse = urlResponse as? GIGURLImageResponse else {
				completionHandler(Response())
				return
			}
			
			let response = Response(response: imageResponse)
			completionHandler(response)
		}
	}
	
	
	// MARK: - Private Helpers
	
	private func buildRequest() -> GIGURLRequest {
		let request = GIGURLRequest(method: self.method, url: "\(self.manager.domain.url)\(self.endpoint)")
		request.headers = self.headers
		request.parameters = self.urlParams
		request.json = self.bodyParams
		request.logLevel = self.verbose ? .Verbose : .None
		
		return request
	}
	
	private func jsonClass() -> AnyClass {
		let className = NSStringFromClass(GIGURLJSONResponse.self)
		return NSClassFromString(className) as! GIGURLJSONResponse.Type
	}
	
	private func imageClass() -> AnyClass {
		let className = NSStringFromClass(GIGURLImageResponse.self)
		return NSClassFromString(className) as! GIGURLImageResponse.Type
	}
}