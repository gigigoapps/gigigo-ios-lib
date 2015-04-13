//
//  GIGImageDownload.m
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "GIGImageDownload.h"


// PRIVATE CLASS
@interface GIGImageDownloadWeakDelegate : NSObject

@property (weak, nonatomic) id<GIGImageCacheDelegate> delegate;

@end

@implementation GIGImageDownloadWeakDelegate

@end



@interface GIGImageDownload ()

@property (strong, nonatomic) NSMutableArray *delegates;

@end


@implementation GIGImageDownload

- (instancetype)init
{
    return [self initWithImageName:nil andURL:nil];
}

- (instancetype)initWithImageName:(NSString *)imageName andURL:(NSURL *)URL
{
    self = [super init];
    if (self)
    {
        self.imageName = imageName;
        self.URL = URL;
        self.delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Custom Accessors

- (NSUInteger)delegatesCount
{
    return self.delegates.count;
}

#pragma mark - Public

- (void)addDelegate:(id<GIGImageCacheDelegate>)delegate
{
    GIGImageDownloadWeakDelegate *weakDelegate = [[GIGImageDownloadWeakDelegate alloc] init];
    weakDelegate.delegate = delegate;
    
    [self.delegates addObject:weakDelegate];
}

- (void)removeDelegate:(id<GIGImageCacheDelegate>)delegate
{
    GIGImageDownloadWeakDelegate *result = [self weakDelegateForDelegate:delegate];
    
    if (result)
    {
        [self.delegates removeObject:result];
    }
}

- (BOOL)hasDelegate:(id<GIGImageCacheDelegate>)delegate
{
    GIGImageDownloadWeakDelegate *weakDelegate = [self weakDelegateForDelegate:delegate];
    
    return (weakDelegate != nil);
}

- (void)enumerateDelegates:(GIGImageCacheDelegateEnumeration)block
{
    for (GIGImageDownloadWeakDelegate *weakDelegate in self.delegates)
    {
        if (weakDelegate.delegate)
        {
            block(weakDelegate.delegate);
        }
    }
}

#pragma mark - Private

- (GIGImageDownloadWeakDelegate *)weakDelegateForDelegate:(id<GIGImageCacheDelegate>)delegate
{
    for (GIGImageDownloadWeakDelegate *weakDelegate in self.delegates)
    {
        if (weakDelegate.delegate == delegate)
        {
            return weakDelegate;
        }
    }
    
    return nil;
}

@end
