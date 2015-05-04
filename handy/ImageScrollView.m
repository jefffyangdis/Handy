//
//  ImageScrollView.m
//  handy
//
//  Created by 方阳 on 15/4/28.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "ImageScrollView.h"
#import "PageViewControllerData.h"

@interface ImageScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView* zoomView;//contains the full image;
@property CGSize imageSize;
@property CGPoint pointToCenterAfterResize;
@property CGFloat scaleToRestoreAfterResize;

@end

#pragma mark -
@implementation ImageScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
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

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    UIImage* image = [[PageViewControllerData sharedInstance] photoAtIndex:index];
    [self displayImage:image];
}

+ (NSUInteger)imageCount
{
    return [[PageViewControllerData sharedInstance] photoCount];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //center the zoom view as it becomes smaller than the size of screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
    
    //center horizontally
    if ( frameToCenter.size.width < boundsSize.width ) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) /2;
    }
    else{
        frameToCenter.origin.x = 0;
    }
    
    //center vertically
    if ( frameToCenter.size.height < boundsSize.height ) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height)/2;
    }
    else
    {
        frameToCenter.origin.y = 0;
    }
    
    _zoomView.frame = frameToCenter;
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !(CGSizeEqualToSize(frame.size, self.frame.size));
    
    if ( sizeChanging ) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if ( sizeChanging ) {
        [self recoverFromResizing];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}

#pragma mark - Configure scrollView to display new image
- (void)displayImage:(UIImage*)image
{
    //clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    //reset zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    //make a new UIImageView for the new image
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
    
    [self configureForImageSize:image.size];
}

- (void)configureForImageSize:(CGSize)size
{
    _imageSize = size;
    self.contentSize = size;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    
    //set min/max zoomscale
    CGFloat xScale = boundsSize.width/_imageSize.width;
    CGFloat yScale = boundsSize.height/_imageSize.height;
    
     // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    BOOL imagePortrait = _imageSize.height > _imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    //on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0/[[UIScreen mainScreen] scale];
    
    //don't let minScale exceed maxScale(If the image is smaller than the screen,we don't want to force it to be zoomed
    if ( minScale > maxScale ) {
        minScale = maxScale;
    }
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = maxScale;
}

#pragma marks - Methods called during rotation to preserve the zoomscale and the visible portion of the image
- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    
    return CGPointZero;
}
@end
