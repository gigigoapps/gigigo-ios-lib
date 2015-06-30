//
//  GIGCommunicator.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLCommunicator.h"

#import "GIGURLManager.h"
#import "GIGURLRequestFactory.h"


@interface GIGURLCommunicator ()

@property (strong, nonatomic) GIGURLRequestFactory *requestFactory;
@property (strong, nonatomic) GIGURLManager *manager;

@property (strong, nonatomic) GIGURLRequest *lastRequest;
@property (copy, nonatomic) GIGURLMultiRequestCompletion requestsCompletion;

@end


@implementation GIGURLCommunicator

- (instancetype)init
{
    GIGURLRequestFactory *requestFactory = [[GIGURLRequestFactory alloc] init];
    GIGURLManager *manager = [GIGURLManager sharedManager];
    
    return [self initWithRequestFactory:requestFactory manager:manager];
}

- (instancetype)initWithManager:(GIGURLManager *)manager
{
    GIGURLRequestFactory *requestFactory = [[GIGURLRequestFactory alloc] initWithManager:manager];
    
    return [self initWithRequestFactory:requestFactory manager:manager];
}

- (instancetype)initWithRequestFactory:(GIGURLRequestFactory *)requestFactory
{
    GIGURLManager *manager = [GIGURLManager sharedManager];
    
    return [self initWithRequestFactory:requestFactory manager:manager];
}

- (instancetype)initWithRequestFactory:(GIGURLRequestFactory *)requestFactory manager:(GIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _requestFactory = requestFactory;
        _manager = manager;
        
        _logLevel = GIGLogLevelError;
    }
    return self;
}

#pragma mark - ACCESSORS

- (NSString *)host
{
    return self.manager.domain.url;
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

- (void)sendRequest:(GIGURLRequest *)request completion:(GIGURLRequestCompletion)completion
{
    self.lastRequest = request;
    self.lastRequest.completion = completion;
    
    [request send];
}

- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion
{
    self.requestsCompletion = completion;
    
    NSMutableDictionary *responses = [[NSMutableDictionary alloc] initWithCapacity:requests.count];
    dispatch_group_t groupRequests = dispatch_group_create();
    
    [requests enumerateKeysAndObjectsUsingBlock:^(NSString *requestKey, GIGURLRequest *request, __unused BOOL *stop) {
        dispatch_group_enter(groupRequests);
        
        request.completion = ^(GIGURLResponse *response) {
            responses[requestKey] = response;
            dispatch_group_leave(groupRequests);
        };
        
        [request send];
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
