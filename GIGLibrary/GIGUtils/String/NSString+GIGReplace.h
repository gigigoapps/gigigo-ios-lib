//
//  NSString+GIGReplace.h
//  utils
//
//  Created by Sergio Baró on 14/01/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (GIGReplace)

- (NSString *)stringByReplacingCharactersInString:(NSString *)charactersString withString:(NSString *)string;
- (NSArray *)toCharactersArray;

@end
