//
//  Request.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


open class Request: GIGURLCommunicator {
	
	open var method: String
	open var endpoint: String
	open var headers: [String: String]?
	open var urlParams: [String: AnyObject]?
	open var bodyParams: [String: AnyObject]?
	open var verbose = false
	
	fileprivate var manager: GIGURLManager
	
	public init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: AnyObject]? = nil, bodyParams: [String: AnyObject]? = nil, verbose: Bool = false) {
		self.method = method
		self.endpoint = endpoint
		self.headers = headers
		self.urlParams = urlParams
		self.bodyParams = bodyParams
		self.verbose = verbose
		
		self.manager = GIGURLManager()
		self.manager.domain = GIGURLDomain(name: "domain", url: baseUrl)
		
		super.init(manager: self.manager)
	}
	
	
	// MARK: - Public Method
	
	open func fetchData(_ completionHandler: @escaping (Response) -> Void) {
		let request = self.buildRequest()
		request.responseClass = self.dataClass()
		
		self.send(request) { urlResponse in
			guard let dataResponse = urlResponse as? GIGURLResponse else {
				completionHandler(Response())
				return
			}
			
			let response = Response(response: dataResponse)
			completionHandler(response)
		}
	}
	
	
	open func fetchJson(_ completionHandler: @escaping (Response) -> Void) {
		let request = self.buildRequest()
		request.responseClass = self.jsonClass()
		
		self.send(request) { urlResponse in
			guard let jsonResponse = urlResponse as? GIGURLJSONResponse else {
				completionHandler(Response())
				return
			}
			
			let response = Response(response: jsonResponse)
			completionHandler(response)
		}
	}
	
	open func fetchImage(_ completionHandler: @escaping (Response) -> Void) {
		let request = self.buildRequest()
		request.responseClass = self.imageClass()
		
		self.send(request) { urlResponse in
			guard let imageResponse = urlResponse as? GIGURLImageResponse else {
				completionHandler(Response())
				return
			}
			
			let response = Response(response: imageResponse)
			completionHandler(response)
		}
	}
	
	
	// MARK: - Private Helpers
	
	fileprivate func buildRequest() -> GIGURLRequest {
		let url = self.buildURL()
		let request = GIGURLRequest(method: self.method, url: url)
		request?.headers = self.headers
		request?.json = self.bodyParams
		request?.logLevel = self.verbose ? .verbose : .none
		
		return request!
	}
	
	fileprivate func buildURL() -> String {
		var url = URLComponents(string: self.manager.domain.url)
		url?.path = (url?.path)! + self.endpoint
		
		url?.queryItems = self.urlParams?.map { key, value in
			URLQueryItem(name: key, value: String(describing: value))
		}
		
		return url?.string ?? "NOT VALID URL"
	}
	
	fileprivate func jsonClass() -> AnyClass {
		let className = NSStringFromClass(GIGURLJSONResponse.self)
		return NSClassFromString(className) as! GIGURLJSONResponse.Type
	}
	
	fileprivate func imageClass() -> AnyClass {
		let className = NSStringFromClass(GIGURLImageResponse.self)
		return NSClassFromString(className) as! GIGURLImageResponse.Type
	}
	
	fileprivate func dataClass() -> AnyClass {
		let className = NSStringFromClass(GIGURLResponse.self)
		return NSClassFromString(className) as! GIGURLResponse.Type
	}
}
