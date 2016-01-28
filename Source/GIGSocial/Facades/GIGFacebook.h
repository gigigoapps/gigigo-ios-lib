//
//  GIGFacebook.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIGFacebookLoginResult.h"

@class FBSDKLoginManager;
@class GIGFacebookFactory;


typedef void(^GIGFacebookLoginCompletion)(GIGFacebookLoginResult *result);
typedef void(^GIGFacebookMeCompletion)(BOOL success, NSDictionary *user, NSError *error);


@interface GIGFacebook : NSObject

@property (strong, nonatomic) NSArray *extraPermissions;
@property (strong, nonatomic) NSArray *extraFields;

- (instancetype)initWithLoginManager:(FBSDKLoginManager *)loginManager accessToken:(GIGFacebookFactory *)accessTokenFactory;

- (void)login:(GIGFacebookLoginCompletion)completionHandler;
- (void)me:(GIGFacebookMeCompletion)completionHandler;

@end
