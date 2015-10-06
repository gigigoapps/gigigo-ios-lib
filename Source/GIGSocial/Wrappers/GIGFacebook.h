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
@class GIGFacebookAccessTokenFactory;


typedef void(^GIGFacebookLoginCompletion)(GIGFacebookLoginResult *result);


@interface GIGFacebook : NSObject

- (instancetype)initWithLoginManager:(FBSDKLoginManager *)loginManager accessToken:(GIGFacebookAccessTokenFactory *)accessTokenFactory;

- (void)login:(GIGFacebookLoginCompletion)completionHandler;

@end
