//
//  GIGAlert.h
//  giglibrary
//
//  Created by Sergio Baró on 07/05/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GIGAlertActionBlock)(void);
typedef void(^GIGAlertAcceptBlock)(BOOL accepted);

__attribute((deprecated(("Use Alert class instead"))))
@interface GIGAlert : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *acceptButtonTitle;
@property (strong, nonatomic) NSString *cancelButtonTitle;

+ (instancetype)defaultAlert;

- (void)alert:(NSString *)message;
- (void)alert:(NSString *)message usingBlock:(GIGAlertActionBlock)completion;
- (void)prompt:(NSString *)message usingBlock:(GIGAlertAcceptBlock)completion;

@end
