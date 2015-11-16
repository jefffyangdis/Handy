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
#import "JImage.h"

@interface JAlbumView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JAlbumCollectionViewLayoutDelegate,UIActionSheetDelegate>

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
    layout.layoutDelegate = self;
    _viewImageCollection.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //    [_viewImageCollection addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UILongPressGestureRecognizer* menuRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:menuRecognizer];
}

- (void)longPress:(UILongPressGestureRecognizer*)sender
{
    if( sender.state == UIGestureRecognizerStateCancelled )
    {
        return;
    }
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructive" otherButtonTitles:@"other", nil];
    [sheet showInView:self];
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

#pragma mark - JAlbumCollectionViewLayoutDelegate
- (NSInteger)iCurrentIndex
{
    return _iCurrentOffsetIndex;
}

- (void)setICurrentIndex:(NSInteger)index
{
    _iCurrentOffsetIndex = index;
}

#pragma mark - albumview interface
- (void)reloadAlbum
{
    [_viewImageCollection reloadData];
}

#pragma mrak - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        JAlbumCollectionViewCell* cell = (JAlbumCollectionViewCell*)[_viewImageCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_iCurrentOffsetIndex inSection:0]];
        
//        ALAsset *asset = self.assets[_iCurrentOffsetIndex];
//        ALAssetRepresentation* representation = [asset defaultRepresentation];
//        CGFloat f = representation.scale;
        
        CIImage* image = [CIImage imageWithCGImage:[cell.scrollViewImg.image CGImage]];//[CIImage imageWithCGImage:[representation fullScreenImage]];
        EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        CIContext* cContext = [CIContext contextWithEAGLContext:context];
        CIFilter* filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey,image,kCIInputAngleKey, @1,nil];
        CIImage* output = [filter valueForKey:kCIOutputImageKey];
        
        CIFilter *bumpDistortion = [CIFilter filterWithName:@"CIBumpDistortion"];    // 1
        
        [bumpDistortion setDefaults];                                                // 2
        
        [bumpDistortion setValue: output forKey: kCIInputImageKey];
        
        [bumpDistortion setValue: [CIVector vectorWithX:200 Y:150]
         
                          forKey: kCIInputCenterKey];                              // 3
        
        [bumpDistortion setValue: @100.0f forKey: kCIInputRadiusKey];                // 4
        
        [bumpDistortion setValue: @3.0f forKey: kCIInputScaleKey];                  // 5
        
        output = [bumpDistortion valueForKey: kCIOutputImageKey];
        
        CGImageRef oImg = [cContext createCGImage:output fromRect:[output extent]];
        UIImage* rImg = [UIImage imageWithCGImage:oImg];
        if ( cell ) {
            [cell.scrollViewImg setImage:rImg];
        }
        float rgb[3],hsv[3];
        rgb[0]= 1;
        [JImage rgbToHsv:rgb hsv:hsv];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}
@end



