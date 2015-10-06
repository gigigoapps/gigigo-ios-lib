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

- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler;

@end
