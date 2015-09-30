//
//  HandyCameraPreviewView.m
//  handy
//
//  Created by 方阳 on 15/9/30.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "HandyCameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation HandyCameraPreviewView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}
@end
