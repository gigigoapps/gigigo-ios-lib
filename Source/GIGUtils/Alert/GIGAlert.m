//
//  GIGAlert.m
//  giglibrary
//
//  Created by Sergio Baró on 07/05/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "GIGAlert.h"


@interface GIGAlert ()
<UIAlertViewDelegate>

@property (copy, nonatomic) GIGAlertActionBlock actionBlock;
@property (copy, nonatomic) GIGAlertAcceptBlock acceptBlock;

@end


@implementation GIGAlert

+ (instancetype)defaultAlert
{
    static GIGAlert *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.acceptButtonTitle = NSLocalizedString(@"alert_accept", nil);
        self.cancelButtonTitle = NSLocalizedString(@"alert_cancel", nil);
        self.title = @"";
    }
    return self;
}

#pragma mark - Public

- (void)alert:(NSString *)message
{
    self.actionBlock = nil;
    self.acceptBlock = nil;
    
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.acceptButtonTitle otherButtonTitles:nil] show];
}

- (void)alert:(NSString *)message usingBlock:(GIGAlertActionBlock)completion
{
    self.actionBlock = completion;
    self.acceptBlock = nil;
    
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.acceptButtonTitle otherButtonTitles:nil] show];
}

- (void)prompt:(NSString *)message usingBlock:(GIGAlertAcceptBlock)completion
{
    self.actionBlock = nil;
    self.acceptBlock = completion;
    
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.cancelButtonTitle otherButtonTitles:self.acceptButtonTitle, nil] show];
}

#pragma mark - Private

- (void)showAlertWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.cancelButtonTitle otherButtonTitles:self.acceptButtonTitle, nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
    else if (self.acceptBlock)
    {
        self.acceptBlock(buttonIndex != alertView.cancelButtonIndex);
    }
}

@end
