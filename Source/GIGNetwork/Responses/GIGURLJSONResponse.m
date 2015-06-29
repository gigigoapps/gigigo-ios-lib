//
//  GIGURLJSONResponse.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGURLJSONResponse.h"


@implementation GIGURLJSONResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
        if (self.success)
        {
            NSError *error = nil;
            self.json = [data toJSONError:&error];
            if (self.json == nil)
            {
                self.success = NO;
                self.error = error;
            }
        }
    }
    return self;
}

- (instancetype)initWithJSON:(id)json
{
    NSData *data = [json toData];
    
    return [self initWithData:data];
}

@end
