//
//  AlbumViewControllerFactoryViewController.h
//  handy
//
//  Created by 方阳 on 15/5/6.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JStoryboardViewControllerFactory.h"

@interface AlbumViewControllerFactory : JStoryboardViewControllerFactory

+ (instancetype)sharedFactory;

- (UIViewController*)instantiateAlbumViewController;

@end
