//
//  GIGURLRequestFactory.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLManager;
@class GIGURLRequest;


@interface GIGURLRequestFactory : NSObject

- (instancetype)initWithManager:(GIGURLManager *)urlManager;

- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url;

@end
