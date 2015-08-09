//
//  JImageScrollView.m
//  handy
//
//  Created by 方阳 on 15/5/27.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "JImageScrollView.h"

@interface JImageScrollView()

@property (nonatomic,strong) UIImageView* zoomView;
@property (nonatomic) CGSize sizeImg;
@property (nonatomic) CGPoint pointToCenterAfterResize;
@property (nonatomic) CGFloat fScaleToRestoreAfterResize;

@end

@implementation JImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize bounds = self.bounds.size;
    CGRect frametoCenter = self.zoomView.frame;
    
    if( frametoCenter.size.width < bounds.width )
    {
        frametoCenter.origin.x = (bounds.width - frametoCenter.size.width)/2.0;
    }
    else
    {
        frametoCenter.origin.x = 0;
    }
    
    if( frametoCenter.size.height < bounds.height )
    {
        frametoCenter.origin.y = (bounds.height - frametoCenter.size.height)/2.0;
    }
    else
    {
        frametoCenter.origin.y = 0;
    }
    
    self.zoomView.frame = frametoCenter;
}

#pragma mark - uiscrollviewdelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    CGAffineTransform transform = self.zoomView.transform;
//    NSLog(@"a:%@,b:%@,c:%@,d:%@,tx:%@,ty:%@",@(transform.a),@(transform.b),@(transform.c),@(transform.d),@(transform.tx),@(transform.ty));
//    NSLog(@"%@",@(scrollView.zoomScale));
    return self.zoomView;
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    if ( sizeChanging ) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if ( sizeChanging ) {
        [self recoverFromResizing];
    }
}

- (void)setImage:(UIImage *)img
{
    [_zoomView removeFromSuperview];
    self.zoomScale = 1.0;
    _zoomView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:_zoomView];
    [self configureForImgSize:img.size];
}

- (void)configureForImgSize:(CGSize)size
{
    self.sizeImg = size;
    self.contentSize = size;
    [self setMaxMinimumZoomScale];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinimumZoomScale
{
//    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize boundsSize = self.bounds.size;
//    boundsSize = CGSizeMake( boundsSize.width*scale, boundsSize.height*scale);
    
    CGFloat xScale = boundsSize.width / self.sizeImg.width;
    CGFloat yScale = boundsSize.height / self.sizeImg.height;
    
    BOOL imagePortrait = self.sizeImg.width > self.sizeImg.height;
    BOOL phonePortrait = boundsSize.width > boundsSize.height;
    
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN( xScale, yScale );
    
    CGFloat maxScale = 1.0 ;
    
    if ( minScale >= maxScale )
    {
        minScale = maxScale;
    }
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = maxScale;
}

#pragma marks - Methods called during rotation to preserve the zoomscale and the visible portion of the image
- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.zoomView];
    
    self.fScaleToRestoreAfterResize = self.zoomScale;
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if( self.fScaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON )
    {
        self.fScaleToRestoreAfterResize = 0;
    }
}

- (void)recoverFromResizing
{
    [self setMaxMinimumZoomScale];
    
    //重置新的scale
    self.zoomScale = MIN( self.maximumZoomScale, MAX(self.minimumZoomScale, self.fScaleToRestoreAfterResize));
    //将原中心点移动到屏幕方向变更之后的中心点
    CGPoint boundscenter = [self convertPoint:self.pointToCenterAfterResize fromView:self.zoomView];
    CGPoint offset = CGPointMake( (boundscenter.x - self.bounds.size.width/2), boundscenter.y - self.bounds.size.height/2);
    offset.x = MAX( [self minimumOffset].x, MIN(offset.x, [self maximumOffset].x));
    offset.y = MAX( [self minimumOffset].y, MIN(offset.y, [self maximumOffset].y));
    
    self.contentOffset = offset;
}

- (CGPoint)maximumOffset
{
    CGSize contentsize = self.contentSize;
    CGSize boundsize = self.bounds.size;
    return CGPointMake(contentsize.width - boundsize.width, contentsize.height - boundsize.height);
}

- (CGPoint)minimumOffset
{
    return CGPointZero;
}

@end
