//
//  JAlbumView.m
//  handy
//
//  Created by 方阳 on 15/5/17.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JAlbumView.h"
#import "JAlbumCollectionViewCell.h"

@interface JAlbumView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *viewNavigationBalls;
@property (weak, nonatomic) IBOutlet UICollectionView *viewImageCollection;

@end

@implementation JAlbumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_viewImageCollection registerClass:[JAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"JAlbumCell"];
    UINib* nib = [UINib nibWithNibName:@"JAlbumCollectionViewCell" bundle:nil];
    [_viewImageCollection registerNib:nib forCellWithReuseIdentifier:@"JAlbumCell"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAlbumCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JAlbumCell" forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef imgref = [asset aspectRatioThumbnail];
    cell.viewImg.image = [UIImage imageWithCGImage:imgref];
    return cell;
}

#pragma mark - uicollectionviewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size;
}

#pragma mark - albumview interface
- (void)reloadAlbum
{
    [_viewImageCollection reloadData];
}

@end
