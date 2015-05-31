//
//  AlbumContentsCollectionViewController.h
//  handy
//
//  Created by 方阳 on 15/4/23.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumContentsCollectionViewController : UICollectionViewController

@property (nonatomic,strong) NSMutableArray* assets;
@property (nonatomic,strong) ALAssetsGroup* assetsGroup;

@end
