//
//  CoreTextArcView.h
//  handy
//
//  Created by 方阳 on 15/12/17.
//  Copyright © 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreTextArcView : UIView

@property (nonatomic) UIFont *font;
@property (nonatomic) NSString *string;
@property (readonly, nonatomic) NSAttributedString *attributedString;
@property (nonatomic) CGFloat radius;
@property (nonatomic) BOOL showsGlyphBounds;
@property (nonatomic) BOOL showsLineMetrics;
@property (nonatomic) BOOL dimsSubstitutedGlyphs;

@end
