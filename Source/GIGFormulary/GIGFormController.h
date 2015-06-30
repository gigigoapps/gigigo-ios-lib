//
//  GIGFormController.h
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GIGFormField.h"


@interface GIGFormController : NSObject

@property (assign, nonatomic) BOOL addSeparators;
@property (assign, nonatomic) CGFloat fieldsMargin;
@property (copy, nonatomic) NSDictionary *fieldValues;

- (instancetype)initWithView:(UIView *)view headerView:(UIView *)headerView footerView:(UIView *)footerView;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

- (void)showFields:(NSArray *)fields;
- (BOOL)validateFields;

- (void)formFieldDidStart:(GIGFormField *)formField;
- (void)formFieldDidFinish:(GIGFormField *)formField;
- (void)formField:(GIGFormField *)formField didChangeValue:(id)value;

@end
