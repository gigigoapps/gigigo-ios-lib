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
    
    self.nameField = [self textFieldWithTopMargin:10 placeholder:@"name" text:nil returnKey:UIReturnKeyNext];
    [self.view addSubview:self.nameField];
    
    self.urlField = [self textFieldWithTopMargin:50 placeholder:@"url" text:@"http://" returnKey:UIReturnKeyGo];
    self.urlField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:self.urlField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(tapSaveButton)];
    self.navigationItem.rightBarButtonItem.enabled = [self textAreValid];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tapCancelButton)];
    
    self.manager = [GIGURLManager sharedManager];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nameField becomeFirstResponder];
}

#pragma mark - ACTIONS

- (void)tapSaveButton
{
    [self saveDomain];
}

- (void)tapCancelButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PRIVATE

- (BOOL)textAreValid
{
    return (self.nameField.text.length > 0 && self.urlField.text > 0);
}

- (void)saveDomain
{
    NSString *name = self.nameField.text;
    NSString *url = self.urlField.text;
    
    GIGURLDomain *domain = [[GIGURLDomain alloc] initWithName:name url:url];
    [self.manager addDomain:domain];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        
        if ([self textAreValid])
        {
            [self saveDomain];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.navigationItem.rightBarButtonItem.enabled = [self textAreValid];
    
    return YES;
}

#pragma mark - HELPERS

- (UITextField *)textFieldWithTopMargin:(CGFloat)topMargin placeholder:(NSString *)placeholder text:(NSString *)text returnKey:(UIReturnKeyType)returnKey
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64 + topMargin, self.view.frame.size.width - 20, 30)];
    textField.borderStyle = UITextBorderStyleLine;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enablesReturnKeyAutomatically = YES;
    textField.delegate = self;
    
    textField.placeholder = placeholder;
    textField.text = text;
    textField.returnKeyType = returnKey;
    
    return textField;
}

@end
