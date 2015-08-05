//
//  FBSDKAccessTokenMock.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez on 5/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "FBSDKAccessTokenMock.h"
#include <objc/runtime.h>


static FBSDKAccessTokenMock *staticCurrentAccessToken;


@interface FBSDKAccessTokenMock ()

@property (assign, nonatomic) Method originalMethod;
@property (assign, nonatomic) Method mockMethod;

@end


@implementation FBSDKAccessTokenMock

@synthesize userID;
@synthesize tokenString;


#pragma mark - Init

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		self.hasCurrentAccessToken = NO;
		staticCurrentAccessToken = self;
	}
	
	return self;
}


#pragma mark - Public

- (void)swizzleMethods
{
	[self swizzleMethod:@selector(currentAccessToken)
				inClass:[FBSDKAccessToken class]
			 withMethod:@selector(currentAccessToken)
			  fromClass:[FBSDKAccessTokenMock class]];
}


- (void)unswizzleMethods
{
	method_exchangeImplementations(self.mockMethod, self.originalMethod);
}


#pragma mark - Overriden

+ (FBSDKAccessToken *)currentAccessToken
{
	if (staticCurrentAccessToken.hasCurrentAccessToken)
	{
		return staticCurrentAccessToken;
	}
	else
	{
		return nil;
	}
}


#pragma mark - Private

- (void)swizzleMethod:(SEL)aOriginalMethod
			  inClass:(Class)aOriginalClass
		   withMethod:(SEL)aNewMethod
			fromClass:(Class)aNewClass
{
	self.originalMethod = class_getClassMethod(aOriginalClass, aOriginalMethod);
	self.mockMethod = class_getClassMethod(aNewClass, aNewMethod);
	
	method_exchangeImplementations(self.originalMethod, self.mockMethod);
}


@end
