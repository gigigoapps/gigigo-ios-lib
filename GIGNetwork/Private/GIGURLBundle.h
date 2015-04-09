//
//  GIGURLBundle.h
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLBundle : NSObject

- (instancetype)initWithBundle:(NSBundle *)bundle;

- (NSData *)dataForFile:(NSString *)fileName;
- (id)loadJSONFile:(NSString *)jsonFile rootNode:(NSString *)rootNode;

@end
