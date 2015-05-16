//
//  JStoryboardViewControllerFactory.h
//  handy
//
//  Created by 方阳 on 15/5/6.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JStoryboardViewControllerFactory : NSObject

@property (nonatomic,strong,readonly) UIStoryboard* storyboard;

- (instancetype)initWithStoryboardName:(NSString*)storyboardname;

@end
