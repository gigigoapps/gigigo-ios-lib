//
//  GIGCharactersValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <GIGLibrary/GIGLibrary.h>


@interface GIGCharactersValidator : GIGValidator

- (instancetype)initWithCharacters:(NSString *)characters;
- (instancetype)initWithCharacterSet:(NSCharacterSet *)characterSet;

@end
