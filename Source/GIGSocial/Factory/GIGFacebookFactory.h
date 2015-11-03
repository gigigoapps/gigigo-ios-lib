//
//  GIGFacebookAccessTokenFactory.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBSDKAccessToken;
@class FBSDKGraphRequest;

@interface GIGFacebookFactory : NSObject

- (FBSDKAccessToken *)currentToken;
- (FBSDKGraphRequest *)meRequestWithParams:(NSDictionary *)params;

@end
