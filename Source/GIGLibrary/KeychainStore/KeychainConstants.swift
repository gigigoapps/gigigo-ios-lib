//
//  KeychainConstants.swift
//  GIGLibrary
//
//  Created by Jerilyn Gonçalves on 06/03/2020.
//  Copyright © 2020 Gigigo SL. All rights reserved.
//

import Foundation

struct KeychainConstants {
    /** Class Key Constant */
    static let Class = String(kSecClass)
    static let ClassGenericPassword = String(kSecClassGenericPassword)

    /** Attribute Key Constants */
    static let AttributeAccessible = String(kSecAttrAccessible)
    static let AttributeAccessGroup = String(kSecAttrAccessGroup)
    static let AttributeSynchronizable = String(kSecAttrSynchronizable)
    static let AttributeCreationDate = String(kSecAttrCreationDate)
    static let AttributeModificationDate = String(kSecAttrModificationDate)
    static let AttributeDescription = String(kSecAttrDescription)
    static let AttributeComment = String(kSecAttrComment)
    static let AttributeCreator = String(kSecAttrCreator)
    static let AttributeType = String(kSecAttrType)
    static let AttributeLabel = String(kSecAttrLabel)
    static let AttributeIsInvisible = String(kSecAttrIsInvisible)
    static let AttributeIsNegative = String(kSecAttrIsNegative)
    static let AttributeAccount = String(kSecAttrAccount)
    static let AttributeService = String(kSecAttrService)
    static let AttributeGeneric = String(kSecAttrGeneric)
    static let SynchronizableAny = kSecAttrSynchronizableAny

    /** Search Constants */
    static let MatchLimit = String(kSecMatchLimit)
    static let MatchLimitOne = kSecMatchLimitOne
    static let MatchLimitAll = kSecMatchLimitAll

    /** Return Type Key Constants */
    static let ReturnData = String(kSecReturnData)
    static let ReturnAttributes = String(kSecReturnAttributes)
    static let ReturnRef = String(kSecReturnRef)
    static let ReturnPersistentRef = String(kSecReturnPersistentRef)

    /** Value Type Key Constants */
    static let ValueData = String(kSecValueData)
    static let ValueRef = String(kSecValueRef)
    static let ValuePersistentRef = String(kSecValuePersistentRef)

    /** Other Constants */

    @available(iOS, introduced: 8.0, deprecated: 9.0, message: "Use a UseAuthenticationUI instead.")
    static let UseNoAuthenticationUI = String(kSecUseNoAuthenticationUI)
    @available(iOS 9.0, *)
    static let UseAuthenticationUI = String(kSecUseAuthenticationUI)
    @available(iOS 9.0, *)
    static let UseAuthenticationContext = String(kSecUseAuthenticationContext)
    @available(iOS 9.0, *)
    static let UseAuthenticationUIFail = String(kSecUseAuthenticationUIFail)
}
