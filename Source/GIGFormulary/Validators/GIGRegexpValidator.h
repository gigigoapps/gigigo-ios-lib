//
//  GIGRegexpValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGValidator.h"


@interface GIGRegexpValidator : GIGValidator

@property (strong, nonatomic, readonly) NSRegularExpression *regexp;

- (instancetype)initWithRegexp:(NSRegularExpression *)regexp;
- (instancetype)initWithRegexpPattern:(NSString *)regexpPattern;

@end
