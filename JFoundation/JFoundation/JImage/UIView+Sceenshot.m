//
//  UIView+Sceenshot.m
//  JFoundation
//
//  Created by 方阳 on 15/12/26.
//  Copyright © 2015年 jefffyang. All rights reserved.
//

#import "UIView+Sceenshot.h"

@implementation UIView (Sceenshot)

- (UIImage*)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
