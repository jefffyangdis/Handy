//
//  JAlbumViewCellCollectionViewCell.h
//  handy
//
//  Created by 方阳 on 15/5/21.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JImageScrollView.h"

@interface JAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) JImageScrollView* scrollViewImg;

@property (weak, nonatomic) IBOutlet UIImageView *viewImg;

@end
