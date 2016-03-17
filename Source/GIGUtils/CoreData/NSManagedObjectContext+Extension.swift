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
	
	public func fetchFirst(entityName: String, predicateString: String) -> NSManagedObject? {
		let result = self.fetchList(entityName, predicateString: predicateString)
		return result?.first
	}
	
	public func fetchList(entityName: String, predicateString: String) -> [NSManagedObject]? {
		let fetch = NSFetchRequest(entityName: entityName)
		fetch.predicate = NSPredicate(format: predicateString)
		
		let results = try? self.executeFetchRequest(fetch)
		
		return results as? [NSManagedObject]
	}
}