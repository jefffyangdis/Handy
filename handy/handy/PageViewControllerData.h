//
//  PageViewControllerData.h
//  Pods
//
//  Created by 方阳 on 15/4/27.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PageViewControllerData : NSObject

+ (PageViewControllerData*)sharedInstance;

@property (nonatomic,strong) NSArray* photosAssets;//array of ALAsset objects

- (NSUInteger)photoCount;
- (UIImage*)photoAtIndex:(NSUInteger)index;

@end
