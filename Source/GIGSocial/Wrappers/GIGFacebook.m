//
//  GIGFacebook.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebook.h"
#import "GIGLogManager.h"
#import "GIGFacebookAccessTokenFactory.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface GIGFacebook ()

@property (strong, nonatomic) FBSDKLoginManager *loginManager;
@property (strong, nonatomic) GIGFacebookAccessTokenFactory *accessTokenFactory;

@end


@implementation GIGFacebook


#pragma mark - INIT

- (instancetype)init
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
	GIGFacebookAccessTokenFactory *accessTokenFactory = [[GIGFacebookAccessTokenFactory alloc] init];
	
    return [self initWithLoginManager:loginManager accessToken:accessTokenFactory];
}

- (instancetype)initWithLoginManager:(FBSDKLoginManager *)loginManager accessToken:(GIGFacebookAccessTokenFactory *)accessTokenFactory
{
	self = [super init];
	if (self)
	{
		self.loginManager = loginManager;
		self.accessTokenFactory = accessTokenFactory;
	}
	return self;
}


#pragma mark - PUBLIC

- (void)login:(GIGFacebookLoginCompletion)completionHandler
{
	FBSDKAccessToken *currentAccessToken = [self.accessTokenFactory getCurrentToken];
	if (currentAccessToken)
	{
		GIGFacebookLoginResult *result = [[GIGFacebookLoginResult alloc] init];
		result.success = YES;
		result.userID = currentAccessToken.userID;
		result.accessToken = currentAccessToken.tokenString;
		result.isCancelled = NO;
		result.error = nil;

		completionHandler(result);
	}
	else
	{
		[self.loginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
		 {
			 GIGFacebookLoginResult *loginResult = [[GIGFacebookLoginResult alloc] init];
			 loginResult.userID = result.token.userID;
			 loginResult.accessToken = result.token.tokenString;
			 loginResult.isCancelled = result.isCancelled;
			 loginResult.error = error;
			 
			 if (error)
			 {
				 GIGLogNSError(error);
				 loginResult.success = NO;
				 
				 completionHandler(loginResult);
			 }
			 else if (result.isCancelled)
			 {
				 GIGLogWarn(@"Facebook was cancelled");
				 loginResult.success = NO;

				 completionHandler(loginResult);
			 }
			 else
			 {
				 loginResult.success = YES;
				 
				 completionHandler(loginResult);
			 }
		 }];
	}
}

@end
