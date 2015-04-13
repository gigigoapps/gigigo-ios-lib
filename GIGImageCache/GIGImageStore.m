//
//  GIGImageStore.m
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "GIGImageStore.h"

#import "GIGDispatch.h"
#import "GIGFileManager.h"


@interface GIGImageStore ()

@property (strong, nonatomic) GIGFileManager *fileManager;
@property (assign, nonatomic) CGFloat screenScale;
@property (strong, nonatomic) NSMutableDictionary *images;

@end


@implementation GIGImageStore

- (instancetype)initWithRootPath:(NSString *)rootPath
{
    GIGFileManager *fileManager = [[GIGFileManager alloc] initWithRootPath:rootPath];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    return [self initWithFileManager:fileManager screenScale:screenScale];
}

- (instancetype)initWithFileManager:(GIGFileManager *)fileManager screenScale:(CGFloat)screenScale
{
    self = [super init];
    if (self)
    {
        self.fileManager = fileManager;
        self.screenScale = screenScale;
        self.images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)storeImage:(UIImage *)image name:(NSString *)name
{
    self.images[name] = image;
    
    __weak typeof(self) this = self;
    gig_dispatch_background(^{
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString *path = [name stringByAppendingPathExtension:@"png"];
        
        [this.fileManager storeFile:imageData atPath:path];
    });
}

- (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = self.images[name];
    
    if (!image)
    {
        NSString *path = [name stringByAppendingPathExtension:@"png"];
        
        NSData *imageData = [self.fileManager fileAtPath:path];
        image = [UIImage imageWithData:imageData scale:self.screenScale];
    }
    
    return image;
}

- (BOOL)removeImageWithName:(NSString *)name
{
    [self.images removeObjectForKey:name];
    
    NSString *path = [name stringByAppendingPathExtension:@"png"];
    
    return [self.fileManager removeFileAtPath:path];
}

- (void)removeAllImagesOnMemory
{
    [self.images removeAllObjects];
}

- (void)removeAllImagesOnDisk
{
    [self.fileManager removePath:self.fileManager.rootPath];
}

@end
