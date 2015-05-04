//
//  ViewController.m
//  handy
//
//  Created by 方阳 on 15/4/1.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "HandyMainViewController.h"
#import <UIKit/UIKit.h>

@interface HandyMainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak)  IBOutlet UIButton* btnOpenAlbum;
@property (nonatomic,weak)  IBOutlet UIButton* btnOpenPhotoLibary;
@property (nonatomic,weak)  IBOutlet UIButton* btnOpenCamera;
@property (nonatomic) IBOutlet UIView* cameraview;
@property (nonatomic) NSTimer* timerCamera;
@property (nonatomic) NSMutableArray* arrayImgs;
@property (nonatomic) UIImagePickerController* ctrlImgPicker;
@property (nonatomic) IBOutlet UIImageView* imgViewChosen;

@end

@implementation HandyMainViewController

- (instancetype)init
{
    self = [super init];
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _btnOpenAlbum.layer.cornerRadius = 5;
    _btnOpenAlbum.backgroundColor = [UIColor colorWithRed:0.13 green:0.73 blue:0.72 alpha:0.5];
    _btnOpenPhotoLibary.layer.cornerRadius = 5;
    _btnOpenPhotoLibary.backgroundColor = [UIColor colorWithRed:0.13 green:0.73 blue:0.72 alpha:0.5];
    _btnOpenCamera.layer.cornerRadius = 5;
    _btnOpenCamera.backgroundColor = [UIColor colorWithRed:0.13 green:0.73 blue:0.72 alpha:0.5];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma marks UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
//    [self.capturedImages addObject:image];
    _imgViewChosen.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTestBtnTapped:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _ctrlImgPicker = [[UIImagePickerController alloc] init];
        _ctrlImgPicker.delegate = self;
        //设置拍照后的图片可被编辑
        _ctrlImgPicker.allowsEditing = YES;
        _ctrlImgPicker.sourceType = sourceType;
        [self presentViewController:_ctrlImgPicker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (IBAction)onCameraBtnTapped:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _ctrlImgPicker = [[UIImagePickerController alloc] init];
        _ctrlImgPicker.delegate = self;
        //设置拍照后的图片可被编辑
        
        _ctrlImgPicker.allowsEditing = YES;
        _ctrlImgPicker.sourceType = sourceType;
        _ctrlImgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        [[NSBundle mainBundle] loadNibNamed:@"cameraview" owner:self options:nil];
        self.cameraview.frame = _ctrlImgPicker.cameraOverlayView.frame;
        _ctrlImgPicker.cameraOverlayView = self.cameraview;
        self.cameraview = nil;
        //picker.showsCameraControls = NO;
        [self addPhotoObservers ];
        [self presentViewController:_ctrlImgPicker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (IBAction)onPhotoLibaryBtnTapped:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (IBAction)onDismiss:(id)sender
{
    [self removePhotoObservers];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onStartTakingPhoto:(id)sender
{
    if ( _timerCamera.isValid ) {
        [_timerCamera invalidate];
    }
    NSDate* dateNow = [NSDate dateWithTimeIntervalSinceNow:0.0];
    _timerCamera = [[NSTimer alloc] initWithFireDate:dateNow interval:1.0 target:self selector:@selector(startIntervalTakePhoto:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timerCamera forMode:NSDefaultRunLoopMode];
}

- (void)startIntervalTakePhoto:(NSTimer*)timer
{
    if ( _ctrlImgPicker ) {
        [_ctrlImgPicker takePicture];
    }
    if ( [_timerCamera isValid] ) {
        [_timerCamera invalidate];
        _timerCamera = nil;
    }
}

- (void) addPhotoObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCameraOverlay) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCameraOverlay) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil ];
}

- (void) removePhotoObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addCameraOverlay {
    if (_ctrlImgPicker) {
        _ctrlImgPicker.cameraOverlayView = _cameraview;
    }
}

-(void)removeCameraOverlay {
    if (_ctrlImgPicker) {
        _ctrlImgPicker.cameraOverlayView = nil;
    }
}
@end
