//
//  GIGURLRequestAuthenticationTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 31/08/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "GIGURLRequest.h"


@interface GIGURLRequestAuthenticationTests : XCTestCase

@property (strong, nonatomic) GIGURLRequest *request;
@property (strong, nonatomic) NSURLAuthenticationChallenge *challengeMock;
@property (strong, nonatomic) NSURLProtectionSpace *protectionSpaceMock;
@property (strong, nonatomic) id<NSURLAuthenticationChallengeSender> senderMock;
@property (strong, nonatomic) NSURLConnection *connectionMock;
@property (strong, nonatomic) MKTArgumentCaptor *captor;

@end

@implementation GIGURLRequestAuthenticationTests

- (void)setUp
{
    [super setUp];
    
    self.request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" connectionBuilder:nil requestLogger:nil manager:nil];
    
    self.protectionSpaceMock = MKTMock([NSURLProtectionSpace class]);
    self.senderMock = MKTMockProtocol(@protocol(NSURLAuthenticationChallengeSender));
    self.challengeMock = MKTMock([NSURLAuthenticationChallenge class]);
    self.connectionMock = MKTMock([NSURLConnection class]);
    
    [MKTGiven([self.challengeMock protectionSpace]) willReturn:self.protectionSpaceMock];
    [MKTGiven([self.challengeMock sender]) willReturn:self.senderMock];
    
    self.captor = [[MKTArgumentCaptor alloc] init];
}

- (void)tearDown
{
    self.request = nil;
    self.challengeMock = nil;
    self.protectionSpaceMock = nil;
    self.senderMock = nil;
    self.connectionMock = nil;
    
    self.captor = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_authentication_default
{
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) continueWithoutCredentialForAuthenticationChallenge:self.challengeMock];
}

- (void)test_authentication_ignore_ssl
{
    self.request.ignoreSSL = YES;
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) useCredential:[self.captor capture] forAuthenticationChallenge:self.challengeMock];
    
    NSURLCredential *credential = [self.captor value];
    XCTAssertNotNil(credential);
}

- (void)test_authentication_http_basic
{
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTTPBasic];
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) useCredential:[self.captor capture] forAuthenticationChallenge:self.challengeMock];
    
    NSURLCredential *credential = [self.captor value];
    XCTAssertNotNil(credential);
    XCTAssertTrue([credential.user isEqualToString:@"user"]);
    XCTAssertTrue([credential.password isEqualToString:@"password"]);
}

- (void)test_authentication_block_returns_nil
{
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodDefault];
    
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return nil;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) continueWithoutCredentialForAuthenticationChallenge:self.challengeMock];
}

- (void)test_authentication_block_returns_credential
{
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodDefault];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user" password:@"password" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) useCredential:credential forAuthenticationChallenge:self.challengeMock];
}

- (void)test_authentication_block_and_ignore_ssl
{
    self.request.ignoreSSL = YES;
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user" password:@"password" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerifyCount(self.senderMock, MKTNever()) useCredential:credential forAuthenticationChallenge:self.challengeMock];
    [MKTVerify(self.senderMock) useCredential:HC_notNilValue() forAuthenticationChallenge:self.challengeMock];
}

- (void)test_authentication_block_and_http_basic
{
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTTPBasic];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerifyCount(self.senderMock, MKTNever()) useCredential:credential forAuthenticationChallenge:self.challengeMock];
    [MKTVerify(self.senderMock) useCredential:[self.captor capture] forAuthenticationChallenge:self.challengeMock];
    
    NSURLCredential *usedCredential = [self.captor value];
    XCTAssertTrue([usedCredential.user isEqualToString:@"user"]);
    XCTAssertTrue([usedCredential.password isEqualToString:@"password"]);
}

- (void)test_authentication_block_and_http_basic_trust_authentication
{
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) useCredential:[self.captor capture] forAuthenticationChallenge:self.challengeMock];
    
    NSURLCredential *usedCredential = [self.captor value];
    XCTAssertTrue([usedCredential.user isEqualToString:@"user2"]);
    XCTAssertTrue([usedCredential.password isEqualToString:@"password2"]);
}

- (void)test_authentication_block_and_ignore_ssl_basic_authentication
{
    self.request.ignoreSSL = YES;
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTTPBasic];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) useCredential:[self.captor capture] forAuthenticationChallenge:self.challengeMock];
    
    NSURLCredential *usedCredential = [self.captor value];
    XCTAssertTrue([usedCredential.user isEqualToString:@"user2"]);
    XCTAssertTrue([usedCredential.password isEqualToString:@"password2"]);
}

- (void)test_authentication_block_and_ignore_ssl_and_http_basic_other_authentication
{
    self.request.ignoreSSL = YES;
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTMLForm];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    [self.request connection:self.connectionMock willSendRequestForAuthenticationChallenge:self.challengeMock];
    
    [MKTVerify(self.senderMock) useCredential:[self.captor capture] forAuthenticationChallenge:self.challengeMock];
    
    NSURLCredential *usedCredential = [self.captor value];
    XCTAssertTrue([usedCredential.user isEqualToString:@"user2"]);
    XCTAssertTrue([usedCredential.password isEqualToString:@"password2"]);
}

@end
