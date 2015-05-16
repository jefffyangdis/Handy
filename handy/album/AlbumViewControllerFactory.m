//
//  AlbumViewControllerFactoryViewController.m
//  handy
//
//  Created by 方阳 on 15/5/6.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "AlbumViewControllerFactory.h"
#import "AlbumContentsCollectionViewController.h"

@implementation AlbumViewControllerFactory

+ (instancetype)sharedFactory
{
    static id instance;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        instance = [[self alloc] initWithStoryboardName:@"Main"];
    });
    return instance;
}

- (UIViewController*)instantiateAlbumViewController
{
    AlbumContentsCollectionViewController* vcAlbumContent = [self.storyboard instantiateViewControllerWithIdentifier:@"albumcontent"];
    return vcAlbumContent;
}

@end
