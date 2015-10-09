//
//  JFoundation.h
//  JFoundation
//
//  Created by 方阳 on 15/6/29.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRunTime/JRunTime.h"
#import "JStoryboard/JStoryboardViewControllerFactory.h"

#define CHECKVALID(a) do{ if(!(a)) NSLog(@"("#a@") missing");}while(0)

#define localizedstr(t,c,n) [[NSBundle mainBundle] localizedStringForKey:@"a" value:nil table:@"b"]

@interface JFoundation : NSObject

@end
