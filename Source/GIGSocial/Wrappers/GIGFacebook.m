//
//  GIGFacebook.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebook.h"
#import "GIGLogManager.h"


@implementation GIGFacebook


- (void)login:(GIGFacebookLoginCompletion)completionHandler
{
	//TODO: refactor commeted code
	GIGLogWarn(@"TODO");
	
	
//	// Check if logged
//	FBSDKAccessToken *currentAccessToken = [FBSDKAccessToken currentAccessToken];
//	if (currentAccessToken)
//	{
//		completionHandler(YES, currentAccessToken.userID, currentAccessToken.tokenString, nil);
//	}
//	else
//	{
//		FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//		[login logInWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
//		 {
//			 if (error)
//			 {
//				 GIGLogNSError(error);
//				 
//				 CNTError *errorConnect = [CNTErrorManager errorWithFacebookError:error];
//				 completionHandler(NO, nil, nil, errorConnect);
//			 }
//			 else if (result.isCancelled)
//			 {
//				 // DO NOTHING
//				 GIGLogWarn(@"Facebook was cancelled");
//				 completionHandler(NO, nil, nil, nil);
//			 }
//			 else
//			 {
//				 completionHandler(YES, result.token.userID, result.token.tokenString, nil);
//			 }
//		 }];
//	}
}


@end
