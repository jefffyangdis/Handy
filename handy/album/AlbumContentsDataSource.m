//
//  AlbumContentsDataSource.m
//  handy
//
//  Created by 方阳 on 15/5/30.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "AlbumContentsDataSource.h"

@interface AlbumContentsDataSource()

@property (nonatomic,strong) NSString* cellIdentifier;

@end

@implementation AlbumContentsDataSource

- (instancetype)initWithItems:(id)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(configureBlock)block
{
    self = [super init];
    if ( self ) {
        self.assets = items;
        self.cellIdentifier = cellIdentifier;
        self.cellConfigureBlock = block;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

//image view inside the collection view cell prototype is tagged with kImageviewTag
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photoCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell, load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    self.cellConfigureBlock(cell,asset);
    
    return cell;
}

@end
