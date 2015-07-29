//
//  UIViewController+Utils.m
//  handy
//
//  Created by 方阳 on 15/5/14.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (BOOL)isTopMostViewController
{
    if ( self.isViewLoaded && self.view.window ) {
        return YES;
    }
    return NO;
}

@end
