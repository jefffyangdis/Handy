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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTestBtnTapped:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (IBAction)onCameraBtnTapped:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        UIView* view = self.cameraview;
        [[NSBundle mainBundle] loadNibNamed:@"cameraview" owner:self options:nil];
        view = self.cameraview;
        self.cameraview.frame = picker.cameraOverlayView.frame;
        view = picker.cameraOverlayView;
        picker.cameraOverlayView = self.cameraview;
        view = picker.cameraOverlayView;
        self.cameraview = nil;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
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
@end
