//
//  GIGCommunicator.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLCommunicator.h"

#import "GIGURLRequestFactory.h"

#import "GIGURLResponse.h"


@interface GIGURLCommunicator ()

@property (strong, nonatomic) GIGURLRequestFactory *requestFactory;
@property (strong, nonatomic) GIGURLRequest *lastRequest;
@property (copy, nonatomic) GIGURLMultiRequestCompletion requestsCompletion;

@end


@implementation GIGURLCommunicator

- (instancetype)init
{
    GIGURLRequestFactory *requestFactory = [[GIGURLRequestFactory alloc] init];
    
    return [self initWithRequestFactory:requestFactory];
}

- (instancetype)initWithManager:(GIGURLManager *)manager
{
    GIGURLRequestFactory *requestFactory = [[GIGURLRequestFactory alloc] initWithManager:manager];
    
    return [self initWithRequestFactory:requestFactory];
}

- (instancetype)initWithRequestFactory:(GIGURLRequestFactory *)requestFactory
{
    self = [super init];
    if (self)
    {
        _requestFactory = requestFactory;
        _logLevel = GIGLogLevelError;
    }
    return self;
}

#pragma mark - PUBLIC

- (GIGURLRequest *)GET:(NSString *)url
{
    return [self requestWithMethod:@"GET" url:url];
}

- (GIGURLRequest *)POST:(NSString *)url
{
    return [self requestWithMethod:@"POST" url:url];
}

- (GIGURLRequest *)DELETE:(NSString *)url
{
    return [self requestWithMethod:@"DELETE" url:url];
}

- (GIGURLRequest *)PUT:(NSString *)url
{
    return [self requestWithMethod:@"PUT" url:url];
}

- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url
{
    self.lastRequest = [self.requestFactory requestWithMethod:method url:url];
    self.lastRequest.logLevel = self.logLevel;
    
    return self.lastRequest;
}

- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion
{
    self.requestsCompletion = completion;
    
    NSMutableDictionary *responses = [[NSMutableDictionary alloc] initWithCapacity:requests.count];
    dispatch_group_t groupRequests = dispatch_group_create();
    
    [requests enumerateKeysAndObjectsUsingBlock:^(NSString *requestKey, GIGURLRequest *request, __unused BOOL *stop) {
        dispatch_group_enter(groupRequests);
        
        [request send:^(GIGURLResponse *response) {
            responses[requestKey] = response;
            dispatch_group_leave(groupRequests);
        }];
    }];
    
    __weak typeof(self) this = self;
    dispatch_group_notify(groupRequests, dispatch_get_main_queue(), ^{
        if (this.requestsCompletion)
        {
            this.requestsCompletion(responses);
            this.requestsCompletion = nil;
        }
    });
}

- (void)cancelLastRequest
{
    [self.lastRequest cancel];
}

@end
