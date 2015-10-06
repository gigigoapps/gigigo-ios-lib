//
//  GIGFacebookAccessTokenFactoryMock.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookAccessTokenFactoryMock.h"
#import "FBSDKAccessTokenMock.h"

@implementation GIGFacebookAccessTokenFactoryMock

- (FBSDKAccessToken *)getCurrentToken
{
	return self.accessToken;
}

@end
