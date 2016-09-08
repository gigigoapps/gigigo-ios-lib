//
//  GIGParseJsonTests.swift
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/9/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
import GIGLibrary

class GIGParseJsonTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_correct_format_json() {
        let dateString = "1985-01-25T00:00:00Z"
        
        let json: JSON = JSON(json: [
            "string": "Text",
            "int": 12,
            "bool": true,
            "date": dateString,
            "double": 22.1,
            "dictionary": ["key":"value"]
            ])
        
        XCTAssertTrue(json["string"]!.toString() == "Text")
        XCTAssertTrue(json["int"]!.toInt() == 12)
        XCTAssertTrue(json["bool"]!.toBool()!)
        XCTAssertTrue(json["date"]!.toDate() == NSDate.dateFromString(dateString)!)
        XCTAssertTrue(json["double"]!.toDouble() == 22.1)
        
        let dic = json["dictionary"]!.toDictionary()
        XCTAssertTrue (dic?.count > 0)
        XCTAssertTrue(dic!["key"] as! String == "value")
    }
    
    func test_incorrect_format_json() {
        let dateString = "1985-02-25T00:00:00Z"
        
        let json: JSON = JSON(json: [
            "string": "Text",
            "int": 11,
            "bool": false,
            "date": "1985-03-25T00:00:00Z",
            "double": 222.1,
            "dictionary": [:],
            "stringFake": 12,
            "intFake": "",
            "boolFake": 12,
            "dateFake": 12,
            "doubleFake": "double"
            ])
        
        
        XCTAssertFalse(json["string"]!.toString() == "Text2")
        XCTAssertFalse(json["int"]!.toInt() == 12)
        XCTAssertFalse(json["bool"]!.toBool()!)
        XCTAssertFalse(json["date"]!.toDate()! == NSDate.dateFromString(dateString)!)
        XCTAssertFalse(json["double"]!.toDouble() == 22.1)
        
        let dic = json["dictionary"]!.toDictionary()
        XCTAssertFalse (dic?.count > 0)
        
        XCTAssertNil(json["stringFake"]!.toString())
        XCTAssertNil(json["intFake"]!.toInt())
        XCTAssertNil(json["doubleFake"]!.toDouble())
        XCTAssertNil(json["dateFake"]!.toDate())
    }
}
