//
//  ImageScrollView.h
//  handy
//
//  Created by 方阳 on 15/4/28.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageScrollView : UIScrollView

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic) NSUInteger index;

- (NSUInteger)imageCount;

@end
