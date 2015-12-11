//
//  JFoundation.m
//  JFoundation
//
//  Created by 方阳 on 15/6/29.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JFoundation.h"

@implementation JFoundation

+(UIViewController*)currentViewController
{
    return nil;
}

@end

NSString *getLocalizedStringFromTableWithFallback(NSString *key, NSString *table, NSString *fallback, __unused NSString *comment)
{
    if (!key)
        return @"";
    
    static NSBundle *fallBackBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        fallBackBundle = [NSBundle bundleWithPath:path];
    });
    
    NSString *value = [[NSBundle mainBundle] localizedStringForKey:key value:nil table:table];
    
    if ( !value )
        value = [fallBackBundle localizedStringForKey:key value:fallback table:table];
    
    return value;
}
