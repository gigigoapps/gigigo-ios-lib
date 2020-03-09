//
//  KeychainOptions.swift
//  GIGLibrary
//
//  Created by Jerilyn Gonçalves on 06/03/2020.
//  Copyright © 2020 Gigigo SL. All rights reserved.
//

import Foundation

struct KeychainOptions {
    
    var service: String = ""
    var accessGroup: String? = nil

    var accessibility: KeychainAccessibility = .afterFirstUnlock
    var authenticationPolicy: KeychainAuthenticationPolicy?

    var synchronizable: Bool = false

    var label: String?
    var comment: String?

    var authenticationPrompt: String?
    var authenticationContext: AnyObject?

    var attributes = [String: Any]()
}


extension KeychainOptions {
    
    func query(ignoringAttributeSynchronizable: Bool = true) -> [String: Any] {
        var query = [String: Any]()

        query[KeychainConstants.Class] = KeychainConstants.ClassGenericPassword
        query[KeychainConstants.AttributeService] = self.service

        if let accessGroup = self.accessGroup {
            query[KeychainConstants.AttributeAccessGroup] = accessGroup
        }
        if ignoringAttributeSynchronizable {
            query[KeychainConstants.AttributeSynchronizable] = KeychainConstants.SynchronizableAny
        } else {
            query[KeychainConstants.AttributeSynchronizable] = self.synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        }

        if #available(iOS 9.0, *) {
            if let authenticationContext = self.authenticationContext {
                query[KeychainConstants.UseAuthenticationContext] = authenticationContext
            }
        }
        return query
    }

    func attributes(key: String?, value: Data) -> ([String: Any], Error?) {
        var attributes: [String: Any]

        if key != nil {
            attributes = self.query()
            attributes[KeychainConstants.AttributeAccount] = key
        } else {
            attributes = [String: Any]()
        }

        attributes[KeychainConstants.ValueData] = value

        if let label = self.label {
            attributes[KeychainConstants.AttributeLabel] = label
        }
        if let comment = self.comment {
            attributes[KeychainConstants.AttributeComment] = comment
        }

        attributes[KeychainConstants.AttributeSynchronizable] = self.synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        return (attributes, nil)
    }
}
