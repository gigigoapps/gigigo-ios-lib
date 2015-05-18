//
//  NSArray+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 25/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (GIGExtension)

- (NSArray *)arrayByRemovingObject:(id)object;
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)array;

@end
