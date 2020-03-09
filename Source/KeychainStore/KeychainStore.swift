//
//  KeychainStore.swift
//  GIGLibrary
//
//  Created by Jerilyn Gonçalves on 05/03/2020.
//  Copyright © 2020 Gigigo SL. All rights reserved.
//

import Foundation
import Security
import LocalAuthentication

open class KeychainStore {

    public var service: String {
        return self.options.service
    }

    // This attribute (kSecAttrAccessGroup) applies to macOS keychain items only if you also set a value of true for the
    // kSecUseDataProtectionKeychain key, the kSecAttrSynchronizable key, or both.
    public var accessGroup: String? {
        return self.options.accessGroup
    }

    public var accessibility: KeychainAccessibility {
        return self.options.accessibility
    }

    public var authenticationPolicy: KeychainAuthenticationPolicy? {
        return self.options.authenticationPolicy
    }

    public var synchronizable: Bool {
        return self.options.synchronizable
    }

    public var label: String? {
        return self.options.label
    }

    public var comment: String? {
        return self.options.comment
    }

    public var authenticationPrompt: String? {
        return self.options.authenticationPrompt
    }

    @available(iOS 9.0, *)
    public var authenticationContext: LAContext? {
        return self.options.authenticationContext as? LAContext
    }

    fileprivate let options: KeychainOptions

    // MARK: Initializers

