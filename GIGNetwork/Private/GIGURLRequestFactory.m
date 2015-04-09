//
//  GIGURLRequestFactory.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLRequestFactory.h"

#import "GIGURLRequest.h"
#import "GIGURLManager.h"


@interface GIGURLRequestFactory ()

@property (strong, nonatomic) GIGURLManager *manager;

@end


@implementation GIGURLRequestFactory

- (instancetype)init
{
    GIGURLManager *manager = [GIGURLManager sharedManager];
    
    return [self initWithManager:manager];
}

- (instancetype)initWithManager:(GIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _manager = manager;
    }
    return self;
}

#pragma mark - PUBLIC

- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url
{
    return [[GIGURLRequest alloc] initWithMethod:method url:url manager:self.manager];
}

@end
