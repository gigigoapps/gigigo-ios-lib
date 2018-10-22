//
//  RequestLogInfo.swift
//  GIGLibrary
//
//  Created by Pablo Viciano Negre on 07/09/2018.
//  Copyright © 2018 Gigigo SL. All rights reserved.
//

import Foundation

public protocol RequestLogInfo {
    var filename: NSString { get }
    var line: Int { get }
    var funcname: String { get }
    var logLevel: LogLevel { get }
    var module: LoggableModule.Type { get }
}

public struct DefaultRequestLogInfo: RequestLogInfo {
    public let module: LoggableModule.Type
    public let filename: NSString
    public let line: Int
    public let funcname: String
    public let logLevel: LogLevel
    
    public init(module: LoggableModule.Type, logLevel: LogLevel = .none, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
        self.module = module
        self.logLevel = logLevel
        self.filename = filename
        self.line = line
        self.funcname = funcname
    }
}
