//
//  GIGFacebookTests.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez on 5/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGFacebook.h"
#import "FBSDKAccessTokenMock.h"


@interface GIGFacebookTests : XCTestCase

@property (strong, nonatomic) GIGFacebook *facebook;
@property (strong, nonatomic) FBSDKAccessTokenMock *accessTokenMock;

@end


@implementation GIGFacebookTests


- (void)setUp
{
    [super setUp];

	self.accessTokenMock = [[FBSDKAccessTokenMock alloc] init];
	[self.accessTokenMock swizzleMethods];
	
	self.facebook = [[GIGFacebook alloc] init];
}


- (void)tearDown
{
	[self.accessTokenMock unswizzleMethods];
	self.accessTokenMock = nil;
	
	self.facebook = nil;
	
    [super tearDown];
}


- (void)test_not_nil
{
	XCTAssertNotNil(self.facebook);
}


- (void)test_has_current_access_token
{
	self.accessTokenMock.hasCurrentAccessToken = YES;
	self.accessTokenMock.userID = @"USER_ID_1";
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	
	[FBSDKAccessToken currentAccessToken];
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(BOOL success, NSString *userID, NSString *accessToken, BOOL isCancelled, NSError *error)
	{
		completionCalled = YES;
		
		XCTAssertTrue(success);
		XCTAssertTrue([userID isEqualToString:@"USER_ID_1"], @"%@", [self errorTestLogForObject:userID]);
		XCTAssertTrue([accessToken isEqualToString:@"ACCESS_TOKEN_1"], @"%@", [self errorTestLogForObject:accessToken]);
		XCTAssertFalse(isCancelled);
		XCTAssertNil(error);
	}];
	
	
	XCTAssertTrue(completionCalled);
}


#pragma mark - HELPERS

- (NSString *)errorTestLogForObject:(NSObject *)object
{
	NSString *errorLog = [NSString stringWithFormat:@"Result -> %@", object];
	
	return errorLog;
}

- (NSString *)errorTestLogForBOOL:(BOOL)boolean
{
	NSString *errorLog = [NSString stringWithFormat:@"Result -> %d", boolean];
	
	return errorLog;
}




@end
