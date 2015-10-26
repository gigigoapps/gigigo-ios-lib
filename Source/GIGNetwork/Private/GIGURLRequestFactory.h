//
//  GIGURLRequestFactory.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLRequest;


@interface GIGURLRequestFactory : NSObject

@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (assign, nonatomic) NSJSONWritingOptions jsonWritingOptions;

- (NSMutableURLRequest *)requestForRequest:(GIGURLRequest *)URLRequest;
- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url;

@end
