//
//  GIGURLManager.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 18/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLManager.h"

#import "GIGConstants.h"
#import "GIGURLStorage.h"
#import "GIGURLConfigTableViewController.h"


NSString * const GIGURLDomainsDefaultFile = @"domains.json";
NSString * const GIGURLManagerDidChangeDomainNotification = @"GIGURLManagerDidChangeDomainNotification";
NSString * const GIGURLManagerDomainUserInfoKey = @"GIGURLManagerDomainUserInfoKey";
NSString * const GIGURLManagerDidAddOrRemoveDomainNotification = @"GIGURLManagerDidAddOrRemoveDomainNotification";

NSString * const GIGURLFixturesDefaultFile = @"fixtures.json";
NSString * const GIGURLManagerDidChangeFixtureNotification = @"GIGURLManagerDidChangeFixtureNotification";
NSString * const GIGURLManagerFixtureUserInfoKey = @"GIGURLManagerFixtureUserInfoKey";


@interface GIGURLManager ()

@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) GIGURLStorage *storage;

@end


@implementation GIGURLManager

+ (instancetype)sharedManager
{
    static GIGURLManager *sharedInstance = nil;
    static dispatch_once_t sharedManager;
    
    dispatch_once(&sharedManager, ^{
        sharedInstance = [[GIGURLManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    GIGURLStorage *storage = [[GIGURLStorage alloc] init];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    return [self initWithStorage:storage notificationCenter:notificationCenter];
}

- (instancetype)initWithStorage:(GIGURLStorage *)storage notificationCenter:(NSNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self)
    {
        _storage = storage;
        _notificationCenter = notificationCenter;
        
        _useFixture = [self.storage loadUseFixture];
        _fixture = [self.storage loadFixture];
        self.fixtureFilename = [self.storage loadFixtureFilename];
        
        _domain = [self.storage loadDomain];
        self.domainsFilename = [self.storage loadDomainFilename];
    }
    return self;
}

#pragma mark - ACCESSORS (Fixture)

- (void)setUseFixture:(BOOL)useFixture
{
    _useFixture = useFixture;
    
    [self.storage storeUseFixture:useFixture];
}

- (void)setFixture:(GIGURLFixture *)fixture
{
    if ([fixture isEqualToFixture:_fixture]) return;
    
    _fixture = fixture;
    
    [self notifyFixtureChange];
    [self.storage storeFixture:fixture];
}

- (void)setFixtureFilename:(NSString *)fixtureFilename
{
    if (fixtureFilename.length == 0)
    {
        fixtureFilename = GIGURLFixturesDefaultFile;
    }
    
    if (![fixtureFilename isEqualToString:_fixtureFilename])
    {
        _fixtureFilename = fixtureFilename;
        
        [self loadFixture];
    }
}

#pragma mark - ACCESSORS (Domain)

- (void)setDomain:(GIGURLDomain *)domain
{
    if ([domain isEqualToDomain:_domain]) return;
    
    _domain = domain;
    
    [self notifyDomainChange];
    [self.storage storeDomain:domain];
}

- (void)setDomainsFilename:(NSString *)domainsFilename
{
    if (domainsFilename.length == 0)
    {
        domainsFilename = GIGURLDomainsDefaultFile;
    }
    
    if (![domainsFilename isEqualToString:_domainsFilename])
    {
        _domainsFilename = domainsFilename;
        
        [self loadDomains];
    }
}

#pragma mark - PUBLIC

- (NSData *)mockForRequestTag:(NSString *)requestTag
{
    NSString *mockFileName = self.fixture.mocks[requestTag];
    
    if (mockFileName.length == 0) return nil;
    
    return [self.storage loadMockFromFile:mockFileName];
}

- (void)showConfig
{
    UIViewController *topViewController = [self topViewController];
    if (topViewController != nil)
    {
        GIGURLConfigTableViewController *config = [[GIGURLConfigTableViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:config];
    
        [topViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)addDomain:(GIGURLDomain *)domain
{
    self.domains = [self.domains arrayByAddingObject:domain];
    
    [self.notificationCenter postNotificationName:GIGURLManagerDidAddOrRemoveDomainNotification object:self];
}

#pragma mark - PRIVATE

- (void)notifyDomainChange
{
    NSDictionary *userInfo = @{GIGURLManagerDomainUserInfoKey: self.domain};
    [self.notificationCenter postNotificationName:GIGURLManagerDidChangeDomainNotification object:self userInfo:userInfo];
}

- (void)loadDomains
{
    self.domains = [self.storage loadDomainsFromFile:self.domainsFilename];
    [self.storage storeDomainsFilename:self.domainsFilename];
    
    if (self.domain == nil && self.domains.count > 0)
    {
        self.domain = self.domains[0];
    }
}

- (void)notifyFixtureChange
{
    NSDictionary *userInfo = @{GIGURLManagerFixtureUserInfoKey: self.fixture};
    [self.notificationCenter postNotificationName:GIGURLManagerDidChangeFixtureNotification object:self userInfo:userInfo];
}

- (void)loadFixture
{
    self.fixtures = [self.storage loadFixturesFromFile:self.fixtureFilename];
    [self.storage storeFixtureFilename:self.fixtureFilename];
    
    if (self.fixture == nil && self.fixtures.count > 0)
    {
        self.fixture = self.fixtures[0];
    }
}

- (UIViewController *)topViewController
{
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topViewController.presentedViewController)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)topViewController;
        UIViewController *firstViewController = navController.viewControllers[0];
        
        if ([firstViewController isKindOfClass:[GIGURLConfigTableViewController class]])
        {
            topViewController = nil;
        }
    }
    
    return topViewController;
}

@end
