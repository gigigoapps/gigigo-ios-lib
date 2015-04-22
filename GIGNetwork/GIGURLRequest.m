//
//  GIGURLRequest.m
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLRequest.h"

#import "GIGURLConnectionBuilder.h"
#import "GIGURLRequestLogger.h"
#import "GIGURLManager.h"


static NSString * const GIGNetworkErrorDomain = @"com.gigigo.network";


@interface GIGURLRequest ()

@property (strong, nonatomic) GIGURLConnectionBuilder *connectionBuilder;
@property (strong, nonatomic) GIGURLRequestLogger *requestLogger;
@property (strong, nonatomic) GIGURLManager *manager;

@property (strong, nonatomic) NSURLConnection *connection;
@property (copy, nonatomic) GIGURLRequestCompletion completion;

@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSError *error;

@end


@implementation GIGURLRequest

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
{
    GIGURLManager *manager = [GIGURLManager sharedManager];
    
    return [self initWithMethod:method url:url manager:manager];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url manager:(GIGURLManager *)manager
{
    GIGURLConnectionBuilder *connectionBuilder = [[GIGURLConnectionBuilder alloc] init];
    GIGURLRequestLogger *requestLogger = [[GIGURLRequestLogger alloc] init];
    
    return [self initWithMethod:method url:url connectionBuilder:connectionBuilder requestLogger:requestLogger manager:manager];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
             connectionBuilder:(GIGURLConnectionBuilder *)connectionBuilder
                 requestLogger:(GIGURLRequestLogger *)requestLogger
                       manager:(GIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _method = method;
        _url = url;
        _connectionBuilder = connectionBuilder;
        _requestLogger = requestLogger;
        _manager = manager;
        
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _timeout = 0;
        _responseClass = [GIGURLResponse class];
        _logLevel = GIGLevelError;
    }
    return self;
}

#pragma mark - ACCESSOR

- (void)setRequestTag:(NSString *)requestTag
{
    _requestTag = requestTag;
    
    self.requestLogger.tag = requestTag;
}

- (void)setLogLevel:(GIGLogLevel)logLevel
{
    _logLevel = logLevel;
    
    self.requestLogger.logLevel = logLevel;
}

#pragma mark - PUBLIC

- (void)send:(GIGURLRequestCompletion)completion
{
    self.completion = completion;

    if (self.manager.useFixture)
    {
        [self mockResponseWithCompletion:completion];
        return;
    }

    self.connection = [self.connectionBuilder buildConnectionWithRequest:self];
    [self.requestLogger logRequest:self.connection.originalRequest encoding:self.connectionBuilder.stringEncoding];
    
    [self.connection start];
}

- (void)cancel
{
    [self.connection cancel];
}

#pragma mark - MOCKS

- (void)mockResponseWithCompletion:(GIGURLRequestCompletion)completion
{
    if (completion == nil) return;
    
    NSData *mockData = [self.manager mockForRequestTag:self.requestTag];
    if (!mockData)
    {
        self.error = [NSError errorWithDomain:GIGNetworkErrorDomain code:404 userInfo:nil];
        [self completeWithError];
        
        return;
    }
    
    self.data = [[NSMutableData alloc] initWithData:mockData];
    
    NSURL *URL = [NSURL URLWithString:self.url];
    self.response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    [self completeWithData];
}

#pragma mark - PRIVATE

- (void)completeWithData
{
    [self.requestLogger logResponse:self.response data:self.data error:self.error stringEncoding:self.connectionBuilder.stringEncoding];
    
    if (self.completion)
    {
        GIGURLResponse *response = [[self.responseClass alloc] initWithData:self.data];
        self.completion(response);
    }
}

- (void)completeWithError
{
    [self.requestLogger logResponse:self.response data:self.data error:self.error stringEncoding:self.connectionBuilder.stringEncoding];

    if (self.completion)
    {
        GIGURLResponse *response = [[self.responseClass alloc] initWithError:self.error];
        self.completion(response);
    }
}

- (BOOL)isSuccess
{
    return (self.response.statusCode >= 200 && self.response.statusCode < 300);
}

#pragma mark - DELEGATES

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    [self completeWithError];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    self.response = (NSHTTPURLResponse *)aResponse;
    self.data = [NSMutableData data];
    
    if (![self isSuccess])
    {
        self.error = [NSError errorWithDomain:GIGNetworkErrorDomain code:self.response.statusCode userInfo:nil];
        [self completeWithError];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData
{
    [self.data appendData:someData];
    
    if (self.downloadProgress)
    {
        float progress = ((float)self.data.length / (float)[self.response expectedContentLength]);
        self.downloadProgress(progress);
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.uploadProgress)
    {
        float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
        self.uploadProgress(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self isSuccess])
    {
        [self completeWithData];
    }
}

@end
