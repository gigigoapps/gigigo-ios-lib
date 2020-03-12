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
    case none = 0
    
    /// Only warnings and errors.
    case error = 1
    
    /// Errors and relevant information.
    case info = 2
    
    /// Request and Responses will be displayed.
    case debug = 3
}

public enum LogStyle: Int {
    
    /// Profesional style no emojis
    case  none = 0
    
    /// Funny style with emojis
    case funny = 1
}


public func >=(levelA: LogLevel, levelB: LogLevel) -> Bool {
    return levelA.rawValue >= levelB.rawValue
}

public protocol LoggableModule {
    static var Identifier: String { get }
}

public extension LoggableModule {
    static var Identifier: String {
        return String(describing: self)
    }
}

public class LogManagerSettings {
    open var logLevel: LogLevel
    open var logStyle: LogStyle
    open var moduleName: String?
    
    public init(moduleName: String? = nil, logLevel: LogLevel = .none, logStyle: LogStyle = .none) {
        self.moduleName = moduleName
        self.logLevel = logLevel
        self.logStyle = logStyle
    }
}

public class LogManager {
    public static let shared = LogManager()
    public var defaultSettings: LogManagerSettings
    
    private var settingsById: [String: LogManagerSettings]
    private var modules: [LoggableModule.Type]
    private let queue: DispatchQueue
    
    private init() {
        self.defaultSettings = LogManagerSettings()
        self.settingsById = [String: LogManagerSettings]()
        self.modules = [LoggableModule.Type]()
        self.queue = DispatchQueue(label: "com.gigigo.log", qos: .utility)
    }
    
    public var logLevel: LogLevel {
        get {
            return self.defaultSettings.logLevel
        }
        set {
            self.defaultSettings.logLevel = newValue
        }
    }
    
    public var appName: String? {
        get {
            return self.defaultSettings.moduleName
        }
        set {
            self.defaultSettings.moduleName = newValue
        }
    }
    
    public var logStyle: LogStyle {
        get {
            return self.defaultSettings.logStyle
        }
        set {
            self.defaultSettings.logStyle = newValue
        }
    }
    
    public func setLogValues(logLevel: LogLevel = .none, logStyle: LogStyle = .none, forModule module: LoggableModule.Type) throws {
        try self.queue.sync {
            try self.setLogValuesNonSynchronized(logLevel: logLevel, logStyle: logStyle, forModule: module)
        }
    }
    
    public func setLogLevel(_ logLevel: LogLevel = .none, forModule module: LoggableModule.Type) throws {
        try self.queue.sync {
            guard let settings = self.settingsForModuleNonSynchronized(module) else {
                try self.setLogValuesNonSynchronized(logLevel: logLevel, forModule: module)
                return
            }
            try self.setLogValuesNonSynchronized(logLevel: logLevel, logStyle: settings.logStyle, forModule: module)
        }
    }
    
    public func logLevel(forModule module: LoggableModule.Type) -> LogLevel? {
        return self.queue.sync {
            return self.settingsForModuleNonSynchronized(module)?.logLevel
        }
    }
    
    public func setLogStyle(_ logStyle: LogStyle = .none, forModule module: LoggableModule.Type) throws {
        try self.queue.sync {
            guard let settings = self.settingsForModuleNonSynchronized(module) else {
                try self.setLogValuesNonSynchronized(logStyle: logStyle, forModule: module)
                return
            }
            try self.setLogValuesNonSynchronized(logLevel: settings.logLevel, logStyle: logStyle, forModule: module)
        }
    }
    
    public func logStyle(forModule module: LoggableModule.Type) -> LogStyle? {
        return self.queue.sync {
            return self.settingsForModuleNonSynchronized(module)?.logStyle
        }
    }
    
    // SETTINGS SECTION
    
    public func settingsForModule(_ module: LoggableModule.Type) -> LogManagerSettings? {
        return self.queue.sync {
            return self.settingsForModuleNonSynchronized(module)
        }
    }
    
    public func removeSettingsForModule(_ module: LoggableModule.Type) {
        self.queue.sync {
            self.removeSettingsNonSynchronized(module)
        }
    }
    
    public var currentModules: [LoggableModule.Type] {
        return self.queue.sync {
            return self.modules.map({ $0 })
        }
    }
    
    public func addSettings(_ settings: LogManagerSettings, forModule module: LoggableModule.Type) throws {
        try self.queue.sync {
            try self.addSettignsNonSynchonized(settings, forModule: module)
        }
    }
    
    // LOG FUNCTIONS
    
    public func log(_ module: LoggableModule.Type?, message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
        self.queue.sync {
            let settings = self.getSettingsForModuleNonSynchronized(module)
            guard settings.logLevel != .none else { return }
            let moduleName = settings.moduleName ?? module?.Identifier ?? "Gigigo Log Manager"
            let debugMessage = "[\(moduleName)]::" + message
            print(debugMessage)
            handler?(debugMessage)
        }
    }
    
    public func logInfo(_ module: LoggableModule.Type?, message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
        self.queue.sync {
            let settings = self.getSettingsForModuleNonSynchronized(module)
            guard settings.logLevel >= .info else { return }
            let moduleName = settings.moduleName ?? module?.Identifier ?? "Gigigo Log Manager"
            let className = filename.lastPathComponent.components(separatedBy: ".").first!
            let emoji = (settings.logStyle == .funny) ? " ⓘ" : ""
            let caller = "[Info\(emoji)] \(className)(\(line)) - \(funcname): "
            let debugMessage = "[\(moduleName)]::\(caller)::" + message
            print(debugMessage)
            handler?(debugMessage)
        }
    }
    