    public convenience init() {
        var options = KeychainOptions()
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            options.service = bundleIdentifier
        }
        self.init(options)
    }

    public convenience init(service: String) {
        var options = KeychainOptions()
        options.service = service
        self.init(options)
    }

    public convenience init(accessGroup: String) {
        var options = KeychainOptions()
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            options.service = bundleIdentifier
        }
        options.accessGroup = accessGroup
        self.init(options)
    }

    public convenience init(service: String, accessGroup: String) {
        var options = KeychainOptions()
        options.service = service
        options.accessGroup = accessGroup
        self.init(options)
    }

    fileprivate init(_ options: KeychainOptions) {
        self.options = options
    }

    // MARK: Accessibility

    public func accessibility(_ accessibility: KeychainAccessibility) -> KeychainStore {
        var options = self.options
        options.accessibility = accessibility
        return KeychainStore(options)
    }

    public func accessibility(_ accessibility: KeychainAccessibility, authenticationPolicy: KeychainAuthenticationPolicy) -> KeychainStore {
        var options = self.options
        options.accessibility = accessibility
        options.authenticationPolicy = authenticationPolicy
        return KeychainStore(options)
    }

    public func synchronizable(_ synchronizable: Bool) -> KeychainStore {
        var options = self.options
        options.synchronizable = synchronizable
        return KeychainStore(options)
    }

    public func label(_ label: String) -> KeychainStore {
        var options = self.options
        options.label = label
        return KeychainStore(options)
    }

    public func comment(_ comment: String) -> KeychainStore {
        var options = self.options
        options.comment = comment
        return KeychainStore(options)
    }

    public func attributes(_ attributes: [String: Any]) -> KeychainStore {
        var options = self.options
        attributes.forEach { options.attributes.updateValue($1, forKey: $0) }
        return KeychainStore(options)
    }

    public func authenticationPrompt(_ authenticationPrompt: String) -> KeychainStore {
        var options = self.options
        options.authenticationPrompt = authenticationPrompt
        return KeychainStore(options)
    }

    @available(iOS 9.0, *)
    public func authenticationContext(_ authenticationContext: LAContext) -> KeychainStore {
        var options = self.options
        options.authenticationContext = authenticationContext
        return KeychainStore(options)
    }

    // MARK: Getters

    public func get(_ key: String, ignoringAttributeSynchronizable: Bool = true) throws -> String? {
        return try getString(key, ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
    }

    public func getString(_ key: String, ignoringAttributeSynchronizable: Bool = true) throws -> String? {
        guard let data = try getData(key, ignoringAttributeSynchronizable: ignoringAttributeSynchronizable) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else {
            throw Status.conversionError
        }
        return string
    }

    public func getData(_ key: String, ignoringAttributeSynchronizable: Bool = true) throws -> Data? {
        var query = self.options.query(ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)

        query[KeychainConstants.MatchLimit] = KeychainConstants.MatchLimitOne
        query[KeychainConstants.ReturnData] = kCFBooleanTrue

        query[KeychainConstants.AttributeAccount] = key

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data else { throw Status.unexpectedError }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw self.securityError(status: status)
        }
    }

    public func get<T>(_ key: String, ignoringAttributeSynchronizable: Bool = true, handler: (Attributes?) -> T) throws -> T {
        var query = options.query(ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)

        query[KeychainConstants.MatchLimit] = KeychainConstants.MatchLimitOne

        query[KeychainConstants.ReturnData] = kCFBooleanTrue
        query[KeychainConstants.ReturnAttributes] = kCFBooleanTrue
        query[KeychainConstants.ReturnRef] = kCFBooleanTrue
        query[KeychainConstants.ReturnPersistentRef] = kCFBooleanTrue

        query[KeychainConstants.AttributeAccount] = key

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let attributes = result as? [String: Any] else { throw Status.unexpectedError }
            return handler(Attributes(attributes: attributes))
        case errSecItemNotFound:
            return handler(nil)
        default:
            throw self.securityError(status: status)
        }
    }

    // MARK: Setters

    public func set(_ value: String, key: String, ignoringAttributeSynchronizable: Bool = true) throws {
        guard let data = value.data(using: .utf8, allowLossyConversion: false) else { throw Status.conversionError }
        try self.set(data, key: key, ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
    }

    public func set(_ value: Data, key: String, ignoringAttributeSynchronizable: Bool = true) throws {
        var query = self.options.query(ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
        query[KeychainConstants.AttributeAccount] = key
        if #available(iOS 9.0, *) {
            query[KeychainConstants.UseAuthenticationUI] = KeychainConstants.UseAuthenticationUIFail
        } else {
            query[KeychainConstants.UseNoAuthenticationUI] = kCFBooleanTrue
        }

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            var query = self.options.query()
            query[KeychainConstants.AttributeAccount] = key

            var (attributes, error) = self.options.attributes(key: nil, value: value)
            if let error = error { throw error }

            self.options.attributes.forEach { attributes.updateValue($1, forKey: $0) }

            if status == errSecInteractionNotAllowed && floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_8_0) {
                try self.remove(key)
                try self.set(value, key: key)
            } else {
                status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
                if status != errSecSuccess {
                    throw self.securityError(status: status)
                }
            }
        case errSecItemNotFound:
            var (attributes, error) = self.options.attributes(key: key, value: value)
            if let error = error {
                throw error
            }

            self.options.attributes.forEach { attributes.updateValue($1, forKey: $0) }

            status = SecItemAdd(attributes as CFDictionary, nil)
            if status != errSecSuccess {
                throw self.securityError(status: status)
            }
        default:
            throw self.securityError(status: status)
        }
    }

    public subscript(key: String) -> String? {
        get {
            return try? self.get(key)
        }

        set {
            if let value = newValue {
                do { try self.set(value, key: key) } catch {}
            } else {
                do { try self.remove(key) } catch {}
            }
        }
    }

    public subscript(string key: String) -> String? {
        get {
            return self[key]
        }

        set {
            self[key] = newValue
        }
    }

    public subscript(data key: String) -> Data? {
        get {
            return try? self.getData(key)
        }

        set {
            if let value = newValue {
                do { try self.set(value, key: key) } catch {}
            } else {
                do { try self.remove(key) } catch {}
            }
        }
    }

    public subscript(attributes key: String) -> Attributes? {
        get {
            return try? self.get(key) { $0 }
        }
    }

    // MARK: Deletion

    public func remove(_ key: String, ignoringAttributeSynchronizable: Bool = true) throws {
        var query = self.options.query(ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
        query[KeychainConstants.AttributeAccount] = key

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw self.securityError(status: status)
        }
    }

    public func removeAll() throws {
        let status = SecItemDelete(self.options.query() as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw self.securityError(status: status)
        }
    }

    // MARK: Contains

    public func contains(_ key: String, withoutAuthenticationUI: Bool = false) throws -> Bool {
        var query = self.options.query()
        query[KeychainConstants.AttributeAccount] = key

        if withoutAuthenticationUI {
            if #available(iOS 9.0, *) {
                query[KeychainConstants.UseAuthenticationUI] = KeychainConstants.UseAuthenticationUIFail
            } else {
                query[KeychainConstants.UseNoAuthenticationUI] = kCFBooleanTrue
            }
        }
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
                return true
        case errSecInteractionNotAllowed:
            if withoutAuthenticationUI {
                return true
            }
            return false
        case errSecItemNotFound:
            return false
        default:
            throw securityError(status: status)
        }
    }

    // MARK: Items

    public class func allKeys() -> [(String, String)] {
        var query = [String: Any]()
        query[KeychainConstants.Class] = KeychainConstants.ClassGenericPassword
        query[KeychainConstants.AttributeSynchronizable] = KeychainConstants.SynchronizableAny
        query[KeychainConstants.MatchLimit] = KeychainConstants.MatchLimitAll
        query[KeychainConstants.ReturnAttributes] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            if let items = result as? [[String: Any]] {
                return self.prettify(items: items).map {
                    return (($0["service"] ?? "") as! String, ($0["key"] ?? "") as! String)
                }
            }
        case errSecItemNotFound:
            return []
        default: ()
        }

        self.securityError(status: status)
        return []
    }

    public func allKeys() -> [String] {
        let allItems = type(of: self).prettify(items: self.items())
        let filter: ([String: Any]) -> String? = { $0["key"] as? String }

        return allItems.compactMap(filter)
    }

    public class func allItems() -> [[String: Any]] {
        var query = [String: Any]()
        query[KeychainConstants.Class] = KeychainConstants.ClassGenericPassword
        query[KeychainConstants.MatchLimit] = KeychainConstants.MatchLimitAll
        query[KeychainConstants.ReturnAttributes] = kCFBooleanTrue
        query[KeychainConstants.ReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            if let items = result as? [[String: Any]] {
                return self.prettify(items: items)
            }
        case errSecItemNotFound:
            return []
        default: ()
        }

        securityError(status: status)
        return []
    }

    public func allItems() -> [[String: Any]] {
        return type(of: self).prettify(items: items())
    }

    // MARK: Private helpers

    fileprivate func items() -> [[String: Any]] {
        var query = self.options.query()
        query[KeychainConstants.MatchLimit] = KeychainConstants.MatchLimitAll
        query[KeychainConstants.ReturnAttributes] = kCFBooleanTrue
        query[KeychainConstants.ReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            if let items = result as? [[String: Any]] {
                return items
            }
        case errSecItemNotFound:
            return []
        default: ()
        }

        self.securityError(status: status)
        return []
    }

    fileprivate class func prettify(items: [[String: Any]]) -> [[String: Any]] {
        let items = items.map { attributes -> [String: Any] in
            var item = [String: Any]()

            item["class"] = KeychainConstants.ClassGenericPassword
            
            if let accessGroup = attributes[KeychainConstants.AttributeAccessGroup] as? String {
                item["accessGroup"] = accessGroup
            }

            if let service = attributes[KeychainConstants.AttributeService] as? String {
                item["service"] = service
            }

            if let key = attributes[KeychainConstants.AttributeAccount] as? String {
                item["key"] = key
            }
            if let data = attributes[KeychainConstants.ValueData] as? Data {
                if let text = String(data: data, encoding: .utf8) {
                    item["value"] = text
                } else  {
                    item["value"] = data
                }
            }

            if let accessible = attributes[KeychainConstants.AttributeAccessible] as? String {
                if let accessibility = KeychainAccessibility(rawValue: accessible) {
                    item["accessibility"] = accessibility.description
                }
            }
            if let synchronizable = attributes[KeychainConstants.AttributeSynchronizable] as? Bool {
                item["synchronizable"] = synchronizable ? "true" : "false"
            }

            return item
        }
        return items
    }

    @discardableResult
    fileprivate class func securityError(status: OSStatus) -> Error {
        let error = Status(status: status)
        return error
    }

    @discardableResult
    fileprivate func securityError(status: OSStatus) -> Error {
        return type(of: self).securityError(status: status)
    }
}

extension KeychainStore: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        let items = allItems()
        if items.isEmpty {
            return "[]"
        }
        var description = "[\n"
        for item in items {
            description += "  "
            description += "\(item)\n"
        }
        description += "]"
        return description
    }

    public var debugDescription: String {
        return "\(items())"
    }
}

extension CFError {
    
    var error: NSError {
        let domain = CFErrorGetDomain(self) as String
        let code = CFErrorGetCode(self)
        let userInfo = CFErrorCopyUserInfo(self) as! [String: Any]

        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
