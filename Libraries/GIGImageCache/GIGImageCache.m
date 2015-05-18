//
//  GIGImageCache.m
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "GIGImageCache.h"

#import "GIGImageDownload.h"
#import "GIGImageStore.h"
#import "GIGImageDownloader.h"
#import "GIGImageCacheNameGenerator.h"
#import "GIGFileManager.h"


@interface GIGImageCache ()
<GIGImageDownloaderDelegate>

@property (strong, nonatomic) GIGImageCacheNameGenerator *nameGenerator;
@property (strong, nonatomic) GIGImageStore *imageStore;
@property (strong, nonatomic) GIGImageDownloader *imageDownloader;

@property (strong, nonatomic) NSMutableDictionary *downloads;

@end


@implementation GIGImageCache

+ (instancetype)sharedCache
{
    static GIGImageCache *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GIGImageCache alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    GIGImageCacheNameGenerator *nameGenerator = [[GIGImageCacheNameGenerator alloc] init];
    
    return [self initWithNameGenerator:nameGenerator];
}

- (instancetype)initWithRootPath:(NSString *)rootPath
{
    GIGImageCacheNameGenerator *nameGenerator = [[GIGImageCacheNameGenerator alloc] init];
    
    return [self initWithNameGenerator:nameGenerator rootPath:rootPath];
}

- (instancetype)initWithNameGenerator:(GIGImageCacheNameGenerator *)nameGenerator
{
    NSString *rootPath = [[GIGFileManager cachesPath] stringByAppendingPathComponent:@"gig_images"];
    
    return [self initWithNameGenerator:nameGenerator rootPath:rootPath];
}

- (instancetype)initWithNameGenerator:(GIGImageCacheNameGenerator *)nameGenerator rootPath:(NSString *)rootPath
{
    GIGImageStore *imageStore = [[GIGImageStore alloc] initWithRootPath:rootPath];
    GIGImageDownloader *imageDownloader = [[GIGImageDownloader alloc] init];
    
    return [self initWithNameGenerator:nameGenerator imageStore:imageStore imageDownloader:imageDownloader];
}

- (instancetype)initWithNameGenerator:(GIGImageCacheNameGenerator *)nameGenerator
                           imageStore:(GIGImageStore *)imageStore
                      imageDownloader:(GIGImageDownloader *)imageDownloader
{
    self = [super init];
    if (self)
    {
        self.nameGenerator = nameGenerator;
        self.imageStore = imageStore;
        self.imageDownloader = imageDownloader;
        self.imageDownloader.delegate = self;
        
        self.downloads = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Custom Accessors

- (NSArray *)activeDownloads
{
    return [self.downloads allValues];
}

- (void)setLogLevel:(GIGLogLevel)logLevel
{
    _logLevel = logLevel;
    
    self.imageDownloader.logLevel = self.logLevel;
}

#pragma mark - Public

- (void)downloadImageURL:(NSURL *)URL delegate:(id<GIGImageCacheDelegate>)delegate
{
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return;
    
    UIImage *image = [self.imageStore imageWithName:name];
    if (image)
    {
        [delegate imageCache:self didDownloadImage:image withURL:URL];
    }
    else
    {
        GIGImageDownload *imageDownload = [self imageDownloadWithName:name andURL:URL];
    
        [imageDownload addDelegate:delegate];
        
        [self.imageDownloader download:imageDownload];
    }
}

- (void)downloadImageURL:(NSURL *)URL
{
    if (self.logLevel != GIGLogLevelNone)
    {
        NSLog(@"IMAGES MANAGER: Download: %@", URL);
    }
    
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return;
    
    UIImage *image = [self.imageStore imageWithName:name];
    if (!image)
    {
        GIGImageDownload *imageDownload = [self imageDownloadWithName:name andURL:URL];
        [self.imageDownloader download:imageDownload];
    }
}

- (void)downloadImageURLs:(NSArray *)URLs
{
    for (NSURL *URL in URLs)
    {
        [self downloadImageURL:URL];
    }
}

- (UIImage *)cachedImageWithURL:(NSURL *)URL
{
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return nil;
    
    return [self.imageStore imageWithName:name];
}

- (void)removeImageWithURL:(NSURL *)URL
{
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return;
    
    [self.imageStore removeImageWithName:name];
}

- (void)removeAllImages
{
    [self.imageStore removeAllImagesOnMemory];
    [self.imageStore removeAllImagesOnDisk];
}

- (void)clearCache
{
    [self.imageStore removeAllImagesOnMemory];
}

#pragma mark - Private

- (GIGImageDownload *)imageDownloadWithName:(NSString *)name andURL:(NSURL *)URL
{
    GIGImageDownload *imageDownload = self.downloads[name];
    
    if (!imageDownload)
    {
        imageDownload = [[GIGImageDownload alloc] initWithImageName:name andURL:URL];
        self.downloads[name] = imageDownload;
    }
    
    return imageDownload;
}

#pragma mark - GIGImageDownloaderDelegate

- (void)imageDownloader:(GIGImageDownloader *)imageDownloader didDownload:(GIGImageDownload *)imageDownload
{
    [self.imageStore storeImage:imageDownload.image name:imageDownload.imageName];
    
    [imageDownload enumerateDelegates:^(id<GIGImageCacheDelegate> delegate) {
        [delegate imageCache:self didDownloadImage:imageDownload.image withURL:imageDownload.URL];
    }];
}

- (void)imageDownloader:(GIGImageDownloader *)imageDownloader didFailDownload:(GIGImageDownload *)imageDownload
{
    [imageDownload enumerateDelegates:^(id<GIGImageCacheDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(imageCache:didFailDownloadImageWithURL:)])
        {
            [delegate imageCache:self didFailDownloadImageWithURL:imageDownload.URL];
        }
    }];
}

@end