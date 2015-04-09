//
//  GIGURLStorage.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLDomain;
@class GIGURLFixture;


@interface GIGURLStorage : NSObject

- (instancetype)initWithBundle:(NSBundle *)bundle userDefaults:(NSUserDefaults *)userDefaults;

// fixture
- (BOOL)loadUseFixture;
- (void)storeUseFixture:(BOOL)useFixture;

- (GIGURLFixture *)loadFixture;
- (void)storeFixture:(GIGURLFixture *)fixture;

- (NSString *)loadFixtureFilename;
- (void)storeFixtureFilename:(NSString *)fixtureFilename;

// domain
- (GIGURLDomain *)loadDomain;
- (void)storeDomain:(GIGURLDomain *)domain;

- (NSString *)loadDomainFilename;
- (void)storeDomainsFilename:(NSString *)domainsFilename;

// files
- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename;
- (NSArray *)loadFixturesFromFile:(NSString *)fixtureFilename;
- (NSData *)loadMockFromFile:(NSString *)filename;

@end
