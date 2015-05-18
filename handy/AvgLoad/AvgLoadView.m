//
//  AvgLoadView.m
//  handy
//
//  Created by 方阳 on 15/5/5.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "AvgLoadView.h"
#import "JRuntime.h"

@interface AvgLoadView()

@property (nonatomic,assign) CGPoint pointTouchBegin;
@property (weak, nonatomic) IBOutlet UILabel *lblMemLoad;

@property (weak, nonatomic) IBOutlet UILabel *lblCpuLoad;

@end

@implementation AvgLoadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateCpuLoad:(CGFloat)cpuload
{
    _lblCpuLoad.text = [NSString stringWithFormat:@"%.1f%%",cpuload*100];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    _pointTouchBegin = [touch locationInView:nil];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:nil];
    CGRect rect = self.frame;
    rect.origin.x += point.x - _pointTouchBegin.x;
    rect.origin.y += point.y - _pointTouchBegin.y;
    self.frame = rect;
    _pointTouchBegin = point;
}

@end
