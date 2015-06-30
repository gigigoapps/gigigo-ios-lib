//
//  GIGURLRequestTests.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLRequest.h"


@interface GIGURLRequestTests : XCTestCase

@property (strong, nonatomic) GIGURLRequest *request;

@end


@implementation GIGURLRequestTests

- (void)setUp
{
    [super setUp];
    
    self.request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" connectionBuilder:nil requestLogger:nil manager:nil];
}

- (void)tearDown
{
    self.request = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_Request_error
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    [self.request connection:nil didFailWithError:error];
    
    XCTAssertNotNil(response);
    XCTAssertFalse(response.success);
    XCTAssertTrue([response.error isEqual:error]);
}

- (void)test_Request_response_404
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:404 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [self.request connection:nil didReceiveResponse:HTTPResponse];
    
    XCTAssertNotNil(response);
    XCTAssertFalse(response.success);
    XCTAssertTrue(response.error.code == 404);
}

- (void)test_Request_response_200
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [self.request connection:nil didReceiveResponse:HTTPResponse];
    [self.request connection:nil didReceiveData:data];
    [self.request connectionDidFinishLoading:nil];
    
    XCTAssertNotNil(response);
    XCTAssertTrue(response.success);
    XCTAssertNotNil(response.data);
    XCTAssertTrue([response.data isEqualToData:data]);
    XCTAssertNil(response.error);
}

- (void)test_Request_download_progress
{
    __block float progress = 0.0f;
    self.request.downloadProgress = ^(float prog) {
        progress = prog;
    };
    [self.request send];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSDictionary *headerFields = @{@"Content-Length": [NSString stringWithFormat:@"%ld", (long)data.length]};
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
    [self.request connection:nil didReceiveResponse:HTTPResponse];
    [self.request connection:nil didReceiveData:data];
    
    XCTAssertTrue(progress == 1.0f, @"%f", progress);
}

- (void)test_Request_upload_progress
{
    __block float progress = 0.0f;
    self.request.uploadProgress = ^(float prog) {
        progress = prog;
    };
    [self.request send];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [self.request connection:nil didReceiveResponse:HTTPResponse];
    [self.request connection:nil didSendBodyData:10 totalBytesWritten:10 totalBytesExpectedToWrite:20];
    
    XCTAssertTrue(progress == 0.5f, @"%f", progress);
}

@end
