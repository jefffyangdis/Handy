//
//  JStoryboardViewControllerFactory.m
//  handy
//
//  Created by 方阳 on 15/5/6.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JStoryboardViewControllerFactory.h"

@implementation JStoryboardViewControllerFactory

- (instancetype)initWithStoryboardName:(NSString*)storyboardname
{
    self = [super init];
    if ( self ) {
        _storyboard = [UIStoryboard storyboardWithName:storyboardname bundle:[NSBundle mainBundle]];
        NSParameterAssert(_storyboard);
    }
    return self;
}

@end
