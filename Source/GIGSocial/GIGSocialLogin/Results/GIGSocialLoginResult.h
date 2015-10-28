//
//  GIGSocialLoginResult.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIGFacebookUser.h"


typedef NS_ENUM (NSUInteger, GIGSocialLoginError)
{
	GIGSocialLoginErrorNone = 0,
	GIGSocialLoginErrorFacebookCancelled,
	GIGSocialLoginErrorFacebook				// Generic Facebook errors. See errors handling-> https://developers.facebook.com/docs/ios/errors
};


@interface GIGSocialLoginResult : NSObject

@property (assign, nonatomic) BOOL success;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) GIGFacebookUser *user;
@property (assign, nonatomic) GIGSocialLoginError loginError;
@property (strong, nonatomic) NSError *error;

@end
