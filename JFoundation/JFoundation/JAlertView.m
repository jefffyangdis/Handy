//
//  JAlertView.m
//  JFoundation
//
//  Created by 方阳 on 15/12/8.
//  Copyright © 2015年 dw_fangyang. All rights reserved.
//

#import "JFoundation.h"

@interface JAlertView()<UIAlertViewDelegate>
{
    UIAlertView*            viewSysAlert;
    UIAlertController*      contrlSysAlert;
    JAlertView*             alertViewSelfForRetain;
    BOOL                    bIsAlertView;
}

@property (nonatomic,strong) NSMutableArray* arrButtonBlock;

@end

@implementation JAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super init];
    if ( self ) {
        //如果是ios7及以下系统则使用UIAlertView,ios8及以上使用UIAlertController
        if ( [[JRuntime systemVersion] floatValue] < 8.0 ) {
            viewSysAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            bIsAlertView = YES;
        }
        else
        {
            contrlSysAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            bIsAlertView = NO;
        }
        self.arrButtonBlock = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark public api
- (NSUInteger)addButtonWithTitle:(NSString *)title actionBlock:(dispatch_block_t)actionblock
{
    if ( bIsAlertView ) {
        NSUInteger idx = [viewSysAlert addButtonWithTitle:title];
        self.arrButtonBlock[idx] = actionblock;
        return idx;
    }
    else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ( actionblock ) {
                actionblock();
            }
        }];
        [contrlSysAlert addAction:action];
        NSUInteger count = [contrlSysAlert.actions count];
        return count?count-1:0;
    }
}

- (void)show
{
    if ( bIsAlertView ) {
        [viewSysAlert show];
        alertViewSelfForRetain = self;
    }
    else
    {
        [[JFoundation currentViewController] presentViewController:contrlSysAlert animated:YES completion:nil];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    dispatch_block_t btnAction = nil;
    if( buttonIndex >=0 && buttonIndex < [self.arrButtonBlock count] )
    {
        btnAction = self.arrButtonBlock[buttonIndex];
    }
    CHECKVALID(btnAction);
    btnAction();
}
@end
