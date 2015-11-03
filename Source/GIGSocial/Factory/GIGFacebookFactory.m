//
//  GIGFacebookAccessTokenFactory.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookFactory.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>


@implementation GIGFacebookFactory

- (FBSDKAccessToken *)currentToken
{
	return [FBSDKAccessToken currentAccessToken];
}

- (FBSDKGraphRequest *)meRequestWithParams:(NSDictionary *)params
{
	return [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:params];
}

@end
