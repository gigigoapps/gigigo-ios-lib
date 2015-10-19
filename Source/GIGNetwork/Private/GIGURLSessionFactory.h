//
//  GIGURLSessionFactory.h
//  GIGLibrary
//
//  Created by Sergio Baró on 16/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLRequest;


@interface GIGURLSessionFactory : NSObject

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

- (NSURLSession *)sessionForRequest:(GIGURLRequest<NSURLSessionDataDelegate> *)request;

@end
