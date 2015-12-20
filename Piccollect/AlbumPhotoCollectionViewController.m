//
//  AlbumPhotoCollectionViewController.m
//  Piccollect
//
//  Created by Josh on 2015/11/29.
//  Copyright © 2015年 Mu Mu Corp. All rights reserved.
//

#import "AlbumPhotoCollectionViewController.h"
#import "AlbumListService.h"

// RMGalleryViewController is designed to be subclased. In this example the subclass acts as the gallery data source,  takes care of displaying a dynamic title in the navigation bar and provides and action bar button system item.
@interface AlbumPhotoCollectionViewController()<RMGalleryViewDataSource, RMGalleryViewDelegate>

@end

@implementation AlbumPhotoCollectionViewController

@synthesize mAlbum, mAlbumListService, mPage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the gallery data source and delegate. Only the data source is required.
    self.galleryView.galleryDataSource = self;
    self.galleryView.galleryDelegate = self;
    
    // Configure the toolbar to show an action bar button item. RMGalleryViewController does not provide any bar buttons but is designed to support a navigation bar and a toolbar.
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonAction:)];
    self.toolbarItems = @[barButton];
    
    // Set the view controller title. Note that the gallery index does not necessarilly have to be zero at this point.
    [self setTitleForIndex:self.galleryIndex];
}

#pragma mark - RMGalleryViewDataSource

- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *))completionBlock
{
    // Typically images will be loaded asynchonously. To simulate this we resize the image in background.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *subimagePath = [mAlbum.mAlbumPhotos objectAtIndex:(index)];
        NSString *imagePath = [mAlbumListService.mDocumentRootPath stringByAppendingPathComponent:subimagePath];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        //image = [image demo_imageByScalingByFactor:0.75];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
}

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)galleryView
{
    return [mAlbum.mAlbumPhotos count];
}

#pragma mark - RMGalleryViewDelegate

- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index
{
    [self setTitleForIndex:index];
}

#pragma mark - Toolbar

- (void)barButtonAction:(UIBarButtonItem*)barButtonItem
{
    RMGalleryView *galleryView = self.galleryView;
    const NSUInteger index = galleryView.galleryIndex;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:index];
    UIImage *image = galleryCell.image;
    if (!image) return;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Utils

- (void)setTitleForIndex:(NSUInteger)index
{
    const NSUInteger count = [self numberOfImagesInGalleryView:self.galleryView];
    self.title = [NSString stringWithFormat:@"%ld / %ld", (long)index + 1, (long)count];
}


@end
