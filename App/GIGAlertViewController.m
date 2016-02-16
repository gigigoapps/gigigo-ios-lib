//
//  GIGAlertViewController.m
//  GIGLibrary
//
//  Created by Alfonso Miranda Castro on 1/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

#import "GIGAlertViewController.h"


@implementation GIGAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    GIGAlertController *aTest = [GIGAlertController sharedInstance];
//    aTest.title = @"Título";
//    [aTest alert:@"nanana nanana" usingBlock:^(BOOL success) {
//        if (success)
//        {
//            NSLog(@"____________YES");
//        }
//        else
//        {
//            NSLog(@"____________NO");
//        }
//
//    }];
    
    
    //GIGMainAlert *alert = [[GIGMainAlert alloc] initWithTitle:@"Titulo" message:@"Este es el mensaje"];
    //Alert *alert = [[Alert alloc] initWithTitle:@"Main Alert" message:@"Mensaje Main"];
    ActionSheet *alert = [[ActionSheet alloc] initWithTitle:@"Action Sheet" message:@"Este es un actionSheet"];

    [alert addDefaultButton:@"DEFAULT" usingAction:^(NSString * _Nonnull action) {
        NSLog(@"_________Default!!!");
    }];
    [alert addCancelButton:@"CANCEL" usingAction:^(NSString * _Nonnull action) {
        NSLog(@"_________Cancel!!!!");
    }];
    
    [alert addDestructiveButton:@"DELETE" usingAction:^(NSString * _Nonnull action) {
        NSLog(@"_________Delete!!!!");
    }];
    
    [alert show];
    
}

@end