    public func logDebug(_ module: LoggableModule.Type?, message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
        self.queue.sync {
            let settings = self.getSettingsForModuleNonSynchronized(module)
            guard settings.logLevel >= .debug else { return }
            let moduleName = settings.moduleName ?? module?.Identifier ?? "Gigigo Log Manager"
            let className = filename.lastPathComponent.components(separatedBy: ".").first!
            let emoji = (settings.logStyle == .funny) ? " 🐛" : ""
            let caller = "[Debug\(emoji)] \(className)(\(line)) - \(funcname): "
            let debugMessage = "[\(moduleName)]::\(caller)::" + message
            print(debugMessage)
            handler?(debugMessage)
        }
    }
    
    public func logError(_ module: LoggableModule.Type?, error: Error?, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
        self.queue.sync {
            let settings = self.getSettingsForModuleNonSynchronized(module)
            guard settings.logLevel >= .error,
                let err = error
                else { return }
            let moduleName = settings.moduleName ?? module?.Identifier ?? "Gigigo Log Manager"
            let className = filename.lastPathComponent.components(separatedBy: ".").first!
            let emoji = (settings.logStyle == .funny) ? " 🔥" : ""
            let caller = "[Error\(emoji)] \(className)(\(line)) - \(funcname): \(err.localizedDescription)"
            let debugMessage = "[\(moduleName)]::\(caller)"
            print(debugMessage)
            handler?(debugMessage)
        }
    }
    
    public func logWarn(_ module: LoggableModule.Type?, message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
        self.queue.sync {
            let settings = self.getSettingsForModuleNonSynchronized(module)
            guard settings.logLevel >= .error else { return }
            let moduleName = settings.moduleName ?? module?.Identifier ?? "Gigigo Log Manager"
            let className = filename.lastPathComponent.components(separatedBy: ".").first!
            let emoji = (settings.logStyle == .funny) ? " 🔥" : ""
            let caller = "[Warn\(emoji)] \(className)(\(line)) - \(funcname): "
            let debugMessage = "[\(moduleName)]::\(caller)::" + message
            print(debugMessage)
            handler?(debugMessage)
        }
    }
    
    //PRIVATE SECTION
    
    private func getSettingsForModuleNonSynchronized(_ module: LoggableModule.Type?) -> LogManagerSettings {
        var settings: LogManagerSettings! = self.defaultSettings
        if let moduleUnwrap = module, let moduleSettings = self.settingsForModuleNonSynchronized(moduleUnwrap) {
            settings = moduleSettings
        }
        return settings
    }
    
    private func settingsForModuleNonSynchronized(_ module: LoggableModule.Type) -> LogManagerSettings? {
        return self.settingsById[module.Identifier]
    }
    
    private func removeSettingsNonSynchronized(_ module: LoggableModule.Type) {
        guard let index = self.modules.firstIndex(where: { $0.Identifier == module.Identifier }) else { return }
        self.modules.remove(at: index)
        self.settingsById.removeValue(forKey: module.Identifier)
    }
    
    private func addSettignsNonSynchonized(_ settings: LogManagerSettings, forModule module: LoggableModule.Type) throws {
        guard self.settingsForModuleNonSynchronized(module) == nil else {
			throw NSError.errorWith(code: 200, message: "Repeated module \(String(describing: module)) with identifier  \(module.Identifier)")
        }
        self.modules.append(module)
        self.settingsById.updateValue(settings, forKey: module.Identifier)
    }
    
    private func setLogValuesNonSynchronized(logLevel: LogLevel = .none, logStyle: LogStyle = .none, forModule module: LoggableModule.Type) throws {
        guard let settings = self.settingsForModuleNonSynchronized(module) else {
            let settings = LogManagerSettings(logLevel: logLevel, logStyle: logStyle)
            try self.addSettignsNonSynchonized(settings, forModule: module)
            return
        }
        settings.logLevel = logLevel
        settings.logStyle = logStyle
        self.removeSettingsNonSynchronized(module)
        try self.addSettignsNonSynchonized(settings, forModule: module)
    }
}

// COMPATIBILITY LOG METHODS

public func Log(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    gigLog(log, module: nil, filename: filename, line: line, funcname: funcname)
}

public func LogInfo(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    gigLogInfo(log, module: nil, filename: filename, line: line, funcname: funcname)
}

public func LogDebug(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    gigLogDebug(log, module: nil, filename: filename, line: line, funcname: funcname)
}

public func LogWarn(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    gigLogWarn(log, module: nil, filename: filename, line: line, funcname: funcname)
}

public func LogError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    gigLogError(error, module: nil, filename: filename, line: line, funcname: funcname)
}

// NEW LOG METHODS

public func gigLog(_ log: String, module: LoggableModule.Type? = nil, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
    LogManager.shared.log(module, message: log, filename: filename, line: line, funcname: funcname, handler: handler)
}

public func gigLogInfo(_ log: String, module: LoggableModule.Type? = nil, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
    LogManager.shared.logInfo(module, message: log, filename: filename, line: line, funcname: funcname, handler: handler)
}

public func gigLogDebug(_ log: String, module: LoggableModule.Type? = nil, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
    LogManager.shared.logDebug(module, message: log, filename: filename, line: line, funcname: funcname, handler: handler)
}   

public func gigLogWarn(_ message: String, module: LoggableModule.Type? = nil, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
    LogManager.shared.logWarn(module, message: message, filename: filename, line: line, funcname: funcname, handler: handler)
}

public func gigLogError(_ error: Error?, module: LoggableModule.Type? = nil, filename: NSString = #file, line: Int = #line, funcname: String = #function, handler: ((String) -> Void)? = nil) {
    LogManager.shared.logError(module, error: error, filename: filename, line: line, funcname: funcname, handler: handler)
}
