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
#import "GIGLoginManagerMock.h"
#import "GIGFacebookAccessTokenFactoryMock.h"


@interface GIGFacebookTests : XCTestCase

@property (strong, nonatomic) GIGFacebook *facebook;
@property (strong, nonatomic) FBSDKAccessTokenMock *accessTokenMock;
@property (strong, nonatomic) GIGLoginManagerMock *loginManagerMock;
@property (strong, nonatomic) GIGFacebookAccessTokenFactoryMock *accessTokenFactoryMock;

@end


@implementation GIGFacebookTests


- (void)setUp
{
    [super setUp];

	self.accessTokenMock = [[FBSDKAccessTokenMock alloc] init];
	self.accessTokenFactoryMock = [[GIGFacebookAccessTokenFactoryMock alloc] init];
	self.loginManagerMock = [[GIGLoginManagerMock alloc] init];
	
	self.accessTokenFactoryMock.accessToken = self.accessTokenMock;
	self.facebook = [[GIGFacebook alloc] initWithLoginManager:self.loginManagerMock accessToken:self.accessTokenFactoryMock];
}


- (void)tearDown
{
	self.accessTokenMock = nil;
	self.accessTokenFactoryMock = nil;
	self.loginManagerMock = nil;
	self.facebook = nil;
	
    [super tearDown];
}


- (void)test_not_nil
{
	XCTAssertNotNil(self.facebook);
}


- (void)test_has_current_access_token
{
	self.accessTokenMock.userID = @"USER_ID_1";
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	
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


- (void)test_login_with_error
{
	self.accessTokenFactoryMock.accessToken = nil;
	self.loginManagerMock.error = [NSError errorWithDomain:@"TESTFACEBOOK" code:3 userInfo:nil];
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(BOOL success, NSString *userID, NSString *accessToken, BOOL isCancelled, NSError *error)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(success == NO);
		 XCTAssertTrue(userID == nil, @"%@", [self errorTestLogForObject:userID]);
		 XCTAssertTrue(accessToken == nil, @"%@", [self errorTestLogForObject:accessToken]);
		 XCTAssertFalse(isCancelled);
		 XCTAssertTrue([error.domain isEqualToString:@"TESTFACEBOOK"] && error.code == 3);
	 }];
	
	XCTAssertTrue(completionCalled);
}


- (void)test_login_cancelled
{
	self.accessTokenFactoryMock.accessToken = nil;
	FBSDKLoginManagerLoginResult *result = [[FBSDKLoginManagerLoginResult alloc] initWithToken:nil
																				   isCancelled:YES
																			grantedPermissions:nil
																		   declinedPermissions:nil];
	
	self.loginManagerMock.loginResult = result;
	self.loginManagerMock.error = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(BOOL success, NSString *userID, NSString *accessToken, BOOL isCancelled, NSError *error)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(success == NO);
		 XCTAssertTrue(userID == nil, @"%@", [self errorTestLogForObject:userID]);
		 XCTAssertTrue(accessToken == nil, @"%@", [self errorTestLogForObject:accessToken]);
		 XCTAssertTrue(isCancelled == YES);
		 XCTAssertNil(error);
	 }];
	
	XCTAssertTrue(completionCalled);
}


- (void)test_login_success
{
	self.accessTokenMock.userID = @"USER_ID_1";
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	
	FBSDKLoginManagerLoginResult *result = [[FBSDKLoginManagerLoginResult alloc] initWithToken:self.accessTokenMock
																				   isCancelled:NO
																			grantedPermissions:nil
																		   declinedPermissions:nil];
	
	self.loginManagerMock.loginResult = result;
	self.loginManagerMock.error = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(BOOL success, NSString *userID, NSString *accessToken, BOOL isCancelled, NSError *error)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(success == YES);
		 XCTAssertTrue([userID isEqualToString:@"USER_ID_1"], @"%@", [self errorTestLogForObject:userID]);
		 XCTAssertTrue([accessToken isEqualToString:@"ACCESS_TOKEN_1"], @"%@", [self errorTestLogForObject:accessToken]);
		 XCTAssertTrue(isCancelled == NO);
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
