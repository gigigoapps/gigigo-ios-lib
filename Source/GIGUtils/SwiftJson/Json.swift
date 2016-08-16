//
//  Json.swift
//  AlwaysOn
//
//  Created by Alejandro Jiménez Agudo on 22/2/16.
//  Copyright © 2016 Gigigo S.L. All rights reserved.
//

import Foundation


public class JSON: SequenceType, CustomStringConvertible {
	
	private var json: AnyObject
	
	public var description: String {
		if let data = try! NSJSONSerialization.dataWithJSONObject(self.json, options: .PrettyPrinted) as NSData? {
			if let description = String(data: data, encoding: NSUTF8StringEncoding) {
				return description
			}
			else {
				return self.json.description
			}
		}
		else {
			return self.json.description
		}
	}
	
	
	// MARK - Initializers
	
	public init(json: AnyObject) {
		self.json = json
	}
	
	public subscript(path: String) -> JSON? {
		get {
			guard var jsonDict = self.json as? [String: AnyObject] else {
				return nil
			}
			
			var json = self.json
			let pathArray = path.componentsSeparatedByString(".")
			
			for key in pathArray {
				
				if let jsonObject = jsonDict[key] {
					json = jsonObject
					
					if let jsonDictNext = jsonObject as? [String : AnyObject] {
						jsonDict = jsonDictNext
					}
				}
				else {
					return nil
				}
			}
			
			return JSON(json: json)
		}
	}
    
    public subscript(index: Int) -> JSON? {
        get {
            guard let array = self.json as? [AnyObject] where array.count > index else { return nil }
            
            return JSON(json: array[index])
        }
    }
	
	public class func dataToJson(data: NSData) throws -> JSON {
		let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
		let json = JSON(json: jsonObject)
		
		return json
	}
	
	
	// MARK - Public methods
	
	public func toBool() -> Bool? {
		return self.json as? Bool
	}
	
	
	public func toInt() -> Int? {
		if let value = self.json as? Int {
			return value
		}
		else if let value = self.toString() {
			return Int(value)
		}
		
		return nil
	}
	
	
	public func toString() -> String? {
		return self.json as? String
	}
	
	public func toDate(format: String = DateISOFormat) -> NSDate? {
		guard let dateString = self.json as? String else {
			return nil
		}
		
		return NSDate.dateFromString(dateString, format: format)
	}
	
	
	// MARK - Sequence Methods
	
	public func generate() -> AnyGenerator<JSON> {
		var index = 0
		
		return AnyGenerator{ () -> JSON? in
			guard let array = self.json as? [AnyObject] else { return nil }
			guard array.count > index else { return nil }
			
			let item = array[index]
			let json = JSON(json: item)
			index += 1
			
			return json
		}
	}
}