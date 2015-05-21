//
//  NSLocale+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 10/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "NSLocale+GIGExtension.h"


@implementation NSLocale (GIGExtension)

+ (NSString *)currentLanguage
{
    return [self preferredLanguages][0];
}

@end
