//
//  GIGFacebook.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIGFacebookLoginResult.h"
#import "GIGFacebookUser.h"

@class FBSDKLoginManager;
@class GIGFacebookAccessTokenFactory;


typedef void(^GIGFacebookLoginCompletion)(GIGFacebookLoginResult *result);
typedef void(^GIGFacebookMeCompletion)(BOOL success, GIGFacebookUser *user, NSError *error);


@interface GIGFacebook : NSObject

/**
 *	@abstract Permissions to be used for login
 *	
 *	@discussion if nil, permissions will be only permission by default: "public_profile".
 *	
 *	@example For example: ["email"]	will login with both "public_profile" and "email" permissions
 */
@property (strong, nonatomic) NSArray *extraPermissions;
@property (strong, nonatomic) NSArray *extraFields;

- (instancetype)initWithLoginManager:(FBSDKLoginManager *)loginManager accessToken:(GIGFacebookAccessTokenFactory *)accessTokenFactory;

- (void)login:(GIGFacebookLoginCompletion)completionHandler;
- (void)me:(GIGFacebookMeCompletion)completionHandler;

@end
