//
//  JAlertView.h
//  JFoundation
//
//  Created by 方阳 on 15/12/8.
//  Copyright © 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JAlertView : NSObject

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message;

- (NSUInteger)addButtonWithTitle:(NSString*)title actionBlock:(dispatch_block_t)action;

- (void)show;

@end
