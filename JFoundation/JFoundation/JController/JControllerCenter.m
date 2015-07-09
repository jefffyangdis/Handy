//
//  JControllerCenter.m
//  JFoundation
//
//  Created by 方阳 on 15/7/2.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JControllerCenter.h"
#import "JFoundation.h"

@implementation JControllerCenter

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t dispatchone;
    dispatch_once(&dispatchone, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (UIViewController*)getCurrentRootViewController
{
    UIWindow* topwindow = [[[UIApplication sharedApplication] delegate] window];
    topwindow = nil;
    CHECKVALID(topwindow);
    NSArray* viewarray = [topwindow subviews];
    [viewarray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL* stop)
     {
         UIView* v = obj;
         if ( [NSStringFromClass([v class]) isEqualToString:@"UITransitionView" ]) {
             
         };
     }];
    return nil;
}

@end
