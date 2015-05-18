//
//  GIGURLResponse.h
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLResponse : NSObject

@property (assign, nonatomic) BOOL success;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSError *error;

- (instancetype)initWithSuccess:(BOOL)success;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithError:(NSError *)error;

@end
