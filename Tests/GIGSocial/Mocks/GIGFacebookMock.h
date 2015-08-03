//
//  GIGFacebookMock.h
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFacebook.h"

@interface GIGFacebookMock : GIGFacebook


// INPUTS
@property (assign, nonatomic) BOOL inSuccess;
@property (strong, nonatomic) NSString *inUserId;
@property (strong, nonatomic) NSString *inAccessToken;
@property (strong, nonatomic) NSError *inError;


@end
