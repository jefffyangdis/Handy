//
//  JAlbumCollectionViewLayout.m
//  handy
//
//  Created by 方阳 on 15/5/24.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JAlbumCollectionViewLayout.h"

@implementation JAlbumCollectionViewLayout

- (void)prepareLayout
{
    NSInteger currentOffsetIndex = 0;
    if ( [self.layoutDelegate respondsToSelector:@selector(iCurrentIndex)] ) {
        currentOffsetIndex = [self.layoutDelegate iCurrentIndex];
    }
    CGFloat widthPerItem = [[UIScreen mainScreen] bounds].size.width;
    [self.collectionView setContentOffset:CGPointMake(currentOffsetIndex* (widthPerItem+self.minimumInteritemSpacing),0) ];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width + self.minimumInteritemSpacing;
    CGFloat offsetx = proposedContentOffset.x;
    NSInteger offsetIndex = round(offsetx / width);
    if( velocity.x < 0 )
    {
        offsetIndex = floor(offsetx/width);
    }
    else if (velocity.x > 0 )
    {
        offsetIndex = ceil(offsetx/width);
    }
    if ( [self.layoutDelegate respondsToSelector:@selector(setICurrentIndex:)]) {
        [self.layoutDelegate setICurrentIndex:offsetIndex];
    }
    return CGPointMake( offsetIndex* width, proposedContentOffset.y);
}

@end
