//
//  NSDate+AlwaysOn.swift
//  AlwaysOn
//
//  Created by Alejandro Jiménez Agudo on 22/2/16.
//  Copyright © 2016 Gigigo S.L. All rights reserved.
//

import Foundation


public let DateISOFormat = "yyyy-MM-dd'T'HH:mm:ssZ"


/**
Error type for invalid values

Cases:
* InvalidHour: Throws when the hour set is not in 0..24 range
* InvalidMinutes: Throws when the hour set is not in 0..60 range
* InvalidSeconds: Throws when the hour set is not in 0..60 range

- Author: Alejandro Jiménez
- Since: 1.1.3
*/
public enum ErrorDate: ErrorType {
	case InvalidHour
	case InvalidMinutes
	case InvalidSeconds
}

public extension NSDate {
	
	/// Date from string with ISO format.
	public class func dateFromString(dateString: String, format: String = DateISOFormat) -> NSDate? {
		let dateFormat = NSDateFormatter()
		dateFormat.dateFormat = format

		let date = dateFormat.dateFromString(dateString)
		return date
	}
	
	public class func today() -> NSDate {
		return NSDate()
	}
	
	
	/**
	Set the time to a NSDate
	
	- parameters:
		- hour: The hour to be set
		- minutes: The minutes to be set. Optional, 0 by default
		- seconds: The seconds to be set. Optional, 0 by default
	
	- important: The time is set in local time respecting the user time zone.
	Examples (in Spain):
	* setHour(14) to a summer date (UTC+2) returns -> 12:00:00 +0000
	* setHour(14) to a winter date (UTC+1) returns -> 13:00:00 +0000
	
	- throws: An error of type ErrorDate
	- returns: A new NSDate with the same date and the time set.
	- Author: Alejandro Jiménez
	- Since: 1.1.3
	*/
	public func setHour(hour: Int, minutes: Int = 0, seconds: Int = 0) throws -> NSDate {
		guard 0 <= hour && hour < 24			else { throw ErrorDate.InvalidHour }
		guard 0 <= minutes && minutes < 60	else { throw ErrorDate.InvalidMinutes }
		guard 0 <= seconds && seconds < 60	else { throw ErrorDate.InvalidSeconds }
		
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let components = calendar.components(([.Day, .Month, .Year]), fromDate: self)
		components.hour = hour
		components.minute = minutes
		components.second = seconds
		
		return calendar.dateFromComponents(components)!
	}
	
}


/// Add days to a date
public func +(date: NSDate, days: Int) -> NSDate {
	let newDate = date.dateByAddingDays(days)
	return newDate
}

/// Substract days to a date
public func -(date: NSDate, days: Int) -> NSDate {
	let newDate = date + (-days)
	return newDate
}


public func >(lhs: NSDate, rhs: NSDate) -> Bool {
	let result = lhs.compare(rhs)
	
	switch result {
	case .OrderedDescending:
		return true
	
	default:
		return false
	}
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
	let result = lhs.compare(rhs)
	
	switch result {
	case .OrderedAscending:
		return true
		
	default:
		return false
	}
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
	let result = lhs.compare(rhs)
	
	switch result {
	case .OrderedSame:
		return true
		
	default:
		return false
	}
}
