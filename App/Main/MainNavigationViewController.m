//
//  MainNavigationViewController.m
//  GIGLibraryApp
//
//  Created by Jerilyn Goncalves on 22/10/2018.
//  Copyright © 2018 Gigigo SL. All rights reserved.
//

#import "MainNavigationViewController.h"

@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController != nil) {
        return self.topViewController.preferredStatusBarStyle;
    } else {
        return UIStatusBarStyleDefault;
    }
}
@end
