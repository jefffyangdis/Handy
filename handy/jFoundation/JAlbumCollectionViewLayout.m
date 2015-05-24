//
//  JAlbumCollectionViewLayout.m
//  handy
//
//  Created by 方阳 on 15/5/24.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JAlbumCollectionViewLayout.h"

@implementation JAlbumCollectionViewLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width + self.minimumInteritemSpacing;
    CGFloat offsetx = proposedContentOffset.x;
    return CGPointMake( round(offsetx / width)* width, proposedContentOffset.y);
}

@end
