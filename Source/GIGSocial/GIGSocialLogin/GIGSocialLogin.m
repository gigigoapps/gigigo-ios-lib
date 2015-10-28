//
//  GIGSocialLogin.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGSocialLogin.h"

#import "GIGLogManager.h"
#import "GIGFacebook.h"


@interface GIGSocialLogin ()

@property (strong, nonatomic) GIGFacebook *facebook;

@end


@implementation GIGSocialLogin

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_facebook = [[GIGFacebook alloc] init];
	}
	return self;
}


#pragma mark - PUBLIC

- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler
{
	self.facebook.extraPermissions = self.extraPermissions;
	[self.facebook login:^(GIGFacebookLoginResult *result)
	 {
		 GIGSocialLoginError socialError = GIGSocialLoginErrorNone;
		 
		 if (result.success)
		 {
			 socialError = GIGSocialLoginErrorNone;
		 }
		 else if (result.isCancelled)
		 {
			 socialError = GIGSocialLoginErrorFacebookCancelled;
		 }
		 else
		 {
			 socialError = GIGSocialLoginErrorFacebook;
		 }
		 
		 GIGSocialLoginResult *socialResult = [[GIGSocialLoginResult alloc] init];
		 socialResult.success = result.success;
		 socialResult.userID = result.userID;
		 socialResult.accessToken = result.accessToken;
		 socialResult.loginError = socialError;
		 socialResult.error = result.error;
		 
		 completionHandler(socialResult);
	 }];
}


@end
