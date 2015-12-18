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
#import "JAlertView.h"

#define CHECKVALID(a) do{ if(!(a)) NSLog(@"("#a@") missing");}while(0)
#define switchIfPreIOS8(directivesPre8,directivePro8) do{if([[JRuntime systemVersion] floatValue] < 8.0 ) {directivesPre8;}else{directivePro8;}}while(0)

#define localizedstr(table,category,name) getLocalizedStringFromTableWithFallback((category@"_"name),(table),nil,nil)

NSString *getLocalizedStringFromTableWithFallback(NSString *key, NSString *table, NSString *fallback, __unused NSString *comment);

@interface JFoundation : NSObject

+ (UIViewController*)currentViewController;

@end
