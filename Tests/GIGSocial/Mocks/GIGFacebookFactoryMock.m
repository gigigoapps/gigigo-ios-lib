//
//  GIGFacebookAccessTokenFactoryMock.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookFactoryMock.h"
#import "FBSDKAccessTokenMock.h"


@implementation GIGFacebookFactoryMock

- (FBSDKAccessToken *)currentToken
{
	return self.accessToken;
}

- (FBSDKGraphRequest *)meRequestWithParams:(NSDictionary *)params
{
	FBSDKGraphRequestMock *request = [[FBSDKGraphRequestMock alloc] initWithGraphPath:@"/me" parameters:params];
	request.inUser = self.inReqUser;
	request.inError = self.inReqError;
	
	self.requestMock = request;
	
	return request;
}

@end
