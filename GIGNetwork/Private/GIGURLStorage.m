//
//  GIGURLStorage.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLStorage.h"

#import "GIGURLDomain.h"
#import "GIGURLFixture.h"
#import "NSBundle+GIGLibrary.h"


NSString * const GIGURLManagerUseFixtureKey = @"GIGURLManagerUseFixtureKey";
NSString * const GIGURLManagerFixtureKey = @"GIGURLManagerFixtureKey";
NSString * const GIGURLManagerFixturesKey = @"GIGURLManagerFixturesKey";

NSString * const GIGURLManagerDomainKey = @"GIGURLManagerDomainKey";
NSString * const GIGURLManagerDomainsKey = @"GIGURLManagerDomainsKey";


@interface GIGURLStorage ()

@property (strong, nonatomic) NSBundle *bundle;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end


@implementation GIGURLStorage

- (instancetype)init
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [self initWithBundle:bundle userDefaults:userDefaults];
}

- (instancetype)initWithBundle:(NSBundle *)bundle userDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self)
    {
        _bundle = bundle;
        _userDefaults = userDefaults;
    }
    return self;
}

#pragma mark - PUBLIC (Fixture)

- (BOOL)loadUseFixture
{
    return [self.userDefaults boolForKey:GIGURLManagerUseFixtureKey];
}

- (void)storeUseFixture:(BOOL)useFixture
{
    [self.userDefaults setBool:useFixture forKey:GIGURLManagerUseFixtureKey];
    [self.userDefaults synchronize];
}

- (GIGURLFixture *)loadFixture
{
    return [self unarchiveObjectWithKey:GIGURLManagerFixtureKey];
}

- (void)storeFixture:(GIGURLFixture *)fixture
{
    [self archiveObject:fixture key:GIGURLManagerFixtureKey];
}

- (NSArray *)loadFixtures
{
    return [self unarchiveObjectWithKey:GIGURLManagerFixturesKey];
}

- (void)storeFixtures:(NSArray *)fixtures
{
    [self archiveObject:fixtures key:GIGURLManagerFixturesKey];
}

#pragma mark - PUBLIC (Domain)

- (GIGURLDomain *)loadDomain
{
    return [self unarchiveObjectWithKey:GIGURLManagerDomainKey];
}

- (void)storeDomain:(GIGURLDomain *)domain
{
    [self archiveObject:domain key:GIGURLManagerDomainKey];
}

- (NSArray *)loadDomains
{
    return [self unarchiveObjectWithKey:GIGURLManagerDomainsKey];
}

- (void)storeDomains:(NSArray *)domains
{
    [self archiveObject:domains key:GIGURLManagerDomainsKey];
}

#pragma mark - PUBLIC (Files)

- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename
{
    NSArray *domainsJSON = [self.bundle loadJSONFile:domainsFilename rootNode:@"domains"];
    
    return [GIGURLDomain domainsWithJSON:domainsJSON];
}

- (NSArray *)loadFixturesFromFile:(NSString *)fixtureFilename
{
    NSArray *fixturesJSON = [self.bundle loadJSONFile:fixtureFilename rootNode:@"fixtures"];
    
    return [GIGURLFixture fixturesWithJSON:fixturesJSON bundle:self.bundle];
}

- (NSData *)loadMockFromFile:(NSString *)filename
{
    return [self.bundle dataForFile:filename];
}

#pragma mark - PRIVATE 

- (void)archiveObject:(id)object key:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self.userDefaults setObject:data forKey:key];
    [self.userDefaults synchronize];
}

- (id)unarchiveObjectWithKey:(NSString *)key
{
    NSData *data = [self.userDefaults objectForKey:key];
    if (data == nil) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
