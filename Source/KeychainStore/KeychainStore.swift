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

public enum Accessibility {
    /**
     Item data can only be accessed
     while the device is unlocked. This is recommended for items that only
     need be accesible while the application is in the foreground. Items
     with this attribute will migrate to a new device when using encrypted
     backups.
     */
    case whenUnlocked

    /**
     Item data can only be
     accessed once the device has been unlocked after a restart. This is
     recommended for items that need to be accesible by background
     applications. Items with this attribute will migrate to a new device
     when using encrypted backups.
     */
    case afterFirstUnlock

    /**
     Item data can always be accessed
     regardless of the lock state of the device. This is not recommended
     for anything except system use. Items with this attribute will migrate
     to a new device when using encrypted backups.
     */
    case always

    /**
     Item data can only
     be accessed while the device is unlocked. This is recommended for items
     that only need be accesible while the application is in the foreground.
     Items with this attribute will never migrate to a new device, so after
     a backup is restored to a new device, these items will be missing.
     */
    case whenUnlockedThisDeviceOnly

    /**
     Item data can
     only be accessed once the device has been unlocked after a restart.
     This is recommended for items that need to be accessible by background
     applications. Items with this attribute will never migrate to a new
     device, so after a backup is restored to a new device these items will
     be missing.
     */
    case afterFirstUnlockThisDeviceOnly

    /**
     Item data can always
     be accessed regardless of the lock state of the device. This option
     is not recommended for anything except system use. Items with this
     attribute will never migrate to a new device, so after a backup is
     restored to a new device, these items will be missing.
     */
    case alwaysThisDeviceOnly
}

public struct AuthenticationPolicy: OptionSet {
    /**
     User presence policy using Touch ID or Passcode. Touch ID does not
     have to be available or enrolled. Item is still accessible by Touch ID
     even if fingers are added or removed.
     */
    public static let userPresence = AuthenticationPolicy(rawValue: 1 << 0)

    /**
     Constraint: Touch ID (any finger) or Face ID. Touch ID or Face ID must be available. With Touch ID
     at least one finger must be enrolled. With Face ID user has to be enrolled. Item is still accessible by Touch ID even
     if fingers are added or removed. Item is still accessible by Face ID if user is re-enrolled.
     */
    @available(iOS 11.3, *)
    public static let biometryAny = AuthenticationPolicy(rawValue: 1 << 1)

    /**
     Deprecated, please use biometryAny instead.
     */
    @available(iOS, introduced: 9.0, deprecated: 11.3, renamed: "biometryAny")
    public static let touchIDAny = AuthenticationPolicy(rawValue: 1 << 1)

    /**
     Constraint: Touch ID from the set of currently enrolled fingers. Touch ID must be available and at least one finger must
     be enrolled. When fingers are added or removed, the item is invalidated. When Face ID is re-enrolled this item is invalidated.
     */
    @available(iOS 11.3, *)
    public static let biometryCurrentSet = AuthenticationPolicy(rawValue: 1 << 3)

    /**
     Deprecated, please use biometryCurrentSet instead.
     */
    @available(iOS, introduced: 9.0, deprecated: 11.3, renamed: "biometryCurrentSet")
    public static let touchIDCurrentSet = AuthenticationPolicy(rawValue: 1 << 3)

    /**
     Constraint: Device passcode
     */
    @available(iOS 9.0, *)
    public static let devicePasscode = AuthenticationPolicy(rawValue: 1 << 4)

    /**
     Constraint logic operation: when using more than one constraint,
     at least one of them must be satisfied.
     */
    @available(iOS 9.0, *)
    public static let or = AuthenticationPolicy(rawValue: 1 << 14)

    /**
     Constraint logic operation: when using more than one constraint,
     all must be satisfied.
     */
    @available(iOS 9.0, *)
    public static let and = AuthenticationPolicy(rawValue: 1 << 15)

    /**
     Create access control for private key operations (i.e. sign operation)
     */
    @available(iOS 9.0, *)
    public static let privateKeyUsage = AuthenticationPolicy(rawValue: 1 << 30)

    /**
     Security: Application provided password for data encryption key generation.
     This is not a constraint but additional item encryption mechanism.
     */
    @available(iOS 9.0, *)
    public static let applicationPassword = AuthenticationPolicy(rawValue: 1 << 31)

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

public struct Attributes {
    
