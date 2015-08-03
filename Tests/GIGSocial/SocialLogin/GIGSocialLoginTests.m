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


- (void)testNotNil
{
    XCTAssertNotNil(self.socialLogin, @"");
}


- (void)testLoginSuccess
{
	// INPUTS
	self.facebookMock.inSuccess = YES,
	self.facebookMock.inUserId = @"USER_ID";
	self.facebookMock.inAccessToken = @"ACCESSTOKEN";
	self.facebookMock.inError = nil;
	
	
	__block BOOL completionCalled = NO;
	[self.socialLogin loginFacebook:^(BOOL isLogged, NSString *userID, NSString *accessToken, NSError *error)
	{
		completionCalled = YES;
		
		XCTAssertTrue(isLogged, @"");
		XCTAssertTrue([userID isEqualToString:@"USER_ID"], @"%@", [self errorTestLogForObject:userID]);
		XCTAssertTrue([accessToken isEqualToString:@"ACCESSTOKEN"], @"%@", [self errorTestLogForObject:accessToken]);
		XCTAssertNil(error, @"");
	}];
	
	
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
