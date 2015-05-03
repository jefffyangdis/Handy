//
//  PageViewControllerData.m
//  Pods
//
//  Created by 方阳 on 15/4/27.
//
//

#import "PageViewControllerData.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PageViewControllerData

+ (PageViewControllerData*)sharedInstance
{
    static dispatch_once_t onceToken;
    static PageViewControllerData* sSharedInstance;
    
    dispatch_once(&onceToken,^{
        sSharedInstance = [[PageViewControllerData alloc] init];
    });
    
    return sSharedInstance;
}

- (NSUInteger)photoCount
{
    return [self.photosAssets count];
}

- (UIImage*)photoAtIndex:(NSUInteger)index
{
    ALAsset * photoAsset = self.photosAssets[index];
    ALAssetRepresentation* assetsRepresentation = [photoAsset defaultRepresentation];
    UIImage* fullscreenImage = [UIImage imageWithCGImage:[assetsRepresentation fullScreenImage]
                                                   scale:[assetsRepresentation scale]
                                             orientation:UIImageOrientationUp];
    return fullscreenImage;
}

@end
