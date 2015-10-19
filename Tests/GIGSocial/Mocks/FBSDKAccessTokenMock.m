//
//  FBSDKAccessTokenMock.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez on 5/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "FBSDKAccessTokenMock.h"

@implementation FBSDKAccessTokenMock

@synthesize userID;
@synthesize tokenString;


- (instancetype)init
{
	self = [super initWithTokenString:nil
						  permissions:nil
				  declinedPermissions:nil
								appID:nil
							   userID:nil
					   expirationDate:nil
						  refreshDate:nil];
	
	return self;
}

@end
