//
//  JImage.m
//  JFoundation
//
//  Created by 方阳 on 15/9/7.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JImage.h"

typedef NS_ENUM(NSUInteger, RGB) {
    RGB_R,
    RGB_G,
    RGB_B,
};

@implementation JImage

+ (void)rgbToHsv:(float [])rgb hsv:(float [])hsv
{
    NSUInteger maxComponent,minComponent;
    [JImage rgb:rgb maxComponent:&maxComponent minComponent:&minComponent];
}

#pragma mark utilitymethod
+ (void)rgb:(float [])rgb maxComponent:(NSUInteger*)max minComponent:(NSUInteger*)min
{
    if ( rgb[0] >= rgb[1] ) {
        if ( rgb[0] >= rgb[2] ) {
            *max = RGB_R;
            if ( rgb[1] >= rgb[2] ) {
                *min = RGB_B;
            }
            else
            {
                *min = RGB_G;
            }
        }
        else
        {
            *max = RGB_B;
            *min = RGB_G;
        }
    }
    else
    {
        if ( rgb[1] >= rgb[2] ) {
            *max = RGB_G;
        }
        else
        {
            *max = RGB_B;
        }
    }
}

@end
