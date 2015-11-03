//
//  GIGFacebook.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebook.h"
#import "GIGLogManager.h"
#import "GIGFacebookFactory.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface GIGFacebook ()

@property (strong, nonatomic) FBSDKLoginManager *loginManager;
@property (strong, nonatomic) GIGFacebookFactory *facebookFactory;

@end


@implementation GIGFacebook


#pragma mark - INIT

- (instancetype)init
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
	GIGFacebookFactory *accessTokenFactory = [[GIGFacebookFactory alloc] init];
	
    return [self initWithLoginManager:loginManager accessToken:accessTokenFactory];
}

- (instancetype)initWithLoginManager:(FBSDKLoginManager *)loginManager accessToken:(GIGFacebookFactory *)accessTokenFactory
{
	self = [super init];
	if (self)
	{
		self.loginManager = loginManager;
		self.facebookFactory = accessTokenFactory;
	}
	return self;
}


#pragma mark - PUBLIC

- (void)login:(GIGFacebookLoginCompletion)completionHandler
{
	FBSDKAccessToken *currentAccessToken = [self.facebookFactory currentToken];
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
		NSArray *permissions = @[@"public_profile"];
		
		if (self.extraPermissions)
		{
			permissions = [permissions arrayByAddingObjectsFromArray:self.extraPermissions];
		}
		
		[self.loginManager logInWithReadPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
		 {
			 GIGFacebookLoginResult *loginResult = [[GIGFacebookLoginResult alloc] init];
			 loginResult.userID = result.token.userID;
			 loginResult.accessToken = result.token.tokenString;
			 loginResult.isCancelled = result.isCancelled;
			 loginResult.error = error;
			 
			 if (error)
			 {
				 loginResult.success = NO;
				 completionHandler(loginResult);
			 }
			 else if (result.isCancelled)
			 {
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


- (void)me:(GIGFacebookMeCompletion)completionHandler
{
	NSMutableString *fields = [NSMutableString stringWithString:@"email,first_name,middle_name,last_name,gender"];
	if (self.extraFields)
	{
		for (NSString *field in self.extraFields)
		{
			[fields appendFormat:@",%@", field];
		}
	}
	
	FBSDKAccessToken *currentAccessToken = [self.facebookFactory currentToken];
	if (currentAccessToken)
	{
		FBSDKGraphRequest *request = [self.facebookFactory meRequestWithParams:@{@"fields": fields}];
		[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
		 {
			 if (!error)
			 {
				 completionHandler(YES, result, nil);
			 }
			 else
			 {
				 completionHandler(NO, nil, error);
			 }
		 }];
	}
}

@end
