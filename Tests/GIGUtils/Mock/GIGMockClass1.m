//
//  GIGMockClass1.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClass1.h"

@implementation GIGMockClass1

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.boleanTypeMock1 = YES;
        self.integerMock1 = 2;
        self.textMock1 = @"text mock class 1";
        
        self.mock1 = [[GIGMockClass2 alloc] init];
    }
    return self;
}

@end
