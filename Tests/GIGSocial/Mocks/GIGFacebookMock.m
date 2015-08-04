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
	completionHandler(self.inSuccess, self.inUserId, self.inAccessToken, self.isCancelled, self.inError);
}

@end
