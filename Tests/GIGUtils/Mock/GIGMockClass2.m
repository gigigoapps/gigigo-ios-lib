//
//  GIGMockClass2.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClass2.h"

@implementation GIGMockClass2

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.textMock2 = @"textMock2 info";
        self.textMock2a = @"textMock2a info";
        self.textMock2b = @"textMock2b info";
        self.textMock2c = @"textMock2c info";
        self.textMock2d = @"textMock2d info";
    }
    return self;
}

@end