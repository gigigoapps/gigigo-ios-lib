//
//  GIGLoginResult.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGFacebookLoginResult : NSObject

@property (assign, nonatomic) BOOL success;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *accessToken;
@property (assign, nonatomic) BOOL isCancelled;
@property (strong, nonatomic) NSError *error;

@end
