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
#import "GIGFacebookFactoryMock.h"


@interface GIGFacebookTests : XCTestCase

@property (strong, nonatomic) GIGFacebook *facebook;
@property (strong, nonatomic) FBSDKAccessTokenMock *accessTokenMock;
@property (strong, nonatomic) GIGLoginManagerMock *loginManagerMock;
@property (strong, nonatomic) GIGFacebookFactoryMock *facebookFactoryMock;

@end


@implementation GIGFacebookTests


- (void)setUp
{
    [super setUp];

	self.accessTokenMock = [[FBSDKAccessTokenMock alloc] init];
	self.facebookFactoryMock = [[GIGFacebookFactoryMock alloc] init];
	self.loginManagerMock = [[GIGLoginManagerMock alloc] init];
	
	self.facebookFactoryMock.accessToken = self.accessTokenMock;
	self.facebook = [[GIGFacebook alloc] initWithLoginManager:self.loginManagerMock accessToken:self.facebookFactoryMock];
}

- (void)tearDown
{
	self.accessTokenMock = nil;
	self.facebookFactoryMock = nil;
	self.loginManagerMock = nil;
	self.facebook = nil;
	
    [super tearDown];
}


- (void)test_not_nil
{
	XCTAssertNotNil(self.facebook);
}


#pragma mark - Login

- (void)test_login_has_current_access_token
{
	self.accessTokenMock.userID = @"USER_ID_1";
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(GIGFacebookLoginResult *result)
	{
		completionCalled = YES;
		
		XCTAssertTrue(result.success);
		XCTAssertTrue([result.userID isEqualToString:@"USER_ID_1"], @"%@", [self errorTestLogForObject:result.userID]);
		XCTAssertTrue([result.accessToken isEqualToString:@"ACCESS_TOKEN_1"], @"%@", [self errorTestLogForObject:result.accessToken]);
		XCTAssertFalse(result.isCancelled);
		XCTAssertNil(result.error);
	}];
	
	XCTAssertTrue(completionCalled);
}


