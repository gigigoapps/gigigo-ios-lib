//
//  GIGCommunicator.h
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGURLRequest.h"

@class GIGURLRequestFactory;


typedef void(^GIGURLMultiRequestCompletion)(NSDictionary *responses);


@interface GIGURLCommunicator : NSObject

@property (assign, nonatomic) GIGLogLevel logLevel;
@property (assign, nonatomic, readonly) NSString *host;

- (instancetype)initWithManager:(GIGURLManager *)manager;
- (instancetype)initWithRequestFactory:(GIGURLRequestFactory *)requestFactory manager:(GIGURLManager *)manager;

- (GIGURLRequest *)GET:(NSString *)url;
- (GIGURLRequest *)POST:(NSString *)url;
- (GIGURLRequest *)DELETE:(NSString *)url;
- (GIGURLRequest *)PUT:(NSString *)url;
- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url;

- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion;
- (void)cancelLastRequest;

@end
