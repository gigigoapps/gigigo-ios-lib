//
//  GIGImageCache.h
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GIGConstants.h"

@class GIGImageCacheNameGenerator;
@class GIGImageStore;
@class GIGImageDownloader;


@class GIGImageCache;
@protocol GIGImageCacheDelegate <NSObject>

- (void)imageCache:(GIGImageCache *)imageCache didDownloadImage:(UIImage *)image withURL:(NSURL *)URL;

@optional
- (void)imageCache:(GIGImageCache *)imageCache didFailDownloadImageWithURL:(NSURL *)URL;

@end


@interface GIGImageCache : NSObject

@property (strong, nonatomic, readonly) NSArray *activeDownloads;
@property (assign, nonatomic) GIGLogLevel logLevel;

+ (instancetype)sharedCache;

- (instancetype)initWithRootPath:(NSString *)rootPath;
- (instancetype)initWithNameGenerator:(GIGImageCacheNameGenerator *)nameGenerator;
- (instancetype)initWithNameGenerator:(GIGImageCacheNameGenerator *)nameGenerator rootPath:(NSString *)rootPath;
- (instancetype)initWithNameGenerator:(GIGImageCacheNameGenerator *)nameGenerator
                           imageStore:(GIGImageStore *)imageStore
                      imageDownloader:(GIGImageDownloader *)imageDownloader;

- (void)downloadImageURL:(NSURL *)URL delegate:(id<GIGImageCacheDelegate>)delegate;
- (void)downloadImageURL:(NSURL *)URL;
- (void)downloadImageURLs:(NSArray *)URLs;

- (UIImage *)cachedImageWithURL:(NSURL *)URL;

- (void)removeImageWithURL:(NSURL *)URL;
- (void)removeAllImages;

- (void)clearCache;

@end
