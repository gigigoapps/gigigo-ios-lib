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
		self.facebook = [[GIGFacebook alloc] init];
	}
	
	return self;
}


#pragma mark - PUBLIC

- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler
{
	//TODO: login facebook
	GIGLogWarn(@"TODO");
}

@end
