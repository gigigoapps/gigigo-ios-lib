//
//  NSArray+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 25/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSArray+GIGExtension.h"


@implementation NSArray (GIGExtension)

- (NSArray *)arrayByRemovingObject:(id)object
{
    NSMutableArray *tmp = [self mutableCopy];
    [tmp removeObject:object];
    
    return [tmp copy];
}

@end
