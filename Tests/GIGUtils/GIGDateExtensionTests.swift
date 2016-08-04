//
//  GIGDateExtensionTests.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 17/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
import GIGLibrary


class GIGDateExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	
	// MARK: - DateFromString tests
    func test_returnsNil_whenFormatIsWrong() {
		let dateString = "wrong format"
		
		let date = NSDate.dateFromString(dateString)
		
		XCTAssert(date == nil)
    }
	
	func test_returnsCorrectDate_whenFormatIsCorrect() {
		let dateString = "1985-01-24T00:00:00Z"
		
		let date = NSDate.dateFromString(dateString)
		
		XCTAssert(date != nil)
		XCTAssert(date == alejandroBirthday())
	}
	
	
	// MARK: - Adding days tests
	
	func test_returnsNextDay_whenAddOneDay() {
		let dateString = "1985-01-24T00:00:00Z"
		let date = NSDate.dateFromString(dateString)!
		
		let nextDay = date + 1
		
		XCTAssert(nextDay == alejandroBirthdayNextDay())
	}
	
	func test_returnsPreviusDay_whenSubstractOneDay() {
		let dateString = "1985-01-25T00:00:00Z"
		let date = NSDate.dateFromString(dateString)!
		
		let nextDay = date - 1
		
		XCTAssert(nextDay == alejandroBirthday())
	}
	
	
	/// MARK: - Comparing dates tests
	
	func test_returnsTrue_whenAskIfTomorrowIsGreatherThanToday() {
		let today = NSDate.today()
		let tomorrow = today + 1
		
		XCTAssert(tomorrow > today)
	}
	
	func test_returnsFalse_whenAskIfTodayIsGreatherThanToday() {
		let today = NSDate.today()
		
		XCTAssert((today > today) == false)
	}
	
	func test_returnsTrue_whenAskIfTodayIsMinorThanTomorrow() {
		let today = NSDate.today()
		let tomorrow = today + 1
		
		XCTAssert(today < tomorrow)
	}
	
	func test_returnsFalse_whenAskIfTodayIsLessThanToday() {
		let today = NSDate.today()
		
		XCTAssert((today < today) == false)
	}
	
	
	// MARK: - Setting time tests
	
	func test_returns14PM_whenSetting14PM() {
		let date = self.alejandroBirthday()
		
		let resultDate = try! date.setHour(14)
		
		// THIS TEST ONLY WORKS IN SPAIN (NOT IN CANARY ISLANDS). We should inyect the timezone
		let expectedDate = NSDate.dateFromString("1985-01-24T13:00:00Z")! // UTC+1
		
		
		XCTAssert(resultDate.isEqualToDate(expectedDate), "result: \(resultDate) - expected: \(expectedDate)")
	}
	
	func test_returns14_03_10PM_whenSetting14_59_59PM() {
		let date = self.alejandroBirthday()
		
		let resultDate = try! date.setHour(14, minutes: 59, seconds: 59)
		
		// THIS TEST ONLY WORKS IN SPAIN (NOT IN CANARY ISLANDS). We should inyect the timezone
		let expectedDate = NSDate.dateFromString("1985-01-24T13:59:59Z")! // UTC+1
		
		
		XCTAssert(resultDate.isEqualToDate(expectedDate), "result: \(resultDate) - expected: \(expectedDate)")
	}
	
	func test_throwsError_whenSetting24PM() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(24))
	}
	
	func test_throwsError_whenSetting14_60PM() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: 60))
	}
	
	func test_throwsError_whenSetting14_03_60PM() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: 3, seconds: 60))
	}
	
	func test_throwsError_whenSettingNegativeHour() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(-3))
	}
	
	func test_throwsError_whenSettingNegativeMinutes() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: -10))
	}
	
	func test_throwsError_whenSettingNegativeSeconds() {
		let date = self.alejandroBirthday()
		
		XCTAssertThrowsError(try date.setHour(14, minutes: 3, seconds: -1))
	}
	
	
	// MARK: - Private Helpers
	private func alejandroBirthday() -> NSDate {
		let dateComponents = NSDateComponents()
		dateComponents.day = 24
		dateComponents.month = 1
		dateComponents.year = 1985
		dateComponents.hour = 1
		
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		return calendar!.dateFromComponents(dateComponents)!
	}
	
	private func alejandroBirthdayNextDay() -> NSDate {
		let dateComponents = NSDateComponents()
		dateComponents.day = 25
		dateComponents.month = 1
		dateComponents.year = 1985
		dateComponents.hour = 1 // I don't know why, but 1 is 12 am
		
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		return calendar!.dateFromComponents(dateComponents)!
	}

}
