//
//  GLAMainViewController.m
//  GiGLibraryApp
//
//  Created by Alejandro Jiménez Agudo on 28/4/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GLAMainViewController.h"

#ifdef GIG_STATIC_LIBRARY
    #import <GIGStaticLibrary/GIGStaticLibrary.h>
#else
    @import GIGLibrary;
#endif


@interface GLAMainViewController ()

@end


@implementation GLAMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[GIGLogManager shared].appName = @"GIGUtils Awesome Test App";
	[GIGLogManager shared].logEnabled = YES;
	
    // request with self-signed https certificate and http basic authentication
    GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"https://dclientes.rm.gr.repsolypf.com/App/SO/REPSOLMASws/ContratosService.svc/SolicitarContratos/NIF/02626978X"];
	request.logLevel = GIGLogLevelVerbose;
    
    request.ignoreSSL = YES;
    [request setHTTPBasicUser:@"usuportal\\neiras2" password:@"America123"];
    
    request.completion = ^(GIGURLResponse *response) {
		GIGLog(@"REQUEST DONE");
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
