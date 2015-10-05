//
//  GIGParseClass.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGParseClass.h"

#import <objc/objc-runtime.h>


@implementation GIGParseClass

#pragma mark - Public

+ (NSDictionary *)parseClass:(id)parseClass
{
    NSMutableDictionary *dicElement = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([parseClass class], &outCount);
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSObject *object = [parseClass valueForKey:propertyName];
        
        
        [dicElement setObject:object forKey:propertyName];
    }
    free(properties);
    return dicElement;
}


@end
