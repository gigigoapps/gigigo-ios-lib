//
//  UIView+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 22/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "UIView+GIGExtension.h"


@implementation UIView (GIGExtension)

+ (instancetype)loadFromNib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end
