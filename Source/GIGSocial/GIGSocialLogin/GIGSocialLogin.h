//
//  GIGSocialLogin.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIGSocialLoginResult.h"


typedef void(^GIGSocialLoginFacebookCompletion)(GIGSocialLoginResult *result);


@interface GIGSocialLogin : NSObject

/**
 *	@abstract Permissions to be used for Facebook login
 *
 *	@discussion if nil, permissions will be only permission by default: "public_profile".
 *
 *	@example For example: ["email"]	will login with both "public_profile" and "email" permissions
 */
@property (strong, nonatomic) NSArray *extraPermissions;

/**
 *	@abstract User's data fields to be requested
 *
 *	@discussion By default (if nil), the data gathered is: first_name, middle_name, last_name and gender
 */
@property (strong, nonatomic) NSArray *extraFields;

/**
 *	@abstract Login with Facebook.
 *
 *	@discussion If login success, internally, the method [facebookUser:] will be called and returns also user's data
 */
- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler;

/**
 *	@abstract Facebook logout.
 *
 *	@discussion If login success, internally, the method [facebookUser:] will be called and returns also user's data
 */
- (void)facebookLogout;


@end
