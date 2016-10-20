//
//  Request.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


open class Request: Selfie {
	
	open var method: String
	open var baseURL: String
	open var endpoint: String
	open var headers: [String: String]?
	open var urlParams: [String: Any]?
	open var bodyParams: [String: Any]?
	open var verbose = false
	
	private var request: URLRequest?
	private var task: URLSessionTask?
	
	public init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: AnyHashable]? = nil, bodyParams: [String: AnyHashable]? = nil, verbose: Bool = false) {
		self.method = method
		self.baseURL = baseUrl
		self.endpoint = endpoint
		self.headers = headers
		self.urlParams = urlParams
		self.bodyParams = bodyParams
		self.verbose = verbose
	}
	
	
	// MARK: - Public Method
	
	open func fetch(completionHandler: @escaping (Response) -> Void) {
		guard let request = self.buildRequest() else { return }
		self.request = request
		let session = URLSession.shared
		
		if self.verbose {
			LogManager.shared.logLevel = .debug
			LogManager.shared.appName = "GIGLibrary"
			self.logRequest()
		}
		
		self.cancel()
		self.task = session.dataTask(with: request) { data, urlResponse, error in
			let response = Response(data: data, response: urlResponse, error: error)
			
			if self.verbose {
				response.logResponse()
			}
			
			DispatchQueue.main.async {
				completionHandler(response)
			}
		}
		
		self.task?.resume()
	}
	
	public func cancel() {
		self.task?.cancel()
	}
	
	
	// MARK: - Private Helpers
	
	fileprivate func buildRequest() -> URLRequest? {
		guard let url = URL(string: self.buildURL()) else { LogWarn("not a valid URL"); return nil }

		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
		request.httpMethod = self.method
		request.allHTTPHeaderFields = self.headers
		
		if let body = self.bodyParams, self.method != "GET" {
			request.httpBody = JSON(from: body).toData()
		}
		
		return request
	}
	
	fileprivate func buildURL() -> String {
		var url = URLComponents(string: self.baseURL)
		url?.path = (url?.path)! + self.endpoint
		
		url?.queryItems = self.urlParams?.map { key, value in
			URLQueryItem(name: key, value: String(describing: value))
		}
		
		return url?.string ?? "NOT VALID URL"
	}
	
	fileprivate func logRequest() {
		let url = self.request?.url?.absoluteString ?? "no url set"
		let method = self.request?.httpMethod ?? "no method set"
		
		print("******** REQUEST ********")
		print(" - URL:\t\t\(url)")
		print(" - METHOD:\t\(method)")
		self.logBody()
		self.logHeaders()
		print("*************************\n")
	}
	
	fileprivate func logBody() {
		guard
			let body = self.request?.httpBody,
			let json = try? JSON.dataToJson(body)
			else { return }
		
		print(" - BODY:\n\(json)")
	}
	
	fileprivate func logHeaders() {
		guard let headers = self.request?.allHTTPHeaderFields, !headers.isEmpty else { return }
		
		print(" - HEADERS: {")
		
		for key in headers.keys {
			if let value = headers[key] {
				print("\t\t\(key): \(value)")
			}
		}
		
		print("}")
	}
	
}
