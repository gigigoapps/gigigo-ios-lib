//
//  GIGMockClass1.h
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGMockClass2.h"


@interface GIGMockClass1 : NSObject

@property (assign, nonatomic) BOOL boleanTypeMock1;
@property (assign, nonatomic) NSInteger integerMock1;
@property (strong, nonatomic) NSString *textMock1;

@property (strong, nonatomic) GIGMockClass2 *mock1;

@end
