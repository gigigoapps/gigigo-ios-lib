//
//  NSData+GIGJSON.m
//  giglibrary
//
//  Created by Sergio Baró on 10/25/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSData+GIGJSON.h"


@implementation NSData (GIGJSON)

- (id)toJSON
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    else
    {
        return json;
    }
}

@end