- (void)test_login_with_error
{
	self.facebookFactoryMock.accessToken = nil;
	self.loginManagerMock.error = [NSError errorWithDomain:@"TESTFACEBOOK" code:3 userInfo:nil];
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(GIGFacebookLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(result.success == NO);
		 XCTAssertTrue(result.userID == nil, @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue(result.accessToken == nil, @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssertFalse(result.isCancelled);
		 XCTAssertTrue([result.error.domain isEqualToString:@"TESTFACEBOOK"] && result.error.code == 3);
	 }];
	
	NSArray *requestedPermissionsResult = @[@"public_profile"];
	XCTAssertTrue([self.loginManagerMock.requestedPermissions isEqualToArray:requestedPermissionsResult]);
	XCTAssertTrue(completionCalled);
}


- (void)test_login_cancelled
{
	self.facebookFactoryMock.accessToken = nil;
	FBSDKLoginManagerLoginResult *result = [[FBSDKLoginManagerLoginResult alloc] initWithToken:nil
																				   isCancelled:YES
																			grantedPermissions:nil
																		   declinedPermissions:nil];
	
	self.loginManagerMock.loginResult = result;
	self.loginManagerMock.error = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(GIGFacebookLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(result.success == NO);
		 XCTAssertTrue(result.userID == nil, @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue(result.accessToken == nil, @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssertTrue(result.isCancelled == YES);
		 XCTAssertNil(result.error);
	 }];
	
	NSArray *requestedPermissionsResult = @[@"public_profile"];
	XCTAssertTrue([self.loginManagerMock.requestedPermissions isEqualToArray:requestedPermissionsResult]);
	XCTAssertTrue(completionCalled);
}


- (void)test_login_success
{
	self.facebookFactoryMock.accessToken = nil;
	
	FBSDKAccessTokenMock *accessTokenResult = [[FBSDKAccessTokenMock alloc] init];
	accessTokenResult.userID = @"USER_ID_1";
	accessTokenResult.tokenString = @"ACCESS_TOKEN_1";
	
	FBSDKLoginManagerLoginResult *result = [[FBSDKLoginManagerLoginResult alloc] initWithToken:accessTokenResult
																				   isCancelled:NO
																			grantedPermissions:nil
																		   declinedPermissions:nil];
	self.loginManagerMock.loginResult = result;
	self.loginManagerMock.error = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(GIGFacebookLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(result.success == YES);
		 XCTAssertTrue([result.userID isEqualToString:@"USER_ID_1"], @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue([result.accessToken isEqualToString:@"ACCESS_TOKEN_1"], @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssertTrue(result.isCancelled == NO);
		 XCTAssertNil(result.error);
		 
		 XCTAssertTrue([self.loginManagerMock.requestedPermissions isEqualToArray:@[@"public_profile"]], @"%@", [self errorTestLogForObject:self.loginManagerMock.requestedPermissions]);
	 }];
	
	NSArray *requestedPermissionsResult = @[@"public_profile"];
	XCTAssertTrue([self.loginManagerMock.requestedPermissions isEqualToArray:requestedPermissionsResult]);
	XCTAssertTrue(completionCalled);
}


- (void)test_login_success_with_extra_permissions
{
	self.facebookFactoryMock.accessToken = nil;
	
	FBSDKAccessTokenMock *accessTokenResult = [[FBSDKAccessTokenMock alloc] init];
	accessTokenResult.userID = @"USER_ID_1";
	accessTokenResult.tokenString = @"ACCESS_TOKEN_1";
	
	FBSDKLoginManagerLoginResult *result = [[FBSDKLoginManagerLoginResult alloc] initWithToken:accessTokenResult
																				   isCancelled:NO
																			grantedPermissions:nil
																		   declinedPermissions:nil];
	self.loginManagerMock.loginResult = result;
	self.loginManagerMock.error = nil;
	
	self.facebook.extraPermissions = @[@"email", @"user_birthday"];
	
	__block BOOL completionCalled = NO;
	[self.facebook login:^(GIGFacebookLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 XCTAssertTrue(result.success == YES);
		 XCTAssertTrue([result.userID isEqualToString:@"USER_ID_1"], @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue([result.accessToken isEqualToString:@"ACCESS_TOKEN_1"], @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssertTrue(result.isCancelled == NO);
		 XCTAssertNil(result.error);
		 
	 }];
	
	NSArray *requestedPermissionsResult = @[@"public_profile", @"email", @"user_birthday"];
	XCTAssertTrue([self.loginManagerMock.requestedPermissions isEqualToArray:requestedPermissionsResult]);
	XCTAssertTrue(completionCalled);
}


#pragma mark - Me

- (void)test_me_success_no_extra_fields
{
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	self.facebook.extraFields = nil;
	self.facebookFactoryMock.inReqUser = [NSDictionary dictionary];
	self.facebookFactoryMock.inReqError = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook me:^(BOOL success, NSDictionary *user, NSError *error) {
		completionCalled = YES;
		
		XCTAssert(success == YES);
		XCTAssert(user == self.facebookFactoryMock.inReqUser);
		XCTAssert(error == nil);
	}];
	
	NSString *fields = @"email,first_name,middle_name,last_name,gender";
	NSString *outFields = self.facebookFactoryMock.requestMock.parameters[@"fields"];
	XCTAssert([outFields isEqualToString:fields], @"%@", [self errorTestLogForObject:outFields]);

	XCTAssert(completionCalled == YES);
}

- (void)test_me_success_with_extra_fields
{
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	self.facebook.extraFields = @[@"birthday"];
	self.facebookFactoryMock.inReqUser = [NSDictionary dictionary];
	self.facebookFactoryMock.inReqError = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook me:^(BOOL success, NSDictionary *user, NSError *error) {
		completionCalled = YES;
		
		XCTAssert(success == YES);
		XCTAssert(user == self.facebookFactoryMock.inReqUser);
		XCTAssert(error == nil);
	}];
	
	NSString *fields = @"email,first_name,middle_name,last_name,gender,birthday";
	NSString *outFields = self.facebookFactoryMock.requestMock.parameters[@"fields"];
	XCTAssert([outFields isEqualToString:fields], @"%@", [self errorTestLogForObject:outFields]);
	
	XCTAssert(completionCalled == YES);
}


- (void)test_me_error_no_accessToken
{
	self.facebookFactoryMock.accessToken = nil;
	self.facebook.extraFields = @[@"birthday"];
	self.facebookFactoryMock.inReqUser = [NSDictionary dictionary];
	self.facebookFactoryMock.inReqError = nil;
	
	__block BOOL completionCalled = NO;
	[self.facebook me:^(BOOL success, NSDictionary *user, NSError *error) {
		completionCalled = YES;
		
		XCTAssert(success == NO);
		XCTAssert(user == nil);
		XCTAssert(error.code == -1);
		XCTAssert([error.domain isEqualToString:@"com.giglibrary.social"]);
	}];
	
//	NSString *fields = @"email,first_name,middle_name,last_name,gender,birthday";
	NSString *outFields = self.facebookFactoryMock.requestMock.parameters[@"fields"];
	XCTAssert(outFields == nil, @"%@", [self errorTestLogForObject:outFields]);
	
	XCTAssert(completionCalled == YES);
}

- (void)test_me_error_facebook_with_no_extra_fields
{
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	self.facebook.extraFields = nil;
	self.facebookFactoryMock.inReqUser = nil;
	self.facebookFactoryMock.inReqError = [NSError errorWithDomain:@"facebook.mock.error" code:666 userInfo:nil];
	
	__block BOOL completionCalled = NO;
	[self.facebook me:^(BOOL success, NSDictionary *user, NSError *error) {
		completionCalled = YES;
		
		XCTAssert(success == NO);
		XCTAssert(user == nil);
		XCTAssert(error.code == 666);
		XCTAssert([error.domain isEqualToString:@"facebook.mock.error"]);
	}];
	
	NSString *fields = @"email,first_name,middle_name,last_name,gender";
	NSString *outFields = self.facebookFactoryMock.requestMock.parameters[@"fields"];
	XCTAssert([outFields isEqualToString:fields], @"%@", [self errorTestLogForObject:outFields]);
	
	XCTAssert(completionCalled == YES);
}

- (void)test_me_error_facebook_with_extra_fields
{
	self.accessTokenMock.tokenString = @"ACCESS_TOKEN_1";
	self.facebook.extraFields = @[@"birthday"];
	self.facebookFactoryMock.inReqUser = nil;
	self.facebookFactoryMock.inReqError = [NSError errorWithDomain:@"facebook.mock.error" code:666 userInfo:nil];
	
	__block BOOL completionCalled = NO;
	[self.facebook me:^(BOOL success, NSDictionary *user, NSError *error) {
		completionCalled = YES;
		
		XCTAssert(success == NO);
		XCTAssert(user == nil);
		XCTAssert(error.code == 666);
		XCTAssert([error.domain isEqualToString:@"facebook.mock.error"]);
	}];
	
	NSString *fields = @"email,first_name,middle_name,last_name,gender,birthday";
	NSString *outFields = self.facebookFactoryMock.requestMock.parameters[@"fields"];
	XCTAssert([outFields isEqualToString:fields], @"%@", [self errorTestLogForObject:outFields]);
	
	XCTAssert(completionCalled == YES);
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