    public var `class`: String? {
        return self.attributes[Class] as? String
    }
    public var data: Data? {
        return self.attributes[ValueData] as? Data
    }
    public var ref: Data? {
        return self.attributes[ValueRef] as? Data
    }
    public var persistentRef: Data? {
        return self.attributes[ValuePersistentRef] as? Data
    }
    public var accessible: String? {
        return self.attributes[AttributeAccessible] as? String
    }
    public var accessGroup: String? {
        return self.attributes[AttributeAccessGroup] as? String
    }
    public var synchronizable: Bool? {
        return self.attributes[AttributeSynchronizable] as? Bool
    }
    public var creationDate: Date? {
        return self.attributes[AttributeCreationDate] as? Date
    }
    public var modificationDate: Date? {
        return self.attributes[AttributeModificationDate] as? Date
    }
    public var attributeDescription: String? {
        return self.attributes[AttributeDescription] as? String
    }
    public var comment: String? {
        return self.attributes[AttributeComment] as? String
    }
    public var creator: String? {
        return self.attributes[AttributeCreator] as? String
    }
    public var type: String? {
        return self.attributes[AttributeType] as? String
    }
    public var label: String? {
        return self.attributes[AttributeLabel] as? String
    }
    public var isInvisible: Bool? {
        return self.attributes[AttributeIsInvisible] as? Bool
    }
    public var isNegative: Bool? {
        return self.attributes[AttributeIsNegative] as? Bool
    }
    public var account: String? {
        return self.attributes[AttributeAccount] as? String
    }
    public var service: String? {
        return self.attributes[AttributeService] as? String
    }
    public var generic: Data? {
        return self.attributes[AttributeGeneric] as? Data
    }

    fileprivate let attributes: [String: Any]

    init(attributes: [String: Any]) {
        self.attributes = attributes
    }

    public subscript(key: String) -> Any? {
        get {
            return self.attributes[key]
        }
    }
}

open class KeychainStore {

    public var service: String {
        return self.options.service
    }

    // This attribute (kSecAttrAccessGroup) applies to macOS keychain items only if you also set a value of true for the
    // kSecUseDataProtectionKeychain key, the kSecAttrSynchronizable key, or both.
    public var accessGroup: String? {
        return self.options.accessGroup
    }

    public var accessibility: Accessibility {
        return self.options.accessibility
    }

    public var authenticationPolicy: AuthenticationPolicy? {
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

    fileprivate let options: Options

    // MARK: Initializers

    public convenience init() {
        var options = Options()
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            options.service = bundleIdentifier
        }
        self.init(options)
    }

    public convenience init(service: String) {
        var options = Options()
        options.service = service
        self.init(options)
    }

    public convenience init(accessGroup: String) {
        var options = Options()
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            options.service = bundleIdentifier
        }
        options.accessGroup = accessGroup
        self.init(options)
    }

    public convenience init(service: String, accessGroup: String) {
        var options = Options()
        options.service = service
        options.accessGroup = accessGroup
        self.init(options)
    }

    fileprivate init(_ options: Options) {
        self.options = options
    }

    // MARK: Accessibility

    public func accessibility(_ accessibility: Accessibility) -> KeychainStore {
        var options = self.options
        options.accessibility = accessibility
        return KeychainStore(options)
    }

