//
//  FBSDKGraphRequestMock.h
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 4/11/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FBSDKGraphRequestMock : FBSDKGraphRequest

@property (strong, nonatomic) NSDictionary *inUser;
@property (strong, nonatomic) NSError *inError;

@property (strong, nonatomic) NSDictionary *outParams;

@end
