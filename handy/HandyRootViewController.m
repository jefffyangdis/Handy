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
#import "AlbumViewControllerFactory.h"
#import "AvgLoadView.h"
#import "Network.h"

@interface HandyRootViewController ()

@property (nonatomic,strong) ALAssetsLibrary* assetsLibrary;
@property (nonatomic,strong) NSMutableArray* groups;
@property (nonatomic,strong) Network* network;

@end

#pragma mark
@implementation HandyRootViewController

#pragma mark viewlifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_network ok];
    
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
    
    self.navigationController.navigationBar.translucent = YES;
    glAttachShader(program, 0);
}

- (void)initUI
{
//    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = NSLocalizedStringFromTable(@"album_navbartitle", @"handy", @"album_navbartitle");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - status bar
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)enableAvgLoadView
{
    [AvgLoadView class];
    AvgLoadView* loadavgView = [[[NSBundle mainBundle] loadNibNamed:@"AvgLoadView"
                                                              owner:self
                                                            options:nil] lastObject];
    UIWindow* keywin = [[UIApplication sharedApplication] keyWindow];
    loadavgView.frame = CGRectMake(0, 280, 100, 50);
    
    [keywin addSubview:loadavgView];
    [loadavgView updateCpuLoad:0.2332];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumContentsCollectionViewController* vcAlbum = (AlbumContentsCollectionViewController*)[[AlbumViewControllerFactory sharedFactory] instantiateAlbumViewController];
    vcAlbum.assetsGroup = self.groups[indexPath.row];
    vcAlbum.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcAlbum animated:YES];
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

