//
//  KeychainAttributes.swift
//  GIGLibrary
//
//  Created by Jerilyn Gonçalves on 06/03/2020.
//  Copyright © 2020 Gigigo SL. All rights reserved.
//

import Foundation

public struct Attributes {
    
    public var `class`: String? {
        return self.attributes[KeychainConstants.Class] as? String
    }
    public var data: Data? {
        return self.attributes[KeychainConstants.ValueData] as? Data
    }
    public var ref: Data? {
        return self.attributes[KeychainConstants.ValueRef] as? Data
    }
    public var persistentRef: Data? {
        return self.attributes[KeychainConstants.ValuePersistentRef] as? Data
    }
    public var accessible: String? {
        return self.attributes[KeychainConstants.AttributeAccessible] as? String
    }
    public var accessGroup: String? {
        return self.attributes[KeychainConstants.AttributeAccessGroup] as? String
    }
    public var synchronizable: Bool? {
        return self.attributes[KeychainConstants.AttributeSynchronizable] as? Bool
    }
    public var creationDate: Date? {
        return self.attributes[KeychainConstants.AttributeCreationDate] as? Date
    }
    public var modificationDate: Date? {
        return self.attributes[KeychainConstants.AttributeModificationDate] as? Date
    }
    public var attributeDescription: String? {
        return self.attributes[KeychainConstants.AttributeDescription] as? String
    }
    public var comment: String? {
        return self.attributes[KeychainConstants.AttributeComment] as? String
    }
    public var creator: String? {
        return self.attributes[KeychainConstants.AttributeCreator] as? String
    }
    public var type: String? {
        return self.attributes[KeychainConstants.AttributeType] as? String
    }
    public var label: String? {
        return self.attributes[KeychainConstants.AttributeLabel] as? String
    }
    public var isInvisible: Bool? {
        return self.attributes[KeychainConstants.AttributeIsInvisible] as? Bool
    }
    public var isNegative: Bool? {
        return self.attributes[KeychainConstants.AttributeIsNegative] as? Bool
    }
    public var account: String? {
        return self.attributes[KeychainConstants.AttributeAccount] as? String
    }
    public var service: String? {
        return self.attributes[KeychainConstants.AttributeService] as? String
    }
    public var generic: Data? {
        return self.attributes[KeychainConstants.AttributeGeneric] as? Data
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

extension Attributes: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "\(self.attributes)"
    }

    public var debugDescription: String {
        return self.description
    }
}
