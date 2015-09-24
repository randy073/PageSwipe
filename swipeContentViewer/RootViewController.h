//
//  RootViewController.h
//  swipeContentViewer
//
//  Created by Randy Yang on 8/24/15.
//  Copyright © 2015 Randy Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

-(void) updatePages:(NSInteger) Index;
-(void) reloadPageViewController;

@end

