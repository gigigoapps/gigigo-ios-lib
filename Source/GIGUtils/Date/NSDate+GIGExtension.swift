//
//  NSDate+AlwaysOn.swift
//  AlwaysOn
//
//  Created by Alejandro Jiménez Agudo on 22/2/16.
//  Copyright © 2016 Gigigo S.L. All rights reserved.
//

import Foundation


public let DateISOFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

public extension NSDate {
	
	/// Date from string with ISO format.
	public class func dateFromString(dateString: String, format: String = DateISOFormat) -> NSDate? {
		let dateFormat = NSDateFormatter()
		dateFormat.dateFormat = format

		let date = dateFormat.dateFromString(dateString)
		return date
	}
	
}