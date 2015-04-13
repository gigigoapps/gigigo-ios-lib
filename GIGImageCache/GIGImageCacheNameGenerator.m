//
//  GIGImageCacheNameGenerator.m
//  images
//
//  Created by Sergio Baró on 28/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "GIGImageCacheNameGenerator.h"

#import "GIGDigest.h"


@implementation GIGImageCacheNameGenerator

-  (NSString *)generateNameFromURL:(NSURL *)URL
{
    NSString *url = [URL absoluteString];
    
    if (url.length == 0) return nil;
    
    return [GIGDigest MD5:url];
}

@end
