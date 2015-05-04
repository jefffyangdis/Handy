//
//  MyPageViewController.m
//  Pods
//
//  Created by 方阳 on 15/4/27.
//
//

#import "MyPageViewController.h"
#import "PhotoViewController.h"

@implementation MyPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start by viewing the photo tapped by the user
    PhotoViewController *startingPage = [PhotoViewController photoViewControllerForPageIndex:self.iIndexStarting];
    if (startingPage != nil)
    {
        self.dataSource = self;
        
        [self setViewControllers:@[startingPage]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}


#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [PhotoViewController photoViewControllerForPageIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [PhotoViewController photoViewControllerForPageIndex:(index + 1)];
}

@end
