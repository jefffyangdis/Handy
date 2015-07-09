//
//  JRuntime+System.m
//  handy
//
//  Created by 方阳 on 15/5/16.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JRuntime.h"
#import <UIKit/UIKit.h>

@implementation JRuntime (System)

+ (NSString*)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}
@end
