//
//  JAlbumCollectionViewLayout.h
//  handy
//
//  Created by 方阳 on 15/5/24.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JAlbumCollectionViewLayoutDelegate <NSObject>

@optional
- (NSInteger)iCurrentIndex;
- (void)setICurrentIndex:(NSInteger)index;
@end

@interface JAlbumCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<JAlbumCollectionViewLayoutDelegate> layoutDelegate;

@end