    public func accessibility(_ accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> KeychainStore {
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

        query[MatchLimit] = MatchLimitOne
        query[ReturnData] = kCFBooleanTrue

        query[AttributeAccount] = key

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

        query[MatchLimit] = MatchLimitOne

        query[ReturnData] = kCFBooleanTrue
        query[ReturnAttributes] = kCFBooleanTrue
        query[ReturnRef] = kCFBooleanTrue
        query[ReturnPersistentRef] = kCFBooleanTrue

        query[AttributeAccount] = key

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
        query[AttributeAccount] = key
        if #available(iOS 9.0, *) {
            query[UseAuthenticationUI] = UseAuthenticationUIFail
        } else {
            query[UseNoAuthenticationUI] = kCFBooleanTrue
        }

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            var query = self.options.query()
            query[AttributeAccount] = key

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
        query[AttributeAccount] = key

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
        query[AttributeAccount] = key

        if withoutAuthenticationUI {
            if #available(iOS 9.0, *) {
                query[UseAuthenticationUI] = UseAuthenticationUIFail
            } else {
                query[UseNoAuthenticationUI] = kCFBooleanTrue
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
        query[Class] = ClassGenericPassword
        query[AttributeSynchronizable] = SynchronizableAny
        query[MatchLimit] = MatchLimitAll
        query[ReturnAttributes] = kCFBooleanTrue

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
        query[Class] = ClassGenericPassword
        query[MatchLimit] = MatchLimitAll
        query[ReturnAttributes] = kCFBooleanTrue
        query[ReturnData] = kCFBooleanTrue

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
        query[MatchLimit] = MatchLimitAll
        query[ReturnAttributes] = kCFBooleanTrue
        query[ReturnData] = kCFBooleanTrue

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

            item["class"] = ClassGenericPassword // !!!
            
            if let accessGroup = attributes[AttributeAccessGroup] as? String {
                item["accessGroup"] = accessGroup
            }

            if let service = attributes[AttributeService] as? String {
                item["service"] = service
            }

            if let key = attributes[AttributeAccount] as? String {
                item["key"] = key
            }
            if let data = attributes[ValueData] as? Data {
                if let text = String(data: data, encoding: .utf8) {
                    item["value"] = text
                } else  {
                    item["value"] = data
                }
            }

            if let accessible = attributes[AttributeAccessible] as? String {
                if let accessibility = Accessibility(rawValue: accessible) {
                    item["accessibility"] = accessibility.description
                }
            }
            if let synchronizable = attributes[AttributeSynchronizable] as? Bool {
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

struct Options {
    
    var service: String = ""
    var accessGroup: String? = nil

    var accessibility: Accessibility = .afterFirstUnlock
    var authenticationPolicy: AuthenticationPolicy? // !!!

    var synchronizable: Bool = false

    var label: String?
    var comment: String?

    var authenticationPrompt: String?
    var authenticationContext: AnyObject?

    var attributes = [String: Any]()
}

/** Class Key Constant */
private let Class = String(kSecClass)
private let ClassGenericPassword = String(kSecClassGenericPassword)

/** Attribute Key Constants */
private let AttributeAccessible = String(kSecAttrAccessible)
private let AttributeAccessGroup = String(kSecAttrAccessGroup)
private let AttributeSynchronizable = String(kSecAttrSynchronizable)
private let AttributeCreationDate = String(kSecAttrCreationDate)
private let AttributeModificationDate = String(kSecAttrModificationDate)
private let AttributeDescription = String(kSecAttrDescription)
private let AttributeComment = String(kSecAttrComment)
private let AttributeCreator = String(kSecAttrCreator)
private let AttributeType = String(kSecAttrType)
private let AttributeLabel = String(kSecAttrLabel)
private let AttributeIsInvisible = String(kSecAttrIsInvisible)
private let AttributeIsNegative = String(kSecAttrIsNegative)
private let AttributeAccount = String(kSecAttrAccount)
private let AttributeService = String(kSecAttrService)
private let AttributeGeneric = String(kSecAttrGeneric)
private let SynchronizableAny = kSecAttrSynchronizableAny

/** Search Constants */
private let MatchLimit = String(kSecMatchLimit)
private let MatchLimitOne = kSecMatchLimitOne
private let MatchLimitAll = kSecMatchLimitAll

/** Return Type Key Constants */
private let ReturnData = String(kSecReturnData)
private let ReturnAttributes = String(kSecReturnAttributes)
private let ReturnRef = String(kSecReturnRef)
private let ReturnPersistentRef = String(kSecReturnPersistentRef)

/** Value Type Key Constants */
private let ValueData = String(kSecValueData)
private let ValueRef = String(kSecValueRef)
private let ValuePersistentRef = String(kSecValuePersistentRef)

/** Other Constants */

@available(iOS, introduced: 8.0, deprecated: 9.0, message: "Use a UseAuthenticationUI instead.")
private let UseNoAuthenticationUI = String(kSecUseNoAuthenticationUI)
@available(iOS 9.0, *)
private let UseAuthenticationUI = String(kSecUseAuthenticationUI)
@available(iOS 9.0, *)
private let UseAuthenticationContext = String(kSecUseAuthenticationContext)
@available(iOS 9.0, *)
private let UseAuthenticationUIFail = String(kSecUseAuthenticationUIFail)

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

extension Options {
    
    func query(ignoringAttributeSynchronizable: Bool = true) -> [String: Any] {
        var query = [String: Any]()

        query[Class] = ClassGenericPassword
        query[AttributeService] = self.service

        if let accessGroup = self.accessGroup {
            query[AttributeAccessGroup] = accessGroup
        }
        if ignoringAttributeSynchronizable {
            query[AttributeSynchronizable] = SynchronizableAny
        } else {
            query[AttributeSynchronizable] = self.synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        }

        if #available(iOS 9.0, *) {
            if let authenticationContext = self.authenticationContext {
                query[UseAuthenticationContext] = authenticationContext
            }
        }
        return query
    }

    func attributes(key: String?, value: Data) -> ([String: Any], Error?) {
        var attributes: [String: Any]

        if key != nil {
            attributes = self.query()
            attributes[AttributeAccount] = key
        } else {
            attributes = [String: Any]()
        }

        attributes[ValueData] = value

        if let label = self.label {
            attributes[AttributeLabel] = label
        }
        if let comment = self.comment {
            attributes[AttributeComment] = comment
        }

        attributes[AttributeSynchronizable] = self.synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        return (attributes, nil)
    }
}

extension Attributes: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "\(self.attributes)"
    }

    public var debugDescription: String {
        return self.description
    }
}

extension Accessibility: RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = .whenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = .afterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = .always
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = .whenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = .afterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = .alwaysThisDeviceOnly
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .whenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case .afterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case .always:
            return String(kSecAttrAccessibleAlways)
        case .whenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .afterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .alwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }

    public var description: String {
        switch self {
        case .whenUnlocked:
            return "WhenUnlocked"
        case .afterFirstUnlock:
            return "AfterFirstUnlock"
        case .always:
            return "Always"
        case .whenUnlockedThisDeviceOnly:
            return "WhenUnlockedThisDeviceOnly"
        case .afterFirstUnlockThisDeviceOnly:
            return "AfterFirstUnlockThisDeviceOnly"
        case .alwaysThisDeviceOnly:
            return "AlwaysThisDeviceOnly"
        }
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

