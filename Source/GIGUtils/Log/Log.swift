//
//  Log.swift
//  OrchextraApp
//
//  Created by Alejandro Jiménez Agudo on 19/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

import Foundation


public enum LogLevel: Int {
	/// No log will be shown.
	case None = 0
	
	/// Only warnings and errors.
	case Error = 1
	
	/// Errors and relevant information.
	case Info = 2
	
	/// Request and Responses will be displayed.
	case Debug = 3
}


public func >=(levelA: LogLevel, levelB: LogLevel) -> Bool {
	return levelA.rawValue >= levelB.rawValue
}


public class LogManager {
	public static let shared = LogManager()
	
	public var appName: String?
	public var logLevel: LogLevel = .None
}


public func Log(log: String) {
	guard LogManager.shared.logLevel != .None else { return }
	
	let appName = LogManager.shared.appName ?? "Gigigo Log Manager"
	
	print("\(appName) :: " + log)
}

public func LogInfo(log: String) {
	guard LogManager.shared.logLevel >= .Info else { return }
	
	Log(log)
}

public func LogWarn(message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
	guard LogManager.shared.logLevel >= .Error else { return }
	
	let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
	Log("🚸🚸🚸 WARNING: " + message)
	Log("🚸🚸🚸 ⤷ FROM CALLER: " + caller + "\n")
}

public func LogError(error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
	guard
		LogManager.shared.logLevel >= .Error,
		let err = error
		else { return }
	
	let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
	Log("❌❌❌ ERROR: " + err.localizedDescription)
	Log("❌❌❌ ⤷ FROM CALLER: " + caller)
	Log("❌❌❌ ⤷ USER INFO: \(err.userInfo)\n")
}
