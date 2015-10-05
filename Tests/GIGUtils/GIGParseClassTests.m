//
//  GIGParseClassTests.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGParseClass.h"
#import "GIGMockClass1.h"
#import "GIGMockClass2.h"
#import "GIGMockClass3.h"
#import "GIGMockClassEmpty.h"


@interface GIGParseClassTests : XCTestCase

@property (strong, nonatomic) GIGMockClass1 *mock1;
@property (strong, nonatomic) GIGMockClass2 *mock2;
@property (strong, nonatomic) GIGMockClass3 *mock3;
@property (strong, nonatomic) GIGMockClassEmpty *mockEmpty;

@end


@implementation GIGParseClassTests

- (void)setUp
{
    [super setUp];
    
    self.mock1 = [[GIGMockClass1 alloc] init];
    self.mock2 = [[GIGMockClass2 alloc] init];
    self.mock3 = [[GIGMockClass3 alloc] init];
    self.mockEmpty = [[GIGMockClassEmpty alloc] init];
}

- (void)tearDown
{
    self.mock1 = nil;
    self.mock2 = nil;
    self.mock3 = nil;
    self.mockEmpty = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_correct
{
    NSDictionary *dic1 = [GIGParseClass parseClass:self.mock1];
    XCTAssertTrue(dic1.count == 4);
    NSDictionary *dic2 = [GIGParseClass parseClass:self.mock2];
    XCTAssertTrue(dic2.count == 5);
    NSDictionary *dic3 = [GIGParseClass parseClass:self.mock3];
    XCTAssertTrue(dic3.count == 2);
    NSDictionary *dicEmpty = [GIGParseClass parseClass:self.mockEmpty];
    XCTAssertTrue(dicEmpty.count == 0);
}

- (void)test_info_correct_data
{
    NSDictionary *dic1 = [GIGParseClass parseClass:self.mock1];
    XCTAssertTrue([dic1[@"boleanTypeMock1"] boolValue] == YES);
    XCTAssertTrue([dic1[@"integerMock1"] integerValue] == 2);
    XCTAssertTrue([dic1[@"textMock1"] isEqualToString:@"text mock class 1"]);
    
    NSDictionary *dic2 = [GIGParseClass parseClass:self.mock2];
    XCTAssertTrue([dic2[@"textMock2"] isEqualToString:@"textMock2 info"]);
    XCTAssertTrue([dic2[@"textMock2a"] isEqualToString:@"textMock2a info"]);
}

- (void)test_incorrect
{
    NSDictionary *dic1 = [GIGParseClass parseClass:self.mock1];
    XCTAssertFalse(dic1.count == 0);
    NSDictionary *dic2 = [GIGParseClass parseClass:self.mock2];
    XCTAssertFalse(dic2.count == 1);
    XCTAssertFalse(dic2 == nil);
    NSDictionary *dic3 = [GIGParseClass parseClass:self.mock3];
    XCTAssertFalse(dic3.count == 9);
    NSDictionary *dicEmpty = [GIGParseClass parseClass:self.mockEmpty];
    XCTAssertFalse(dicEmpty == nil);
}

- (void)test_info_incorrect_data
{
    NSDictionary *dic1 = [GIGParseClass parseClass:self.mock1];
    XCTAssertFalse([dic1[@"boleanTypeMock1"] boolValue] == NO);
    XCTAssertFalse([dic1[@"integerMock1"] integerValue] == 9);
    XCTAssertFalse([dic1[@"textMock1"] isEqualToString:@"text mock class 2"]);
    
    NSDictionary *dic2 = [GIGParseClass parseClass:self.mock2];
    XCTAssertFalse([dic2[@"textMock2"] isEqualToString:@""]);
    XCTAssertFalse([dic2[@"textMock2a"] isEqualToString:@"info"]);
}


@end
