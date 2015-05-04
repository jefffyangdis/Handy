//
//  PhotoViewController.h
//  handy
//
//  Created by 方阳 on 15/4/28.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) NSArray *photos;  // array of ALAsset objects

@property NSUInteger pageIndex;

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex;

@end
