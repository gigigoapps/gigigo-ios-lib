//
//  GIGURLImageResponse.m
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLImageResponse.h"


@implementation GIGURLImageResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
        self.image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
    }
    return self;
}

@end
