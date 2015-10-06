//
//  GIGFacebookAccessTokenFactory.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBSDKAccessToken;

@interface GIGFacebookAccessTokenFactory : NSObject

- (FBSDKAccessToken *)getCurrentToken;

@end
