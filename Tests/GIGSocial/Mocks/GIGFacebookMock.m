//
//  GIGFacebookMock.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookMock.h"

@implementation GIGFacebookMock

- (void)login:(GIGFacebookLoginCompletion)completionHandler
{
	GIGFacebookLoginResult *result = [[GIGFacebookLoginResult alloc] init];
	result.success = self.inSuccess;
	result.userID = self.inUserId;
	result.accessToken = self.inAccessToken;
	result.isCancelled = self.isCancelled;
	result.error = self.inError;
	
	completionHandler(result);
}

- (void)me:(GIGFacebookMeCompletion)completionHandler
{
	completionHandler(self.inMeSuccess, self.inUser, self.inMeError);
}

@end
