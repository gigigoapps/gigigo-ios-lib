//
//  GIGImageDownloader.h
//  images
//
//  Created by Sergio Baró on 29/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGConstants.h"

@class GIGImageDownload;


@class GIGImageDownloader;
@protocol GIGImageDownloaderDelegate <NSObject>

- (void)imageDownloader:(GIGImageDownloader *)imageDownloader didDownload:(GIGImageDownload *)imageDownload;
- (void)imageDownloader:(GIGImageDownloader *)imageDownloader didFailDownload:(GIGImageDownload *)imageDownload;

@end


@interface GIGImageDownloader : NSObject

@property (weak, nonatomic) id<GIGImageDownloaderDelegate> delegate;
@property (assign, nonatomic) GIGLogLevel logLevel;

- (void)download:(GIGImageDownload *)imageDownload;

@end
