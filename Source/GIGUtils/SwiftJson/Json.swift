//
//  Json.swift
//  AlwaysOn
//
//  Created by Alejandro Jiménez Agudo on 22/2/16.
//  Copyright © 2016 Gigigo S.L. All rights reserved.
//

import Foundation


open class JSON: Sequence, CustomStringConvertible {
	
	fileprivate var json: AnyObject
	
	open var description: String {
		if let data = try! JSONSerialization.data(withJSONObject: self.json, options: .prettyPrinted) as Data? {
			if let description = String(data: data, encoding: String.Encoding.utf8) {
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
	
	open subscript(path: String) -> JSON? {
		get {
			guard var jsonDict = self.json as? [String: AnyObject] else {
				return nil
			}
			
			var json = self.json
			let pathArray = path.components(separatedBy: ".")
			
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
    
    open subscript(index: Int) -> JSON? {
        get {
            guard let array = self.json as? [AnyObject] , array.count > index else { return nil }
            
            return JSON(json: array[index])
        }
    }
	
	open class func dataToJson(_ data: Data) throws -> JSON {
		let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
		let json = JSON(json: jsonObject as AnyObject)
		
		return json
	}
	
	
	// MARK - Public methods
	
	open func toBool() -> Bool? {
		return self.json as? Bool
	}
		
	open func toInt() -> Int? {
		if let value = self.json as? Int {
			return value
		}
		else if let value = self.toString() {
			return Int(value)
		}
		
		return nil
	}
		
	open func toString() -> String? {
		return self.json as? String
	}
	
	open func toDate(_ format: String = DateISOFormat) -> Date? {
		guard let dateString = self.json as? String else {
			return nil
		}
		
		return Date.dateFromString(dateString, format: format)
	}
    
    open func toDouble() -> Double? {
        return self.json as? Double
    }
    
    open func toDictionary() -> [String: AnyObject]? {
        
        guard let dic = self.json as? [String: AnyObject] else {
            return [:]
        }
        
        return dic
    }
	
	// MARK - Sequence Methods
	
	open func makeIterator() -> AnyIterator<JSON> {
		var index = 0
		
		return AnyIterator{ () -> JSON? in
			guard let array = self.json as? [AnyObject] else { return nil }
			guard array.count > index else { return nil }
			
			let item = array[index]
			let json = JSON(json: item)
			index += 1
			
			return json
		}
	}
}
