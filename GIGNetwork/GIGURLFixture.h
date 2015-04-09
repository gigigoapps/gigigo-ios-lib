//
//  GIGURLFixture.h
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLBundle;


@interface GIGURLFixture : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *mocks;

- (instancetype)initWithJSON:(NSDictionary *)json bundle:(GIGURLBundle *)bundle;
- (instancetype)initWithName:(NSString *)name mocks:(NSDictionary *)mocks;

- (BOOL)isEqualToFixture:(GIGURLFixture *)fixture;

@end
