//
//  GIGFacebookMock.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebook.h"
#import "GIGFacebookUser.h"

@interface GIGFacebookMock : GIGFacebook


// INPUTS LOGIN
@property (assign, nonatomic) BOOL inSuccess;
@property (strong, nonatomic) NSString *inUserId;
@property (strong, nonatomic) NSString *inAccessToken;
@property (assign, nonatomic) BOOL isCancelled;
@property (strong, nonatomic) NSError *inError;


// INPUTS ME
@property (assign, nonatomic) BOOL inMeSuccess;
@property (strong, nonatomic) GIGFacebookUser *inUser;
@property (strong, nonatomic) NSError *inMeError;


@end
