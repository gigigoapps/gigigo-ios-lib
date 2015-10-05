//
//  GIGFacebookAccessTokenFactory.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookAccessTokenFactory.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>


@implementation GIGFacebookAccessTokenFactory

- (FBSDKAccessToken *)getCurrentToken
{
	return [FBSDKAccessToken currentAccessToken];
}

@end
