//
//  MainControllerFactory.h
//  handy
//
//  Created by 方阳 on 15/9/30.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JStoryboardViewControllerFactory.h"

@interface MainControllerFactory : JStoryboardViewControllerFactory

- (UIViewController*)instantiateInitialController;

- (UIViewController*)instantiateHandyCameraController;

@end
