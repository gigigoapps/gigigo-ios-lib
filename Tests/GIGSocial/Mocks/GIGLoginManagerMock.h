//
//  GIGLoginManagerMock.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 29/9/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface GIGLoginManagerMock : FBSDKLoginManager

// Inputs
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) FBSDKLoginManagerLoginResult *loginResult;

// Outputs
@property (strong, nonatomic) NSArray *requestedPermissions;

@end
