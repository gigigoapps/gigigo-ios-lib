//
//  GIGURLSessionFactory.m
//  GIGLibrary
//
//  Created by Sergio Baró on 16/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGURLSessionFactory.h"

#import "GIGURLRequest.h"


@interface GIGURLSessionFactory ()

@property (strong, nonatomic) NSURLSessionConfiguration *configuration;

@end


@implementation GIGURLSessionFactory

#pragma mark - INIT

- (instancetype)init
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    return [self initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (self)
    {
        _configuration = configuration;
    }
    return self;
}

#pragma mark - PUBLIC

- (NSURLSession *)sessionForRequest:(GIGURLRequest<NSURLSessionDataDelegate> *)request
{
    return [NSURLSession sessionWithConfiguration:self.configuration delegate:request delegateQueue:nil];
}

@end
