//
//  GIGURLResponse.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLResponse.h"


@implementation GIGURLResponse

- (instancetype)initWithSuccess:(BOOL)success
{
    self = [super init];
    if (self)
    {
        _success = success;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _success = YES;
        _data = data;
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self)
    {
        _success = NO;
        _error = error;
    }
    return self;
}

@end
