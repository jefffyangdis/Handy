//
//  TestViewControllerFactory.m
//  handy
//
//  Created by 方阳 on 15/5/6.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "TestViewControllerFactory.h"

@implementation TestViewControllerFactory

+ (instancetype)sharedFactory
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithStoryboardName:@"test"];
    });
    return instance;
}

- (UIViewController*)instantiateTestRootViewController
{
    UIViewController* vcTestRoot = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
    return vcTestRoot;
}
@end
