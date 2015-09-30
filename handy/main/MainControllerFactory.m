//
//  MainControllerFactory.m
//  handy
//
//  Created by 方阳 on 15/9/30.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "MainControllerFactory.h"

@implementation MainControllerFactory

- (UIViewController*)instantiateInitialController
{
    return [self.storyboard instantiateInitialViewController];
}

- (UIViewController*)instantiateHandyCameraController
{
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HandyCameraController"];
    return vc;
}

@end
