//
//  FBSDKAccessTokenMock.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez on 5/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface FBSDKAccessTokenMock : FBSDKAccessToken

@property (assign, nonatomic) BOOL hasCurrentAccessToken;
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *tokenString;

- (void)swizzleMethods;
- (void)unswizzleMethods;

@end
