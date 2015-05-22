//
//  AlbumContentsCollectionViewController.m
//  handy
//
//  Created by 方阳 on 15/4/23.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "AlbumContentsCollectionViewController.h"
#import "PageViewControllerData.h"
#import "MyPageViewController.h"
#import "JAlbumView.h"

@interface AlbumContentsCollectionViewController()

@property (nonatomic,strong) JAlbumView* viewAlbumPopout;

@end

@implementation AlbumContentsCollectionViewController

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if ( !self.assets ) {
        self.assets = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset* result,NSUInteger index,BOOL *stop)
    {
        if ( result ) {
            [self.assets addObject:result];
        }
    };
    ALAssetsFilter* onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownRecognized)];
    [self.view addGestureRecognizer:swipeRecognizer];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
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
#pragma marks swipe action
- (void)swipeDownRecognized
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

#define kImageviewTag 1111 
//image view inside the collection view cell prototype is tagged with kImageviewTag
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photoCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell, load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage* thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    //apply the image to the cell
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:kImageviewTag];
    imageView.image = thumbnail;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !_viewAlbumPopout ) {
        _viewAlbumPopout = [[[NSBundle mainBundle] loadNibNamed:@"JAlbumView" owner:self options:nil ] lastObject];
    }
    _viewAlbumPopout.frame = [UIScreen mainScreen].bounds;
    _viewAlbumPopout.assets = _assets;
    [self.navigationController.view addSubview:_viewAlbumPopout];
    [_viewAlbumPopout reloadAlbum];
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAlbumPopoutDoubleTapped)];
    [_viewAlbumPopout addGestureRecognizer:recognizer];
//    UIView* view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.navigationController.view addSubview:view];
//    view.backgroundColor = [UIColor blackColor];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ( [identifier isEqualToString:@"showPhoto"] ) {
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showPhoto"] ) {
        [PageViewControllerData sharedInstance].photosAssets = self.assets;
        
        MyPageViewController* vcPage = [segue destinationViewController];
        NSIndexPath* path = [self.collectionView indexPathsForSelectedItems][0];
        vcPage.iIndexStarting = path.row;
    }
}

#pragma mark private
- (void)viewAlbumPopoutDoubleTapped
{
    [_viewAlbumPopout removeFromSuperview];
}

@end
