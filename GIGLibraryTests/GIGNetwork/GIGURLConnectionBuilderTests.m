//
//  GIGURLConnectionBuilderTests.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLConnectionBuilder.h"
#import "GIGURLRequest.h"


@interface GIGURLConnectionBuilderTests : XCTestCase

@property (strong, nonatomic) GIGURLConnectionBuilder *builder;

@end


@implementation GIGURLConnectionBuilderTests

- (void)setUp
{
    [super setUp];
    
    self.builder = [[GIGURLConnectionBuilder alloc] init];
}

- (void)tearDown
{
    [super tearDown];

    self.builder = nil;
    
}

#pragma mark - TESTS

- (void)test_Request_with_nil_url
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"GET" url:nil manager:nil];
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    
    XCTAssertNil(connection);
}

- (void)test_Request_with_url
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" manager:nil];
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue([request.URL.absoluteString isEqualToString:@"http://url"], @"%@", request.URL.absoluteString);
    XCTAssertTrue([request.HTTPMethod isEqualToString:@"GET"], @"%@", request.HTTPMethod);
}

- (void)test_Request_cache_and_timeout
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" manager:nil];
    URLRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    URLRequest.timeout = 10;
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue(request.cachePolicy == URLRequest.cachePolicy);
    XCTAssertTrue(request.timeoutInterval == URLRequest.timeout);
}

- (void)test_Request_headers
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" manager:nil];
    URLRequest.headers = @{@"header":@"value"};
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue([[request valueForHTTPHeaderField:@"header"] isEqualToString:@"value"]);
}

- (void)test_Request_querystring
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" manager:nil];
    URLRequest.parameters = @{@"param":@"value"};
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue([request.URL.absoluteString isEqualToString:@"http://url?param=value"], @"%@", request.URL.absoluteString);
    XCTAssertNil(request.HTTPBody);
}

- (void)test_Request_parameters_in_body
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"POST" url:@"http://url" manager:nil];
    URLRequest.parameters = @{@"param":@"value"};
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue([request.URL.absoluteString isEqualToString:@"http://url"], @"%@", request.URL.absoluteString);
    XCTAssertNotNil(request.HTTPBody);
}

- (void)test_Request_body_multipart
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"POST" url:@"http://url" manager:nil];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    GIGURLFile *file = [[GIGURLFile alloc] init];
    file.data = UIImagePNGRepresentation(image);
    file.parameterName = @"file";
    file.fileName = @"image.png";
    file.mimeType = @"image/png";

    URLRequest.files = @[file];
    
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue([request.URL.absoluteString isEqualToString:@"http://url"], @"%@", request.URL.absoluteString);
    XCTAssertNotNil(request.HTTPBody);
    XCTAssertNotNil([request valueForHTTPHeaderField:@"Content-Type"]);
    XCTAssertNotNil([request valueForHTTPHeaderField:@"Content-Length"]);
}

- (void)test_Request_json_body
{
    GIGURLRequest *URLRequest = [[GIGURLRequest alloc] initWithMethod:@"PUT" url:@"http://url" manager:nil];
    URLRequest.json = @{@"key":@"value"};
    
    NSURLConnection *connection = [self.builder buildConnectionWithRequest:URLRequest];
    NSURLRequest *request = connection.originalRequest;
    
    XCTAssertTrue([request.URL.absoluteString isEqualToString:@"http://url"], @"%@", request.URL.absoluteString);
    XCTAssertNotNil(request.HTTPBody);
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
    XCTAssertTrue([URLRequest.json isEqualToDictionary:json], @"%@", json);
    XCTAssertNotNil([request valueForHTTPHeaderField:@"Content-Type"]);
}

@end
