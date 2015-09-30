//
//  GLALoginFacebookViewController.m
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 4/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GLALoginFacebookViewController.h"


@interface GLALoginFacebookViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end



@implementation GLALoginFacebookViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.labelInfo.numberOfLines = 0;
}

#pragma mark - ACTIONS

- (IBAction)onButtonLoginTap:(id)sender
{
    
}

@end
