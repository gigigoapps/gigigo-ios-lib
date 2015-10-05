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
	[self.facebook login:^(BOOL success, NSString *userID, NSString *accessToken, BOOL isCancelled, NSError *error)
	 {
		 GIGSocialLoginError socialError = GIGSocialLoginErrorNone;
		 
		 if (success)
		 {
			 socialError = GIGSocialLoginErrorNone;
		 }
		 else if (isCancelled)
		 {
			 socialError = GIGSocialLoginErrorFacebookCancelled;
		 }
		 else
		 {
			 socialError = GIGSocialLoginErrorFacebook;
		 }
		 
		 completionHandler(success, userID, accessToken, socialError, error);
	 }];
}

@end
