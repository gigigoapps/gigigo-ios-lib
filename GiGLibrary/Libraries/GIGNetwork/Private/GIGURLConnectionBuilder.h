//
//  GIGURLConnectionBuilder.h
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLRequest;


@interface GIGURLConnectionBuilder : NSObject

@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (assign, nonatomic) NSJSONWritingOptions jsonWritingOptions;

- (NSURLConnection *)buildConnectionWithRequest:(GIGURLRequest<NSURLConnectionDelegate, NSURLConnectionDataDelegate> *)URLRequest;

@end
