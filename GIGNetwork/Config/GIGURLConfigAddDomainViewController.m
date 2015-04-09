//
//  GIGURLConfigAddDomainViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLConfigAddDomainViewController.h"

#import "GIGURLManager.h"


@interface GIGURLConfigAddDomainViewController ()
<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *urlField;

@property (strong, nonatomic) GIGURLManager *manager;

@end


@implementation GIGURLConfigAddDomainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Domain";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nameField = [self textFieldWithTopMargin:10 placeholder:@"Domain name"];
    self.nameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.nameField];
    
    self.urlField = [self textFieldWithTopMargin:50 placeholder:@""];
    self.urlField.text = @"http://";
    self.urlField.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:self.urlField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(tapSaveButton)];
    self.navigationItem.rightBarButtonItem.enabled = [self shouldEnableSaveButton];
    
    self.manager = [GIGURLManager sharedManager];
}

#pragma mark - ACTIONS

- (void)tapSaveButton
{
    NSString *name = self.nameField.text;
    NSString *url = self.urlField.text;
    
    GIGURLDomain *domain = [[GIGURLDomain alloc] initWithName:name url:url];
    [self.manager addDomain:domain];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PRIVATE

- (BOOL)shouldEnableSaveButton
{
    return (self.nameField.text.length > 0 && self.urlField.text > 0);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField)
    {
        [self.urlField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.navigationItem.rightBarButtonItem.enabled = [self shouldEnableSaveButton];
    
    return YES;
}

#pragma mark - HELPERS

- (UITextField *)textFieldWithTopMargin:(CGFloat)topMargin placeholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64 + topMargin, self.view.frame.size.width - 20, 30)];
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleLine;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enablesReturnKeyAutomatically = YES;
    textField.delegate = self;
    
    return textField;
}

@end
