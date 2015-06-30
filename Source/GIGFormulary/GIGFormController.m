//
//  GIGFormController.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFormController.h"

#import "GIGLayout.h"
#import "GIGView.h"


@interface GIGFormController ()

@property (weak, nonatomic) UIView *view;
@property (weak, nonatomic) UIView *headerView;
@property (weak, nonatomic) UIView *footerView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@property (copy, nonatomic) NSArray *formFields;
@property (strong, nonatomic) NSMutableDictionary *formValues;

@end


@implementation GIGFormController

- (instancetype)initWithView:(UIView *)view headerView:(UIView *)headerView footerView:(UIView *)footerView
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    return [self initWithView:view headerView:headerView footerView:footerView notificationCenter:notificationCenter];
}

- (instancetype)initWithView:(UIView *)view headerView:(UIView *)headerView footerView:(UIView *)footerView notificationCenter:(NSNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self)
    {
        _view = view;
        _headerView = headerView;
        _footerView = footerView;
        _notificationCenter = notificationCenter;
        
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

#pragma mark - INIT

- (void)initialize
{
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initializeScrollView];
    [self initializeContentView];
    
    [self updateContent];
}

- (void)initializeScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.alwaysBounceVertical = YES;;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [scrollView addGestureRecognizer:tap];
    
    gig_autoresize(scrollView, NO);
    gig_layout_fit(scrollView);
    
    self.scrollView = scrollView;
}

- (void)initializeContentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.scrollView addSubview:contentView];
    
    gig_autoresize(contentView, NO);
    gig_layout_fit(contentView);
    gig_constrain_width(contentView, self.view.width);
    
    self.contentView = contentView;
}

#pragma mark - ACTIONS

- (void)tapBackground:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
}

#pragma mark - NOTIFICATIONS

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    }];
}

#pragma mark - ACCESSORS

- (NSDictionary *)fieldValues
{
    return [self.formValues copy];
}

- (void)setFieldValues:(NSDictionary *)fieldValues
{
    self.formValues = [fieldValues mutableCopy];
    
    [fieldValues enumerateKeysAndObjectsUsingBlock:^(NSString *fieldTag, id value, __unused BOOL *stop) {
        GIGFormField *field = [self fieldWithTag:fieldTag];
        field.fieldValue = value;
    }];
}

#pragma mark - PUBLIC

- (BOOL)becomeFirstResponder
{
    return [self.formFields.firstObject becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.contentView endEditing:YES];
}

- (void)showFields:(NSArray *)fields
{
    self.formValues = [[NSMutableDictionary alloc] initWithCapacity:fields.count];
    self.formFields = fields;
    
    [self updateContent];
}

- (BOOL)validateFields
{
    BOOL valid = YES;
    
    for (GIGFormField *field in self.formFields)
    {
        valid = ([field validate] && valid);
    }
    
    return valid;
}

- (void)formFieldDidStart:(GIGFormField *)formField
{
    [self.scrollView scrollRectToVisible:formField.frame animated:YES];
}

- (void)formFieldDidFinish:(GIGFormField *)formField
{
    GIGFormField *nextField = [self nextFieldTo:formField];
    
    if ([nextField canBecomeFirstResponder])
    {
        [nextField becomeFirstResponder];
    }
    else
    {
        [formField resignFirstResponder];
    }
}

- (void)formField:(GIGFormField *)formField didChangeValue:(id)value
{
    self.formValues[formField.fieldTag] = value;
}

#pragma mark - PRIVATE (Fields)

- (GIGFormField *)fieldWithTag:(NSString *)tag
{
    for (GIGFormField *field in self.formFields)
    {
        if ([field.fieldTag isEqualToString:tag])
        {
            return field;
        }
    }
    
    return nil;
}

- (GIGFormField *)nextFieldTo:(GIGFormField *)formField
{
    NSInteger nextIndex = [self.formFields indexOfObject:formField] + 1;
    if (nextIndex < self.formFields.count)
    {
        return self.formFields[nextIndex];
    }
    
    return nil;
}

#pragma mark - PRIVATE (Content Views)

- (UIView *)lastView
{
    if (self.footerView != nil) return self.footerView;
    if (self.formFields.count > 0) return self.formFields.lastObject;
    
    return self.headerView;
}

- (UIView *)lastViewBeforeFooter
{
    if (self.formFields.count > 0) return self.formFields.lastObject;
    
    return self.headerView;
}

- (void)updateContent
{
    [self.contentView removeSubviews];
    
    [self addHeaderView];
    [self addFields];
    [self addFooterView];
    
    UIView *lastView = [self lastView];
    if (lastView != nil)
    {
        gig_layout_bottom(lastView, 0);
    }
}

- (void)addHeaderView
{
    if (self.headerView != nil)
    {
        [self.contentView addSubview:self.headerView];
        
        gig_autoresize(self.headerView, NO);
        gig_layout_fit_horizontal(self.headerView);
        gig_layout_top(self.headerView, 0);
    }
}

- (void)addFooterView
{
    if (self.footerView != nil)
    {
        UIView *lastView = nil;
        if (self.addSeparators)
        {
            lastView = [self addSeparatorBelowView:[self lastViewBeforeFooter]];
        }
        else
        {
            lastView = [self lastViewBeforeFooter];
        }
        
        [self.contentView addSubview:self.footerView];
        
        gig_autoresize(self.footerView, NO);
        gig_layout_fit_horizontal(self.footerView);
        gig_layout_below(self.footerView, lastView, 0);
    }
}

- (void)addFields
{
    UIView *lastView = self.headerView;
    
    for (GIGFormField *field in self.formFields)
    {
        field.formController = self;
        [self.contentView addSubview:field];
        
        gig_autoresize(field, NO);
        gig_layout_fit_horizontal(field);
        
        if (lastView != nil)
        {
            gig_layout_below(field, lastView, self.fieldsMargin);
        }
        else
        {
            gig_layout_top(field, 0);
        }
        
        if (self.addSeparators)
        {
            lastView = (field == self.formFields.lastObject) ? field : [self addSeparatorBelowView:field];
        }
        else
        {
            lastView = field;
        }
    }
}

- (UIView *)addSeparatorBelowView:(UIView *)view
{
    UIView *separatorView = [[UIView alloc] initWithFrame:self.view.frame];
    separatorView.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:separatorView];
    
    gig_autoresize(separatorView, NO);
    gig_layout_below(separatorView, view, self.fieldsMargin);
    gig_layout_left(separatorView, 10);
    gig_layout_right(separatorView, 10);
    gig_constrain_height(separatorView, 2);
    
    return separatorView;
}

@end
