//
//  HandyRootViewController.m
//  handy
//
//  Created by 方阳 on 15/4/21.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "HandyRootViewController.h"
#import "AssetsDataIsInaccessibleViewController.h"
#import "AlbumContentsCollectionViewController.h"
#import "AvgLoadView.h"

@interface HandyRootViewController ()

@property (nonatomic,strong) ALAssetsLibrary* assetsLibrary;
@property (nonatomic,strong) NSMutableArray* groups;
@property (nonatomic,weak) IBOutlet UIButton* btn;

@end

#pragma mark
@implementation HandyRootViewController

#pragma mark viewlifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ( self.assetsLibrary == nil )
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if ( self.groups == nil ) {
        _groups = [[NSMutableArray alloc] init];
    }
    else
    {
        [_groups removeAllObjects];
    }
    
    //dispose of possible failure of enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error){
        AssetsDataIsInaccessibleViewController* vcInaccessible = [self.storyboard instantiateViewControllerWithIdentifier:@"AssetsDataIsInaccessible"];
        NSString* strerror = nil;
        switch ( [error code] ) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                strerror = @"The User has declined access to it";
                break;
                
            default:
                strerror = @"reason unknown";
                break;
        }
        vcInaccessible.explanation = strerror;
        [self presentViewController:vcInaccessible animated:NO completion:nil];
    };
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        ALAssetsFilter* onlyPhotoFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotoFilter];
        if ( [group numberOfAssets] > 0 ) {
            [self.groups addObject:group];
        }
        else
        {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [self initUI];
    //enumerate only photos
    NSUInteger grouptypes = ALAssetsGroupAlbum|ALAssetsGroupEvent|ALAssetsGroupFaces|ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:grouptypes usingBlock:listGroupBlock failureBlock:failureBlock];
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
    [_btn addTarget:self action:@selector(allevent) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)initUI
{
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
}

- (void)enableAvgLoadView
{
    [AvgLoadView class];
    AvgLoadView* loadavgView = [[[NSBundle mainBundle] loadNibNamed:@"AvgLoadView"
                                                              owner:self
                                                            options:nil] lastObject];
    UIWindow* keywin = [[UIApplication sharedApplication] keyWindow];
    loadavgView.frame = CGRectMake(0, 80, 100, 50);
    
    [keywin addSubview:loadavgView];
    [loadavgView updateCpuLoad:0.2332];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark uitableviewdatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ALAssetsGroup* groupForCell = self.groups[indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage* posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.imageView.image = posterImage;
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",[groupForCell valueForProperty:ALAssetsGroupPropertyName],[@(groupForCell.numberOfAssets) stringValue] ];
    cell.detailTextLabel.text = [@(groupForCell.numberOfAssets) stringValue];
    return cell;
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        if ( self.groups.count > selectedIndexPath.row ) {
            AlbumContentsCollectionViewController* vcAlbum = [segue destinationViewController];
            vcAlbum.assetsGroup = self.groups[selectedIndexPath.row];
        }
    }
}
@end

