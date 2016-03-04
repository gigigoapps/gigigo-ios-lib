//
//  NSLocale+GIGExtension.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 24/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public extension NSLocale {
	
	/// Returns language + region. Example: en-US
	public class func currentLanguage() -> String {
		return self.preferredLanguages().first!
	}
	
	/// Returns only language. Expample: es
	public class func currentLanguageCode() -> String {
		return self.currentLanguage().componentsSeparatedByString("-").first!
	}
	
	/// Returns only region. Example: US
	public class func currentRegionCode() -> String {
		return self.currentLanguage().componentsSeparatedByString("-").last!
	}
	
}
