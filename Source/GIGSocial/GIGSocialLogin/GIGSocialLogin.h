//
//  GIGSocialLogin.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM (NSUInteger, GIGSocialLoginError)
{
	GIGSocialLoginErrorNone = 0,
	GIGSocialLoginErrorFacebookCancelled,
	GIGSocialLoginErrorFacebook				// Generic Facebook errors. See errors handling-> https://developers.facebook.com/docs/ios/errors
};


typedef void(^GIGSocialLoginFacebookCompletion)(BOOL success, NSString *userID, NSString *accessToken, GIGSocialLoginError loginError, NSError *error);


@interface GIGSocialLogin : NSObject

- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler;

@end
