//
//  GIGURLRequest.h
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGConstants.h"
#import "GIGURLFile.h"
#import "GIGURLResponse.h"

@class GIGURLConnectionBuilder;
@class GIGURLRequestLogger;
@class GIGURLManager;


typedef void(^GIGURLRequestCompletion)(id response);
typedef void(^GIGURLRequestProgress)(float progress); // 0.0 to 1.0


@interface GIGURLRequest : NSObject
<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (assign, nonatomic) NSTimeInterval timeout;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSArray *files; // GIGURLFile instances
@property (strong, nonatomic) NSDictionary *json;
@property (strong, nonatomic) Class responseClass; // GIGURLResponse or subclass

@property (strong, nonatomic) NSString *requestTag;
@property (assign, nonatomic) GIGLogLevel logLevel;

@property (copy, nonatomic) GIGURLRequestProgress downloadProgress;
@property (copy, nonatomic) GIGURLRequestProgress uploadProgress;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;
- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url manager:(GIGURLManager *)manager;
- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
             connectionBuilder:(GIGURLConnectionBuilder *)connectionBuilder
                 requestLogger:(GIGURLRequestLogger *)requestLogger
                       manager:(GIGURLManager *)manager;

- (void)send:(GIGURLRequestCompletion)completion;
- (void)cancel;

@end
