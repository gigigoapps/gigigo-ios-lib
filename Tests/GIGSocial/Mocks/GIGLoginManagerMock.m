//
//  GIGLoginManagerMock.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 29/9/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGLoginManagerMock.h"

@implementation GIGLoginManagerMock

- (void)logInWithReadPermissions:(NSArray *)permissions handler:(FBSDKLoginManagerRequestTokenHandler)handler
{
	if (self.error)
	{
		handler(nil, self.error);
	}
}

@end
