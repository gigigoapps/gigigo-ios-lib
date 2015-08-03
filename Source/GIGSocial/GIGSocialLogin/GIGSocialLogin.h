//
//  GIGSocialLogin.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^GIGSocialLoginFacebookCompletion)(BOOL success, NSString *userID, NSString *accessToken, NSError *error);


typedef NS_ENUM (NSUInteger, GIGLogLevel)
{
	GIGSocialLoginErrorUnknow
};


@interface GIGSocialLogin : NSObject

- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler;

@end
