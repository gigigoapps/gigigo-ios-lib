//
//  NSLocale+GIGExtension.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 24/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public extension Locale {
	
	/// Returns language + region. Example: en-US
    static func currentLanguage() -> String {
		return self.preferredLanguages.first!
	}
	
	/// Returns only language. Expample: es
    static func currentLanguageCode() -> String {
		return self.currentLanguage().components(separatedBy: "-").first!
	}
	
	/// Returns only region. Example: US
    static func currentRegionCode() -> String {
		return self.currentLanguage().components(separatedBy: "-").last!
	}
	
}
