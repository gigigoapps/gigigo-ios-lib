//
//  GIGSocialCore.m
//  GiGLibrary
//
//  Created by Alejandro Jiménez Agudo on 4/8/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGSocialCore.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation GIGSocialCore

+ (void)applicationDidBecomeActive:(UIApplication *)application
{
	[FBSDKAppEvents activateApp];
}


+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}


+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
