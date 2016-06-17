//
//  GIGDateExtensionTests.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 17/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
@testable import GIGLibrary


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
	
	
	// MARK: - Private Helpers
	private func alejandroBirthday() -> NSDate {
		let dateComponents = NSDateComponents()
		dateComponents.day = 24
		dateComponents.month = 1
		dateComponents.year = 1985
		dateComponents.hour = 1 // I don't know why, but 1 is 12 am
		
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
