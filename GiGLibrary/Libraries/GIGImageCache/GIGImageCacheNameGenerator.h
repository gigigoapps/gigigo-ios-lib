//
//  GIGImageCacheNameGenerator.h
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGImageCacheNameGenerator : NSObject

- (NSString *)generateNameFromURL:(NSURL *)URL;

@end
