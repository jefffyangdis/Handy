//
//  HandyCameraPreviewView.h
//  handy
//
//  Created by 方阳 on 15/9/30.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface HandyCameraPreviewView : UIView

@property (nonatomic,strong) AVCaptureSession* session;

@end
