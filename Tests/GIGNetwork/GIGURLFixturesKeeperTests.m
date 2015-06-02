//
//  GIGURLFixturesKeeperTests.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGTests.h"

#import "GIGURLStorage.h"
#import "GIGURLFixturesKeeper.h"
#import "GIGURLFixture+GIGTesting.h"


@interface GIGURLFixturesKeeperTests : XCTestCase

@property (strong, nonatomic) GIGURLStorage *storageMock;
@property (strong, nonatomic) GIGURLFixturesKeeper *keeper;

@end


@implementation GIGURLFixturesKeeperTests

- (void)setUp
{
    [super setUp];
    
    self.storageMock = MKTMock([GIGURLStorage class]);
    self.keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
}

- (void)tearDown
{
    self.storageMock = nil;
    self.keeper = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_first_values
{
    NSArray *fixtures = [GIGURLFixture buildFixtures:3];
    GIGURLFixture *fixture = fixtures[1];
    
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:YES];
    [MKTGiven([self.storageMock loadFixture]) willReturn:fixture];
    [MKTGiven([self.storageMock loadFixtures]) willReturn:fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue(keeper.useFixture);
    XCTAssertTrue([keeper.currentFixture isEqualToFixture:fixture]);
    XCTAssertTrue([keeper.fixtures isEqualToArray:fixtures]);
}

- (void)test_first_values_load_default_file
{
    NSArray *fixtures = [GIGURLFixture buildFixtures:3];
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:NO];
    [MKTGiven([self.storageMock loadFixture]) willReturn:nil];
    [MKTGiven([self.storageMock loadFixtures]) willReturn:nil];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue([keeper.fixtures isEqualToArray:fixtures]);
}

@end
