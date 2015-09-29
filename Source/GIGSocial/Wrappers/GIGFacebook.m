//
//  GIGFacebook.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebook.h"
#import "GIGLogManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface GIGFacebook ()

@property (strong, nonatomic) FBSDKLoginManager *loginManager;

@end




@implementation GIGFacebook


- (instancetype)initWithLoginManager:(FBSDKLoginManager *)loginManager
{
	self = [super init];
	
	if (self)
	{
		self.loginManager = loginManager;
	}
	
	return self;
}


- (instancetype)init
{
	FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
	
	return [self initWithLoginManager:loginManager];
}


- (void)login:(GIGFacebookLoginCompletion)completionHandler
{
	FBSDKAccessToken *currentAccessToken = [FBSDKAccessToken currentAccessToken];
	if (currentAccessToken)
	{
		completionHandler(YES, currentAccessToken.userID, currentAccessToken.tokenString, NO, nil);
	}
	else
	{
		[self.loginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
		 {
			 if (error)
			 {
				 GIGLogNSError(error);
				 
				 completionHandler(NO, nil, nil, NO, error);
			 }
			 else if (result.isCancelled)
			 {
				 // DO NOTHING
				 GIGLogWarn(@"Facebook was cancelled");
				 completionHandler(NO, nil, nil, YES, nil);
			 }
			 else
			 {
				 completionHandler(YES, result.token.userID, result.token.tokenString, NO, nil);
			 }
		 }];
	}
}


@end
