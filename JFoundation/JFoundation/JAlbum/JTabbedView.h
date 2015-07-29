//
//  JTabbedView.h
//  handy
//
//  Created by 方阳 on 15/5/7.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTabbedView;

@protocol JTabbedViewDelegate <NSObject>

@optional
- (UIView*)JTabbedView:(JTabbedView*)tabbedView TabIndex:(NSUInteger)index;

@end

@interface JTabbedView : UIView

@end
