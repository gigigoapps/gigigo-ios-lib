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
#import "GIGURLBundle.h"


NSString * const GIGURLManagerUseFixtureKey = @"GIGURLManagerUseFixtureKey";
NSString * const GIGURLManagerFixtureKey = @"GIGURLManagerFixtureKey";
NSString * const GIGURLManagerFixtureFilenameKey = @"GIGURLManagerFixtureFilenameKey";
NSString * const GIGURLManagerDomainKey = @"GIGURLManagerDomainKey";
NSString * const GIGURLManagerDomainsFilenameKey = @"GIGURLManagerDomainFilenameKey";


@interface GIGURLStorage ()

@property (strong, nonatomic) GIGURLBundle *bundle;
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
        _bundle = [[GIGURLBundle alloc] initWithBundle:bundle];
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
    NSData *encodedFixture = [self.userDefaults objectForKey:GIGURLManagerFixtureKey];
    if (encodedFixture == nil) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedFixture];
}

- (void)storeFixture:(GIGURLFixture *)fixture
{
    NSData *encodedFixture = [NSKeyedArchiver archivedDataWithRootObject:fixture];
    [self.userDefaults setObject:encodedFixture forKey:GIGURLManagerFixtureKey];
    [self.userDefaults synchronize];
}

- (NSString *)loadFixtureFilename
{
    return [self.userDefaults objectForKey:GIGURLManagerFixtureFilenameKey];
}

- (void)storeFixtureFilename:(NSString *)fixtureFilename
{
    [self.userDefaults setObject:fixtureFilename forKey:GIGURLManagerFixtureFilenameKey];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Domain)

- (GIGURLDomain *)loadDomain
{
    NSData *encodedDomain = [self.userDefaults objectForKey:GIGURLManagerDomainKey];
    if (encodedDomain == nil) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedDomain];
}

- (void)storeDomain:(GIGURLDomain *)domain
{
    NSData *encodedDomain = [NSKeyedArchiver archivedDataWithRootObject:domain];
    [self.userDefaults setObject:encodedDomain forKey:GIGURLManagerDomainKey];
    [self.userDefaults synchronize];
}

- (NSString *)loadDomainFilename
{
    return [self.userDefaults objectForKey:GIGURLManagerDomainsFilenameKey];
}

- (void)storeDomainsFilename:(NSString *)domainsFilename
{
    [self.userDefaults setObject:domainsFilename forKey:GIGURLManagerDomainsFilenameKey];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Files)

- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename
{
    NSArray *domainsJSON = [self.bundle loadJSONFile:domainsFilename rootNode:@"domains"];
    
    NSMutableArray *domains = [[NSMutableArray alloc] initWithCapacity:domainsJSON.count];
    for (NSDictionary *domainJSON in domainsJSON)
    {
        GIGURLDomain *domain = [[GIGURLDomain alloc] initWithJSON:domainJSON];
        [domains addObject:domain];
    }
    
    return [domains copy];
}

- (NSDictionary *)loadFixturesFromFile:(NSString *)fixtureFilename
{
    NSArray *fixturesJSON = [self.bundle loadJSONFile:fixtureFilename rootNode:@"fixtures"];
    
    NSMutableArray *fixtures = [[NSMutableArray alloc] initWithCapacity:fixturesJSON.count];
    for (NSDictionary *fixtureJSON in fixturesJSON)
    {
        GIGURLFixture *fixture = [[GIGURLFixture alloc] initWithJSON:fixtureJSON bundle:self.bundle];
        
        [fixtures addObject:fixture];
    }
    
    return [fixtures copy];
}

- (NSData *)loadMockFromFile:(NSString *)filename
{
    return [self.bundle dataForFile:filename];
}

@end
