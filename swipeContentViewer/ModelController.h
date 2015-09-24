//
//  ModelController.h
//  swipeContentViewer
//
//  Created by Randy Yang on 8/24/15.
//  Copyright © 2015 Randy Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class DataViewController;
@class RootViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>{
    @private
        RootViewController *rootViewController;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@property ( strong, nonatomic) NSMutableArray *pageData;
@property ( strong, nonatomic) NSMutableArray *textMessages;
@property (strong, nonatomic) NSMutableArray *imageArrays;
@property ( strong, nonatomic) NSMutableArray *dataViewControllers;
-(void)addNewPage:(UIImage*)newImage;
-(NSUInteger)addImage:(UIImage *)newImage viewController:(DataViewController *)viewController;
-(void) updateTextInfo:(NSString *) titleText withBodyText: (NSString *) bodyText withViewController:(DataViewController *)viewController;
-(void)deleteImage: (NSUInteger) imageIndex withDataViewController:(DataViewController *)viewController;
-(void)deletePage: (DataViewController *)viewController;

@property (retain) RootViewController *rootViewController;

@end

