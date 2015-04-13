//
//  GIGImageDownload.h
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GIGImageCacheDelegate;


typedef void(^GIGImageCacheDelegateEnumeration)(id<GIGImageCacheDelegate>delegate);


@interface GIGImageDownload : NSObject

@property (strong, nonatomic) NSURL *URL;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic, readonly) NSUInteger delegatesCount;
@property (assign, nonatomic) BOOL downloading;
@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithImageName:(NSString *)imageName andURL:(NSURL *)URL;

- (void)addDelegate:(id<GIGImageCacheDelegate>)delegate;
- (BOOL)hasDelegate:(id<GIGImageCacheDelegate>)delegate;
- (void)removeDelegate:(id<GIGImageCacheDelegate>)delegate;

- (void)enumerateDelegates:(GIGImageCacheDelegateEnumeration)block;

@end
