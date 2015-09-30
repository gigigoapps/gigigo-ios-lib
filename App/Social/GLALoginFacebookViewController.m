//
//  GLALoginFacebookViewController.m
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 4/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GLALoginFacebookViewController.h"

#import "GIGSocialLogin.h"


@interface GLALoginFacebookViewController ()

@property (strong, nonatomic) GIGSocialLogin *socialLogin;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end



@implementation GLALoginFacebookViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.labelInfo.numberOfLines = 0;
    
	self.socialLogin = [[GIGSocialLogin alloc] init];
}

#pragma mark - ACTIONS

- (IBAction)onButtonLoginTap:(id)sender
{
	[self.socialLogin loginFacebook:^(BOOL success, NSString *userID, NSString *accessToken, GIGSocialLoginError loginError, NSError *error)
	{
		NSMutableString *info = [[NSMutableString alloc] init];
		
		NSString *successString = success ? @"YES" : @"NO";
		NSString *loginErrorString = @"";
		
		switch (loginError)
		{
			case GIGSocialLoginErrorNone:
				loginErrorString = @"NO ERROR";
				break;
				
			case GIGSocialLoginErrorFacebookCancelled:
				loginErrorString = @"USER CANCELLED";
				break;
				
			case GIGSocialLoginErrorFacebook:
				loginErrorString = @"FACEBOOK ERROR";
				break;
				
			default:
				break;
		}
		
		[info appendFormat:@"SUCCESS: %@\n\n", successString];
		[info appendFormat:@"USER ID: %@\n\n", userID];
		[info appendFormat:@"ACCESS TOKEN: %@\n\n", accessToken];
		[info appendFormat:@"ERROR TYPE: %@\n\n", loginErrorString];
		[info appendFormat:@"ERROR: %@\n", error];
		
		self.labelInfo.text = info;
	}];
}

@end
