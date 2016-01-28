//
//  GIGFacebookAccessTokenFactoryMock.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookFactory.h"
#import "FBSDKAccessTokenMock.h"
#import "FBSDKGraphRequestMock.h"

@interface GIGFacebookFactoryMock : GIGFacebookFactory

@property (strong, nonatomic) FBSDKAccessTokenMock *accessToken;
@property (strong, nonatomic) FBSDKGraphRequestMock *requestMock;

// INPUTS
@property (strong, nonatomic) NSDictionary *inReqUser;
@property (strong, nonatomic) NSError *inReqError;

@end
