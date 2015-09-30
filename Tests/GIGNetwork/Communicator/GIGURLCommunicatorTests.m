//
//  GIGURLCommunicatorTests.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGTests.h"

#import "GIGURLManager.h"
#import "GIGURLCommunicator.h"


@interface GIGURLCommunicatorTests : XCTestCase

@property (strong, nonatomic) GIGURLManager *managerMock;
@property (strong, nonatomic) NSURLConnection *connectionMock;
@property (strong, nonatomic) GIGURLCommunicator *communicator;

@end


@implementation GIGURLCommunicatorTests

- (void)setUp
{
    [super setUp];
    
    self.managerMock = MKTMock([GIGURLManager class]);
    self.connectionMock = MKTMock([NSURLConnection class]);
    
    self.communicator = [[GIGURLCommunicator alloc] initWithManager:self.managerMock];
}

- (void)tearDown
{
    self.managerMock = nil;
    self.connectionMock = nil;
    self.communicator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS (Send Requests)

- (void)test_Request_GET_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  GET:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"GET"]);
}

- (void)test_Request_POST_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  POST:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"POST"]);
}

- (void)test_Request_DELETE_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  DELETE:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"DELETE"]);
}

- (void)test_Request_PUT_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  PUT:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"PUT"]);
}

- (void)test_Send_Request
{
    GIGURLRequest *request = [self.communicator GET:@"http://url"];
    NSData *data = [self dataImageType];

    __block GIGURLResponse *response = nil;
    request.completion = ^(id resp) {
        response = resp;
    };
    [request send];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [request connection:self.connectionMock didReceiveResponse:HTTPResponse];
    [request connection:self.connectionMock didReceiveData:data];
    [request connectionDidFinishLoading:self.connectionMock];
    
    XCTAssert([response.data isEqualToData:data]);
}

#pragma mark - TESTS (Mocks)

- (void)test_Response_Mock_Config
{
    NSData *expectedData = [self dataFromJSONFile:@"GET_config.json"];
    [MKTGiven([self.managerMock useFixture]) willReturnBool:YES];
    [MKTGiven([self.managerMock fixtureForRequestTag:@"config"]) willReturn:expectedData];
    
    GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:nil url:nil connectionBuilder:nil requestLogger:nil manager:self.managerMock];
    request.requestTag = @"config";
    request.completion = ^(GIGURLResponse *response) {
        XCTAssertNotNil(response);
        XCTAssertNotNil(response.data);
        XCTAssertTrue([response.data isEqual:expectedData]);
    };
    [request send];
}

- (void)test_Response_Mock_FileNotFound
{
    GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:nil url:nil connectionBuilder:nil requestLogger:nil manager:self.managerMock];
    request.requestTag = @"not_defined_on_fixture";
    
    request.completion = ^(GIGURLResponse *response) {
        XCTAssertFalse(response.success);
        XCTAssertTrue(response.error.code == 404);
    };
}

#pragma mark - HELPERS

#pragma mark - Responses

- (void)responseToRequest:(GIGURLRequest *)request delayInSeconds:(double)delayInSeconds
{
    NSData *data = [self dataImageType];
    
    dispatch_time_t responseTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(responseTime, dispatch_get_main_queue(), ^{
        NSURL *URL = [NSURL URLWithString:@"http://url"];
        NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                      statusCode:200
                                                                     HTTPVersion:@"HTTP/1.1"
                                                                    headerFields:nil];
        [request connection:self.connectionMock didReceiveResponse:HTTPResponse];
        [request connection:self.connectionMock didReceiveData:data];
        [request connectionDidFinishLoading:self.connectionMock];
    });
}

- (void)responseToRequest:(GIGURLRequest *)request data:(NSData *)data delayInSeconds:(double)delayInSeconds
{
    dispatch_time_t responseTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(responseTime, dispatch_get_main_queue(), ^{
        NSURL *URL = [NSURL URLWithString:@"http://url"];
        NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                      statusCode:200
                                                                     HTTPVersion:@"HTTP/1.1"
                                                                    headerFields:nil];
        [request connection:self.connectionMock didReceiveResponse:HTTPResponse];
        [request connection:self.connectionMock didReceiveData:data];
        [request connectionDidFinishLoading:self.connectionMock];
    });
}

- (void)responseWithErrorToRequest:(GIGURLRequest *)request statusCode:(NSInteger)statusCode delayInSeconds:(double)delayInSeconds
{
    dispatch_time_t responseTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(responseTime, dispatch_get_main_queue(), ^{
        NSURL *URL = [NSURL URLWithString:@"http://url"];
        NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                      statusCode:statusCode
                                                                     HTTPVersion:@"HTTP/1.1"
                                                                    headerFields:nil];
        [request connection:self.connectionMock didReceiveResponse:HTTPResponse];
    });
}

#pragma mark - Data Type

- (NSData *)dataImageType
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}

- (NSData *)dataTextType
{
    NSString *message = @"This is a good candidate for notifications when a group of tasks completes.";
    return [message dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Handle files

- (NSData *)dataFromJSONFile:(NSString *)filename
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    
    NSError *error = nil;
    if (!path)
    {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path options:kNilOptions error:&error];
    return data;
}

@end
