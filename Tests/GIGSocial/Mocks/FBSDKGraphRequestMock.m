//
//  FBSDKGraphRequestMock.m
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 4/11/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "FBSDKGraphRequestMock.h"

@implementation FBSDKGraphRequestMock


- (instancetype)initWithGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters
{
	self = [super initWithGraphPath:graphPath parameters:parameters];
	
	if (self)
	{
		self.outParams = parameters;
	}
	
	return self;
}


- (FBSDKGraphRequestConnection *)startWithCompletionHandler:(FBSDKGraphRequestHandler)handler
{
	handler(nil, self.inUser, self.inError);
	return nil;
}

@end
