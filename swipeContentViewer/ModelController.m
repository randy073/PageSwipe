//
//  ModelController.m
//  swipeContentViewer
//
//  Created by Randy Yang on 8/24/15.
//  Copyright © 2015 Randy Yang. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface ModelController ()




@end

@implementation ModelController

@synthesize rootViewController;

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
       // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[NSMutableArray alloc] init];
        _textMessages = [[NSMutableArray alloc] init];
        _imageArrays = [[NSMutableArray alloc] init];
        _dataViewControllers = [[NSMutableArray alloc] init];
        [_pageData addObject:@"Pluto"];
        [_pageData addObject:@"Dolphin"];
        [_pageData addObject:@"Apple"];
        [_textMessages addObject:@" - A dwarf planet \n - First Kuiper belt object to be discovered \n - Primarily made of ice and rock \n - Discovered by Clyde Tombaugh in 1930"];
        [_textMessages addObject:@" - A mammel \n - Lives in the ocean \n - One of the most intelligent animals \n "];
        [_textMessages addObject:@" - A fruit \n - Originated in central Asia \n - More than 7500 known cultivars of apples \n "];
        NSMutableArray *plutoArrays =[[NSMutableArray alloc] init];
        [plutoArrays addObject:[UIImage imageNamed:@"pluto"]];
        NSMutableArray *dolphinArrays =[[NSMutableArray alloc] init];
        [dolphinArrays addObject:[UIImage imageNamed:@"dolphin"]];
        NSMutableArray *appleArrays =[[NSMutableArray alloc] init];
        [appleArrays addObject:[UIImage imageNamed:@"apple"]];
        [_imageArrays addObject:plutoArrays];
        [_imageArrays addObject:dolphinArrays];
        [_imageArrays addObject:appleArrays];
        
        
    }
    return self;
}

-(void)addNewPage:(UIImage *)newImage{
    [_pageData addObject:@"NewTitle"];
    [_textMessages addObject:@"NewText"];
    NSMutableArray *newArray =[[NSMutableArray alloc] init];
    [newArray addObject:newImage];
    [_imageArrays addObject:newArray];
    
    [rootViewController updatePages:[_pageData count]-1];
    
}
-(NSUInteger)addImage:(UIImage *)newImage viewController:(DataViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    [_imageArrays[index] addObject:newImage];
    viewController.imageArray = _imageArrays[index];
    return [_imageArrays[index] count]-1;
}
-(void) updateTextInfo:(NSString *)titleText withBodyText:(NSString *)bodyText withViewController:(DataViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    _pageData[index] = titleText;
    _textMessages[index] = bodyText;
}
-(void) deleteImage:(NSUInteger)imageIndex withDataViewController:(DataViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    [_imageArrays[index] removeObjectAtIndex:imageIndex];
}
-(void) deletePage:(DataViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    [_pageData removeObjectAtIndex:index];
    [_textMessages removeObjectAtIndex:index];
    [_imageArrays removeObjectAtIndex:index];
    [rootViewController reloadPageViewController];
    
}
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.contentText = self.textMessages[index];
    dataViewController.imageArray = self.imageArrays[index];
    dataViewController.imageIndex = 0;
    dataViewController.modelController = self;
    _dataViewControllers[index] = dataViewController;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.dataViewControllers indexOfObject:viewController];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
