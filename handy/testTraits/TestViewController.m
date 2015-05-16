//
//  TestViewController.m
//  handy
//
//  Created by 方阳 on 15/5/6.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic,weak) IBOutlet UIButton* btn;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_btn addTarget:self action:@selector(downevent) forControlEvents:UIControlEventTouchDown];
    [_btn addTarget:self action:@selector(repeatevent) forControlEvents:UIControlEventTouchDownRepeat];
    [_btn addTarget:self action:@selector(draginsideevent) forControlEvents:UIControlEventTouchDragInside];
    [_btn addTarget:self action:@selector(dragoutsideevent) forControlEvents:UIControlEventTouchDragOutside];
    [_btn addTarget:self action:@selector(dragenterevent) forControlEvents:UIControlEventTouchDragEnter];
    [_btn addTarget:self action:@selector(dragexitevent) forControlEvents:UIControlEventTouchDragExit];
    [_btn addTarget:self action:@selector(upinsideevent) forControlEvents:UIControlEventTouchUpInside];
    [_btn addTarget:self action:@selector(upoutsideevent) forControlEvents:UIControlEventTouchUpOutside];
    [_btn addTarget:self action:@selector(cancelevent) forControlEvents:UIControlEventTouchCancel];
    [_btn addTarget:self action:@selector(valuechangeevent) forControlEvents:UIControlEventValueChanged];
    //[_btn addTarget:self action:@selector(allevent) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma marks touchevent
- (void)downevent
{
    NSLog(@"touch down");
}
- (void)repeatevent
{
    NSLog(@"touch down repeat");
}
- (void)dragenterevent
{
    NSLog(@"touch drag enter");
}
- (void)draginsideevent
{
    NSLog(@"touch drag inside");
}
- (void)dragoutsideevent
{
    NSLog(@"touch drag outside");
}
- (void)dragexitevent
{
    NSLog(@"touch drag exit");
}
- (void)upinsideevent
{
    NSLog(@"touch up inside");
}
- (void)upoutsideevent
{
    NSLog(@"touch up outside");
}
- (void)cancelevent
{
    NSLog(@"touch cancel");
}
- (void)valuechangeevent
{
    NSLog(@"touch value change");
}
- (void)allevent
{
    NSLog(@"touch all");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
