//
//  GLALoginFacebookViewController.m
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 4/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GLALoginFacebookViewController.h"

#if GIG_STATIC_LIBRARY

@interface GLALoginFacebookViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation GLALoginFacebookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelInfo.textAlignment = NSTextAlignmentCenter;
    self.labelInfo.text = @"Social module not available on GIGStaticLibrary";
    self.scrollView.scrollEnabled = NO;
    self.loginButton.hidden = YES;
}

- (IBAction)onButtonLoginTap:(id)sender
{
    // NOTHING
}

@end

#else // GIG_DYNAMIC_LIBRARY

#import "GIGSocial.h"


@interface GLALoginFacebookViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) GIGSocialLogin *socialLogin;

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
	self.socialLogin.extraPermissions = @[@"email", @"user_birthday"];
	self.socialLogin.extraFields = @[@"birthday", @"email"];
	[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
	{
		NSMutableString *info = [[NSMutableString alloc] init];
		NSString *successString = result.success ? @"YES" : @"NO";
		NSString *loginErrorString = @"";
		
		switch (result.loginError)
		{
			case GIGSocialLoginErrorNone:
				loginErrorString = @"NO ERROR";
				break;
				
			case GIGSocialLoginErrorUser:
				loginErrorString = @"USER ERROR";
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
		[info appendFormat:@"ERROR TYPE: %@\n\n", loginErrorString];
		[info appendFormat:@"ERROR: %@\n\n", result.error];
		[info appendFormat:@"USER ID: %@\n\n", result.userID];
		[info appendFormat:@"USER DATA:\n%@\n\n", result.user];
		[info appendFormat:@"ACCESS TOKEN: %@\n\n", result.accessToken];
		
		self.labelInfo.text = info;
	}];
}

@end

#endif // GIG_STATIC_LIBRARY