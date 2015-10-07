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

- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler;

@end
