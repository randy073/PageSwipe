//
//  DataViewController.h
//  swipeContentViewer
//
//  Created by Randy Yang on 8/24/15.
//  Copyright © 2015 Randy Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ModelController.h"

@class ModelController;

@interface DataViewController : UIViewController <UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate>{
    @private
        ModelController *modelController;
}

+(CAGradientLayer*) greyGradient;

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSString* contentText;
@property (strong, nonatomic) IBOutlet UIImage *importedImage;
@property (strong, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (strong, nonatomic) UIScrollView* scroll;
@property (strong, nonatomic) NSMutableArray* imageArray;
@property  NSUInteger imageIndex;
@property (retain) ModelController *modelController;




-(void)displayFloatingText;

@end

