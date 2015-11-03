//
//  GIGFacebookAccessTokenFactoryMock.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebookFactory.h"
#import "FBSDKAccessTokenMock.h"


@interface GIGFacebookAccessTokenFactoryMock : GIGFacebookFactory

@property (strong, nonatomic) FBSDKAccessTokenMock *accessToken;

@end
