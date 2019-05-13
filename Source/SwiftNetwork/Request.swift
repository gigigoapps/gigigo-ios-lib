//
//  Request.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

public enum StandardType {
    case gigigo
    case basic
}

/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case options = "OPTIONS"
    case head    = "HEAD"
    case patch   = "PATCH"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

open class Request: Selfie {
	
	open var method: String
    open var baseURL: String
	open var completeURL: URL?
	open var endpoint: String
	open var headers: [String: String]?
	open var urlParams: [String: Any]?
	open var bodyParams: [String: Any]?
	open var verbose = false
    open var logInfo: RequestLogInfo?
    open var standardType: StandardType = .gigigo
    open var timeout: TimeInterval = 15.0
    open var cache: NSURLRequest.CachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
	
	private var request: URLRequest?
	private weak var task: URLSessionTask?
    private let reachability: ReachabilityWrapper = ReachabilityWrapper.shared
    
    // TODO , para versiones futuras borrar este metodo
    public convenience init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, timeout: TimeInterval? = nil, verbose: Bool = false) {
        self.init(
            method: method,
            baseUrl: baseUrl,
            endpoint: endpoint,
            headers: headers,
            urlParams: urlParams,
            bodyParams: bodyParams,
            timeout: timeout,
            verbose: verbose,
            standard: .gigigo
        )
    }
    
    public convenience init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, timeout: TimeInterval? = nil, verbose: Bool = false, standard: StandardType = .gigigo) {
        self.init(method: method,
            baseUrl: baseUrl,
            endpoint: endpoint,
            headers: headers,
            urlParams: urlParams,
            bodyParams: bodyParams,
            timeout: timeout,
            verbose: verbose,
            standard: standard,
            logInfo: nil)
    }

    public init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, timeout: TimeInterval? = nil, verbose: Bool = false, standard: StandardType = .gigigo, logInfo: RequestLogInfo? = nil) {
        self.method = method
        self.baseURL = baseUrl
        self.endpoint = endpoint
        self.headers = headers
        self.urlParams = urlParams
        self.bodyParams = bodyParams
        self.timeout = timeout ?? self.timeout
        self.verbose = verbose
        self.standardType = standard
        self.logInfo = logInfo
    }

    public convenience init(method: HTTPMethod, completeURL: URL, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, timeout: TimeInterval? = nil, verbose: Bool = false, standard: StandardType = .gigigo) {
        self.init(method: method,
            completeURL: completeURL, 
            headers: headers, 
            urlParams: urlParams, 
            bodyParams: bodyParams,
            timeout: timeout,
            verbose: verbose,
            standard: standard,
            logInfo: nil)
    }

    public init(method: HTTPMethod, completeURL: URL, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, timeout: TimeInterval? = nil, verbose: Bool = false, standard: StandardType = .gigigo, logInfo: RequestLogInfo? = nil) {
        self.method = method.rawValue
        self.completeURL = completeURL
        self.baseURL = completeURL.absoluteString
        self.endpoint = ""
        self.headers = headers
        self.urlParams = urlParams
        self.bodyParams = bodyParams
        self.timeout = timeout ?? self.timeout
        self.verbose = verbose
        self.standardType = standard
        self.logInfo = logInfo
    }

	open func fetch(completionHandler: @escaping (Response) -> Void) {
		guard let request = self.buildRequest() else { return }
        guard self.reachability.isReachable() else {
            let response = Response.noInternet()
            completionHandler(response)
            return
        }
		self.request = request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = self.timeout
        if #available(iOS 11, *) {
            configuration.waitsForConnectivity = true
        }
        
        self.controlCache(config: configuration)
        
        let session = URLSession(configuration: configuration, delegate: self as? URLSessionDelegate, delegateQueue: nil)
		
		if self.verbose {
            if self.logInfo == nil {
                LogManager.shared.logLevel = .debug
                LogManager.shared.appName = "GIGLibrary"
            }
			self.logRequest()
		}
		
		self.cancel()
        
		self.task = session.dataTask(with: request) { data, urlResponse, error in
            
            defer {
                session.finishTasksAndInvalidate()
            }
            
            let response = Response(data: data, response: urlResponse, error: error, standardType: self.standardType)
			
			if self.verbose {
				response.logResponse(self.logInfo)
			}
			
			DispatchQueue.main.async {
				completionHandler(response)
			}
		}
		
		self.task?.resume()
	}
    
    open func fetch(withDownloadUrlFile: URL, completionHandler: @escaping (Response) -> Void) {
        guard let request = self.buildRequest() else { return }
        guard self.reachability.isReachable() else {
            let response = Response.noInternet()
            completionHandler(response)
            return
        }
        self.request = request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = self.timeout
        if #available(iOS 11, *) {
            configuration.waitsForConnectivity = true
        }
        
        let session = URLSession(configuration: configuration, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        if self.verbose {
            if self.logInfo == nil {
                LogManager.shared.logLevel = .debug
                LogManager.shared.appName = "GIGLibrary"
            }
            self.logRequest()
        }
        
        self.cancel()
        
        self.task = session.downloadTask(with: request) { location, response, error in
            guard let location = location else {
                LogWarn("Location of file is nil")
                completionHandler(Response(data: nil, response: nil, error: ErrorInstantiation.instantiateIntial))
                return
            }
            
            let response = Response(data: nil, response: response, error: error, standardType: StandardType.basic)
            
            do {
                if FileManager.default.fileExists(atPath: withDownloadUrlFile.path) {
                    try FileManager.default.removeItem(at: withDownloadUrlFile)
                }
                try FileManager.default.moveItem(at: location, to: withDownloadUrlFile)
                response.statusCode = 200
            } catch let error {
                LogWarn(error.localizedDescription)
            }
            
            if self.verbose {
                response.logResponse(self.logInfo)
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
    
    private func controlCache(config: URLSessionConfiguration) {
        config.requestCachePolicy = self.cache
        switch self.cache {
        case .reloadIgnoringLocalAndRemoteCacheData, .reloadRevalidatingCacheData, .reloadIgnoringLocalCacheData:
            config.urlCache = nil
        default:
            break
        }
    }
	
    fileprivate func printLog(_ message: String, logInfo: RequestLogInfo) {
        switch logInfo.logLevel {
        case .debug:
            gigLogDebug(message, module: logInfo.module, filename: logInfo.filename, line: logInfo.line, funcname: logInfo.funcname, handler: logInfo.handler)
        case .error:
            gigLogError(NSError(code: 0, message: message), module: logInfo.module, filename: logInfo.filename, line: logInfo.line, funcname: logInfo.funcname, handler: logInfo.handler)
        case .info:
            gigLogInfo(message, module: logInfo.module, filename: logInfo.filename, line: logInfo.line, funcname: logInfo.funcname, handler: logInfo.handler)
        default:
            break
        }
    }
    
	fileprivate func buildRequest() -> URLRequest? {
        var finalURL: URL?
        
        // Compose URL
        if let completeURL = completeURL {
            finalURL = addParams(to: URLComponents(url: completeURL, resolvingAgainstBaseURL: false))
        } else if let urlString = self.buildURL() {
            finalURL = addParams(to: URLComponents(string: urlString))
        }
        
        guard let url = finalURL else { 
            if self.verbose {
                let error = "not a valid URL"
                if let logInfo = self.logInfo {
                    printLog(error, logInfo: logInfo)
                } else {
                    print(error)
                }
            }
            return nil
        }

        // Compose request
		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.timeout)
		request.httpMethod = self.method
		request.allHTTPHeaderFields = self.headers
		
		// Set body is not GET
		if let body = self.bodyParams, self.method != HTTPMethod.get.rawValue {
			request.httpBody = JSON(from: body).toData()
			
			// Add Content-Type if it wasn't set
			if let containsContentType = request.allHTTPHeaderFields?.keys.contains("Content-Type"),
				!containsContentType {
				request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			}
		}
		
		return request
	}
	
    fileprivate func addParams(to urlComponents: URLComponents?) -> URL? {
        guard var urlComponents = urlComponents else { return nil }
        
        if let urlParams = self.urlParams?.map({ key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }) {
            let urlConcat = concat(urlComponents.queryItems, urlParams)
            urlComponents.queryItems = urlConcat
        }
        guard let string = urlComponents.string else { return nil }
        return URL(string: string)
    }
    
    fileprivate func buildURL() -> String? {
        var url = URLComponents(string: self.baseURL)
        url?.path += self.endpoint
        
        return url?.string
    }
	
	fileprivate func logRequest() {
		let url = self.request?.url?.absoluteString ?? "no url set"
		let method = self.request?.httpMethod ?? "no method set"
		
		var log = "\n******** REQUEST ********\n"
		log += " - URL:\t\t\(url)\n"
		log += " - METHOD:\t\(method)\n"
		let body = self.logBody()
		let headers = self.logHeaders()
		log += body + headers + "*************************\n\n"
        
        if let logInfo = self.logInfo {
            printLog(log, logInfo: logInfo)
        } else {
            print(log)
        }
	}
	
	fileprivate func logBody() -> String {
		guard
			let body = self.request?.httpBody,
			let json = try? JSON.dataToJson(body)
			else { return "" }
		
		return " - BODY:\n\(json)\n"
	}
	
	fileprivate func logHeaders() -> String {
		guard let headers = self.request?.allHTTPHeaderFields, !headers.isEmpty else { return "" }
		
		var logString = " - HEADERS: {"
		
		for key in headers.keys {
			if let value = headers[key] {
				logString += "\n\t\t\(key): \(value)"
			}
		}
		
		return logString + "\n}\n"
	}
	
}


func concat(_ lhs: [URLQueryItem]?, _ rhs: [URLQueryItem]?) -> [URLQueryItem] {
	guard let left = lhs else {
		return rhs ?? []
	}
	
	guard let right = rhs else {
		return left
	}
	
	return left + right
}
