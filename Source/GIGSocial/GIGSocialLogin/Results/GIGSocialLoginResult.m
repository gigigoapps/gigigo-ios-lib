//
//  GIGSocialLoginResult.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGSocialLoginResult.h"

@implementation GIGSocialLoginResult

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		self.success = NO;
		self.userID = nil;
		self.accessToken = nil;
		self.user = nil;
		self.loginError = GIGSocialLoginErrorNone;
		self.error = nil;
	}
	
	return self;
}

@end
