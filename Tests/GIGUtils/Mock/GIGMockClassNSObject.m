//
//  GIGMockClassNSObject.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClassNSObject.h"

@implementation GIGMockClassNSObject

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.stringNSObject = @"NSstring text";
        self.integerNSObject = INT_MAX;
    }
    return self;
}

@end