//
//  NSBundle+GIGLibrary.h
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSBundle (GIGLibrary)

- (NSData *)dataForFile:(NSString *)fileName;
- (id)loadJSONFile:(NSString *)jsonFile rootNode:(NSString *)rootNode;

@end
