//
//  AlbumContentsDataSource.h
//  handy
//
//  Created by 方阳 on 15/5/30.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^configureBlock)(UICollectionViewCell*,ALAsset*);

@interface AlbumContentsDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray* assets;
@property (nonatomic,strong) ALAssetsGroup* assetsGroup;
@property (nonatomic,strong) configureBlock cellConfigureBlock;

- (instancetype)initWithItems:(id)items
               cellIdentifier:(NSString*)cellIdentifier
           configureCellBlock:(configureBlock)block;

@end
