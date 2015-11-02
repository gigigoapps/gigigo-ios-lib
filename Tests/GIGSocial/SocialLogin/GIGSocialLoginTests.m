//
//  GIGSocialLoginTests.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGSocialLogin.h"
#import "GIGFacebookMock.h"


@interface GIGSocialLogin (GIGSocialLoginExtensionTest)

@property (strong, nonatomic) GIGFacebook *facebook;

@end



@interface GIGSocialLoginTests : XCTestCase

@property (strong, nonatomic) GIGSocialLogin *socialLogin;
@property (strong, nonatomic) GIGFacebookMock *facebookMock;

@end



@implementation GIGSocialLoginTests

- (void)setUp
{
    [super setUp];
	
	self.facebookMock = [[GIGFacebookMock alloc] init];
	self.socialLogin = [[GIGSocialLogin alloc] init];
	
	XCTAssertNotNil(self.socialLogin.facebook, @"");
	
	self.socialLogin.facebook = self.facebookMock;
}

- (void)tearDown
{
	self.socialLogin = nil;
	
    [super tearDown];
}


- (void)test_not_nil
{
    XCTAssertNotNil(self.socialLogin, @"");
}


#pragma mark - LOGIN

- (void)test_login_facebook_success
{
	// INPUTS
	self.facebookMock.inSuccess = YES,
	self.facebookMock.inUserId = @"USER_ID";
	self.facebookMock.inAccessToken = @"ACCESSTOKEN";
	self.facebookMock.isCancelled = NO;
	self.facebookMock.inError = nil;
	
	self.facebookMock.inMeSuccess = YES;
	self.facebookMock.inUser = [[NSDictionary alloc] init];
	self.facebookMock.inMeError = nil;
	
	// EXECUTE TEST
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	{
		completionCalled = YES;
		
		// VERIFY
		XCTAssertTrue(result.success, @"");
		XCTAssertTrue([result.userID isEqualToString:@"USER_ID"], @"%@", [self errorTestLogForObject:result.userID]);
		XCTAssertTrue([result.accessToken isEqualToString:@"ACCESSTOKEN"], @"%@", [self errorTestLogForObject:result.accessToken]);
		XCTAssert(result.user == self.facebookMock.inUser);
		XCTAssertTrue(result.loginError == GIGSocialLoginErrorNone, @"");
		XCTAssertNil(result.error, @"");
	}];
	
	XCTAssertTrue(self.facebookMock.extraFields == self.socialLogin.extraFields);
	XCTAssertTrue(self.facebookMock.extraPermissions == self.socialLogin.extraPermissions);
	XCTAssertTrue(completionCalled, @"");
}


- (void)test_login_facebook_success_with_extra_permissions
{
	// INPUTS
	self.facebookMock.inSuccess = YES,
	self.facebookMock.inUserId = @"USER_ID";
	self.facebookMock.inAccessToken = @"ACCESSTOKEN";
	self.facebookMock.isCancelled = NO;
	self.facebookMock.inError = nil;
	
	self.facebookMock.inMeSuccess = YES;
	self.facebookMock.inUser = [[NSDictionary alloc] init];
	self.facebookMock.inMeError = nil;
	
	self.socialLogin.extraPermissions = @[@"public_profile", @"email", @"user_birthday"];
	
	// EXECUTE TEST
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 // VERIFY
		 XCTAssertTrue(result.success, @"");
		 XCTAssertTrue([result.userID isEqualToString:@"USER_ID"], @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue([result.accessToken isEqualToString:@"ACCESSTOKEN"], @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssert(result.user == self.facebookMock.inUser);
		 XCTAssertTrue(result.loginError == GIGSocialLoginErrorNone, @"");
		 XCTAssertNil(result.error, @"");
	 }];
	
	XCTAssertTrue(self.facebookMock.extraFields == self.socialLogin.extraFields);
	XCTAssertTrue(self.facebookMock.extraPermissions == self.socialLogin.extraPermissions);
	XCTAssertTrue(completionCalled, @"");
}


- (void)test_login_facebook_success_with_extra_fields
{
	// INPUTS
	self.facebookMock.inSuccess = YES,
	self.facebookMock.inUserId = @"USER_ID";
	self.facebookMock.inAccessToken = @"ACCESSTOKEN";
	self.facebookMock.isCancelled = NO;
	self.facebookMock.inError = nil;
	
	self.facebookMock.inMeSuccess = YES;
	self.facebookMock.inUser = [[NSDictionary alloc] init];
	self.facebookMock.inMeError = nil;
	
	self.socialLogin.extraFields = @[@"birthday"];
	
	// EXECUTE TEST
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 // VERIFY
		 XCTAssertTrue(result.success, @"");
		 XCTAssertTrue([result.userID isEqualToString:@"USER_ID"], @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue([result.accessToken isEqualToString:@"ACCESSTOKEN"], @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssert(result.user == self.facebookMock.inUser);
		 XCTAssertTrue(result.loginError == GIGSocialLoginErrorNone, @"");
		 XCTAssertNil(result.error, @"");
	 }];
	
	XCTAssertTrue(self.facebookMock.extraFields == self.socialLogin.extraFields);
	XCTAssertTrue(self.facebookMock.extraPermissions == self.socialLogin.extraPermissions);
	XCTAssertTrue(completionCalled, @"");
}


