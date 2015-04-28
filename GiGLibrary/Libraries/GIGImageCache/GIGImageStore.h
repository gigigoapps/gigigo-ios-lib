//
//  GIGImageStore.h
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIGFileManager;


extern CGFloat const GIGImagesStoreDefaultQuality;


@interface GIGImageStore : NSObject

- (instancetype)initWithRootPath:(NSString *)rootPath;
- (instancetype)initWithFileManager:(GIGFileManager *)fileManager screenScale:(CGFloat)screenScale;

- (void)storeImage:(UIImage *)image name:(NSString *)name;
- (UIImage *)imageWithName:(NSString *)name;
- (BOOL)removeImageWithName:(NSString *)name;

- (void)removeAllImagesOnMemory;
- (void)removeAllImagesOnDisk;

@end
