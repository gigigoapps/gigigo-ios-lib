//
//  GIGImageDownloader.m
//  images
//
//  Created by Sergio Baró on 29/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "GIGImageDownloader.h"

#import "GIGImageDownload.h"
#import "GIGURLRequest.h"
#import "GIGURLImageResponse.h"


@interface GIGImageDownloader ()

@property (strong, nonatomic) NSMutableArray *requests;

@end


@implementation GIGImageDownloader

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.requests = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)download:(GIGImageDownload *)imageDownload
{
    if (!imageDownload.downloading)
    {
        [self startDownload:imageDownload];
    }
}

#pragma mark - Private

- (void)startDownload:(GIGImageDownload *)imageDownload
{
    imageDownload.downloading = YES;
    
    GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:imageDownload.URL.absoluteString];
    request.responseClass = [GIGURLImageResponse class];
    request.logLevel = self.logLevel;
    
    [self.requests addObject:request];
    
    __weak typeof(self) this = self;
    [request send:^(GIGURLImageResponse *response) {
        imageDownload.downloading = NO;
        
        if (response.image)
        {
            imageDownload.image = response.image;
            
            [this.delegate imageDownloader:self didDownload:imageDownload];
        }
        else
        {
            [this.delegate imageDownloader:self didFailDownload:imageDownload];
        }
        
        [this.requests removeObject:request];
    }];
}

@end
