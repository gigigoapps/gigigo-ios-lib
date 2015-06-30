//
//  ViewController.m
//  GiGLibraryApp
//
//  Created by Alejandro Jiménez Agudo on 28/4/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "ViewController.h"

#ifdef GIG_STATIC_LIBRARY
    #import <GIGStaticLibrary/GIGStaticLibrary.h>
#else
    @import GIGLibrary;
#endif


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://www.gle.es"];
	request.logLevel = GIGLogLevelVerbose;
    request.completion = ^(GIGURLResponse *response) {
		NSLog(@"REQUEST DONE");
	};
    
    [request send];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [[GIGURLManager sharedManager] showConfig];
    }
}

@end
