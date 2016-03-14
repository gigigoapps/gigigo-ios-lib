//
//  NSManagedObjectContext+Extension.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 14/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public extension NSManagedObjectContext {
	
	public func createEntity(name: String) -> NSManagedObject? {
		guard let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: self) else {
			return nil
		}
		
		return NSManagedObject(entity: entity, insertIntoManagedObjectContext: self)
	}
	
}