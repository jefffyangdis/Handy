//
//  JAlbumControllerFactory.h
//  JFoundation
//
//  Created by 方阳 on 15/7/12.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JAlbumControllerFactory : NSObject

+ (instancetype)sharedFactory;

- (UIView*)instantiateJAlbumView;

@end
