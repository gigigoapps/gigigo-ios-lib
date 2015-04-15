//
//  GIGURLFixturesKeeper.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLFixturesKeeper.h"

#import "GIGURLStorage.h"


@interface GIGURLFixturesKeeper ()

@property (strong, nonatomic) GIGURLStorage *storage;

@end


@implementation GIGURLFixturesKeeper

- (instancetype)initWithStorage:(GIGURLStorage *)storage
{
    self = [super init];
    if (self)
    {
        _storage = storage;
        
        [self loadFixtures];
    }
    return self;
}

#pragma mark - ACCESSORS

- (void)setUseFixture:(BOOL)useFixture
{
    _useFixture = useFixture;
    
    [self.storage storeUseFixture:useFixture];
}

- (void)setCurrentFixture:(GIGURLFixture *)currentFixture
{
    _currentFixture = currentFixture;
    
    [self.storage storeFixture:currentFixture];
}

- (void)setFixtures:(NSArray *)fixtures
{
    _fixtures = fixtures;
    
    [self.storage storeFixtures:fixtures];
}

#pragma mark - PUBLIC

- (void)loadFixturesFromFile:(NSString *)fixtureFilename
{
    self.fixtures = [self.storage loadFixturesFromFile:fixtureFilename];
}

- (NSData *)mockForRequestTag:(NSString *)requestTag
{
    NSString *mockFileName = self.currentFixture.mocks[requestTag];
    
    if (mockFileName.length == 0) return nil;
    
    return [self.storage loadMockFromFile:mockFileName];
}

#pragma mark - PRIVATE

- (void)loadFixtures
{
    _useFixture = [self.storage loadUseFixture];
    _currentFixture = [self.storage loadFixture];
    _fixtures = [self.storage loadFixtures];
    
    if (_fixtures == nil)
    {
        self.fixtures = [self.storage loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile];
    }
}

@end