- (void)test_login_facebook_cancelled
{
	// INPUTS
	self.facebookMock.inSuccess = NO;
	self.facebookMock.inUserId = nil;
	self.facebookMock.inAccessToken = nil;
	self.facebookMock.isCancelled = YES;
	self.facebookMock.inError = nil;
	
	self.facebookMock.inMeSuccess = YES;
	self.facebookMock.inUser = [[NSDictionary alloc] init];
	self.facebookMock.inMeError = nil;
	
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	{
		completionCalled = YES;
		
		// VERIFY
		XCTAssertFalse(result.success, @"");
		XCTAssertNil(result.userID, @"%@", [self errorTestLogForObject:result.userID]);
		XCTAssertNil(result.accessToken, @"%@", [self errorTestLogForObject:result.accessToken]);
		XCTAssertNil(result.user);
		XCTAssertTrue(result.loginError == GIGSocialLoginErrorFacebookCancelled, @"");
		XCTAssertNil(result.error, @"");
	}];
	
	XCTAssertTrue(self.facebookMock.extraFields == self.socialLogin.extraFields);
	XCTAssertTrue(self.facebookMock.extraPermissions == self.socialLogin.extraPermissions);
	XCTAssertTrue(completionCalled, @"");
}


- (void)test_login_facebook_error
{
	// INPUTS
	self.facebookMock.inSuccess = NO;
	self.facebookMock.inUserId = nil;
	self.facebookMock.inAccessToken = nil;
	self.facebookMock.isCancelled = NO;
	self.facebookMock.inError = [NSError errorWithDomain:@"TESTFACEBOOK" code:3 userInfo:nil];
	
	self.facebookMock.inMeSuccess = YES;
	self.facebookMock.inUser = [[NSDictionary alloc] init];
	self.facebookMock.inMeError = nil;
	
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 // VERIFY
		 XCTAssertFalse(result.success, @"");
		 XCTAssertNil(result.userID, @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertNil(result.accessToken, @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssertNil(result.user);
		 XCTAssertTrue(result.loginError == GIGSocialLoginErrorFacebook, @"");
		 XCTAssertTrue([result.error.domain isEqualToString:@"TESTFACEBOOK"] && result.error.code == 3, @"");
	 }];
	
	XCTAssertTrue(self.facebookMock.extraFields == self.socialLogin.extraFields);
	XCTAssertTrue(self.facebookMock.extraPermissions == self.socialLogin.extraPermissions);
	XCTAssertTrue(completionCalled, @"");
}

- (void)test_login_facebook_user_error
{
	// INPUTS
	self.facebookMock.inSuccess = YES,
	self.facebookMock.inUserId = @"USER_ID";
	self.facebookMock.inAccessToken = @"ACCESSTOKEN";
	self.facebookMock.isCancelled = NO;
	self.facebookMock.inError = nil;
	
	self.facebookMock.inMeSuccess = NO;
	self.facebookMock.inUser = nil;
	self.facebookMock.inMeError = [NSError errorWithDomain:@"TESTFACEBOOK" code:3 userInfo:nil];
	
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	 {
		 completionCalled = YES;
		 
		 // VERIFY
		 XCTAssertFalse(result.success, @"");
		 XCTAssertTrue([result.userID isEqualToString:@"USER_ID"], @"%@", [self errorTestLogForObject:result.userID]);
		 XCTAssertTrue([result.accessToken isEqualToString:@"ACCESSTOKEN"], @"%@", [self errorTestLogForObject:result.accessToken]);
		 XCTAssertNil(result.user);
		 XCTAssertTrue(result.loginError == GIGSocialLoginErrorUser, @"");
		 XCTAssertTrue([result.error.domain isEqualToString:@"TESTFACEBOOK"] && result.error.code == 3, @"");
	 }];
	
	XCTAssertTrue(self.facebookMock.extraFields == self.socialLogin.extraFields);
	XCTAssertTrue(self.facebookMock.extraPermissions == self.socialLogin.extraPermissions);
	XCTAssertTrue(completionCalled, @"");
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
