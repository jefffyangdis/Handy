//
//  JAlbumControllerFactory.m
//  JFoundation
//
//  Created by 方阳 on 15/7/12.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JAlbumControllerFactory.h"
#import "JAlbumView.h"

@implementation JAlbumControllerFactory

+ (instancetype)sharedFactory
{
    static id instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[JAlbumControllerFactory alloc] init];
    });
    return instance;
}

- (UIView*)instantiateJAlbumView
{
//    NSString* mainbundlepath = [[NSBundle mainBundle] resourcePath];
//    NSString* frameworkbundlepath = [mainbundlepath stringByAppendingPathComponent:@"JFoundation.bundle"];
//    NSBundle* frameworkbundle = [NSBundle bundleForClass:[JAlbumView class]];
//    BOOL issamebundle = [frameworkbundle isEqual:[NSBundle mainBundle]];
    UIView* view =
    [[[NSBundle mainBundle] loadNibNamed:@"JAlbumView" owner:nil options:nil ] lastObject];
    return view;
}

@end
