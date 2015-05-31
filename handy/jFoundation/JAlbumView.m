//
//  JAlbumView.m
//  handy
//
//  Created by 方阳 on 15/5/17.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JAlbumView.h"
#import "JAlbumCollectionViewCell.h"
#import "JAlbumCollectionViewLayout.h"
#import "JImageScrollView.h"
#import <ReactiveViewModel/RVMViewModel.h>

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
    
    _viewImageCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_viewImageCollection registerClass:[JAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"JAlbumCell"];
    UINib* nib = [UINib nibWithNibName:@"JAlbumCollectionViewCell" bundle:nil];
    [_viewImageCollection registerNib:nib forCellWithReuseIdentifier:@"JAlbumCell"];
    JAlbumCollectionViewLayout* layout = [[JAlbumCollectionViewLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _viewImageCollection.collectionViewLayout = layout;
    _viewImageCollection.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //    [_viewImageCollection addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged
{
}

- (void)sizeWillChange
{
    [_viewImageCollection.collectionViewLayout invalidateLayout];
    [_viewImageCollection reloadData];
}

#pragma mark - set method
- (void)setIStartIndex:(NSUInteger)iStartIndex
{
    _iStartIndex = iStartIndex;
//    CGPoint p = _viewImageCollection.contentOffset;
//    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)_viewImageCollection.collectionViewLayout;
//    p.x = _iStartIndex* ([ self collectionView:_viewImageCollection layout:layout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:_iStartIndex inSection:0]].width + layout.minimumInteritemSpacing) ;
//        [_viewImageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_iStartIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    [_viewImageCollection setContentOffset:p];
}

#pragma mark - collectionviewdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_assets count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAlbumCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JAlbumCell" forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    CGFloat f = representation.scale;
    UIImage* img = [UIImage imageWithCGImage:[representation fullScreenImage]
                                             scale:f
                                       orientation:UIImageOrientationUp];
//    cell.viewImg.image = img;
    [cell.scrollViewImg removeFromSuperview];
    CGSize size = [self collectionView:collectionView layout:nil sizeForItemAtIndexPath:indexPath];
    cell.scrollViewImg = [[JImageScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [cell.scrollViewImg setImage:img];
    [cell.contentView addSubview:cell.scrollViewImg];
    return cell;
}

#pragma mark - uicollectionviewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = _viewImageCollection.bounds.size.height - _viewImageCollection.contentInset.top - _viewImageCollection.contentInset.bottom;
    
    return CGSizeMake(width, height);
}

#pragma mark - albumview interface
- (void)reloadAlbum
{
    [_viewImageCollection reloadData];
}

@end



