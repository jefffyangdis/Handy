//
//  JAlbumView.h
//  handy
//
//  Created by 方阳 on 15/5/17.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JAlbumView : UIView

@property (nonatomic,assign) BOOL bIsRotateDisabled;
@property (nonatomic,strong) NSMutableArray* assets;
@property (nonatomic,assign) NSInteger iCurrentOffsetIndex;

- (void)reloadAlbum;
- (void)sizeWillChange;

@end
