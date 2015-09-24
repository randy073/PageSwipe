//
//  DataViewController.m
//  swipeContentViewer
//
//  Created by Randy Yang on 8/24/15.
//  Copyright © 2015 Randy Yang. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) UIImagePickerController *currentPageImagePicker;
@property (strong, nonatomic) UIImagePickerController *otherPageImagePicker;
@property (strong, nonatomic) UITextView *textTitle;
@property (strong, nonatomic) UITextView *content;
@property (strong, nonatomic) CAGradientLayer *layer;




@end

@implementation DataViewController

@synthesize modelController;


- (void) displayFloatingText{
    [_scroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [_scroll removeFromSuperview];
    [_addButton removeFromSuperview];
    [_switchButton removeFromSuperview];
    [_doneButton removeFromSuperview];
    [_deleteButton removeFromSuperview];
    [_backGroundImageView removeFromSuperview];
    [_layer removeFromSuperlayer];
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    _backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) ];
    
    _backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backGroundImageView.clipsToBounds = YES;
    _backGroundImageView.image = _imageArray[_imageIndex];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
    
//    [_backGroundImageView.layer addAnimation:transition forKey:nil];
    
    [self.view addSubview: _backGroundImageView];
    
    CAGradientLayer *bgLayer = [DataViewController greyGradient];
    bgLayer.frame = CGRectMake(0, statusBarFrame.size.height , self.view.bounds.size.width,40);
    [self.view.layer insertSublayer:bgLayer above:self.view.layer];
    
    
    
    _addButton  = [UIButton buttonWithType:UIButtonTypeContactAdd];

    CGRect buttonFrame = CGRectMake(self.view.bounds.size.width-50, statusBarFrame.size.height + 5, 60, 30);
    _addButton.frame = buttonFrame;
    _addButton.backgroundColor = [UIColor clearColor];
    _addButton.tintColor = [UIColor whiteColor];
    [_addButton addTarget:self
                  action:@selector(addButtonClicked)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
    
//    _pageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    CGRect switchFrame = CGRectMake(self.view.bounds.size.width/2-50, statusBarFrame.size.height + 5, 100, 30);
//    _pageButton.frame = switchFrame;
//    _pageButton.backgroundColor = [UIColor clearColor];
//    _pageButton.layer.cornerRadius = 5;
//    _pageButton.layer.borderWidth = 1;
//    _pageButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    [_pageButton setTitle:@"New Page" forState:UIControlStateNormal];
//    [_pageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
//    [_pageButton addTarget:self
//                   action:@selector(createNewTopic)
//         forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_pageButton];
    
    _switchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect switchFrame = CGRectMake(self.view.bounds.size.width/2-50, statusBarFrame.size.height + 5, 100, 30);
    _switchButton.frame = switchFrame;
    _switchButton.backgroundColor = [UIColor clearColor];
    _switchButton.layer.cornerRadius = 5;
    _switchButton.layer.borderWidth = 1;
    _switchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_switchButton setTitle:@"Switch" forState:UIControlStateNormal];
    [_switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_switchButton addTarget:self
                    action:@selector(nextPicture)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchButton];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect deleteFrame = CGRectMake(5, statusBarFrame.size.height + 5, 60, 30);
    _deleteButton.frame = deleteFrame;
    _deleteButton.backgroundColor = [UIColor clearColor];
    _deleteButton.layer.cornerRadius = 5;
    _deleteButton.layer.borderWidth = 1;
    _deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_deleteButton addTarget:self
                    action:@selector(deleteButtonClicked)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
    


    
    
    
    CGRect newRect = CGRectMake(0, 40 + statusBarFrame.size.height,self.view.bounds.size.width, self.view.bounds.size.height);
    
    _scroll = [[UIScrollView alloc] initWithFrame:newRect];
    
    _scroll.scrollEnabled = YES;
    
    
    //filler blank rows at the top of screen
    UITextView *spaceFiller = [[UITextView alloc] initWithFrame:newRect];
    [spaceFiller setBackgroundColor:[UIColor clearColor]];
    NSString *filler = @" \n";
    int numLines = self.view.bounds.size.height/10 - 3;
    for(int i = 0; i<numLines; i++){
        filler = [filler stringByAppendingString:@" \n"];
    }
    spaceFiller.text = filler;
    spaceFiller.textColor = [UIColor whiteColor];
    spaceFiller.font = [UIFont systemFontOfSize:10];
    spaceFiller.editable = NO;
    spaceFiller.scrollEnabled = NO;
    
    //title text
    _textTitle = [[UITextView alloc] init];
    _textTitle.text = [self.dataObject description];
    _textTitle.textColor = [UIColor whiteColor];
    _textTitle.font = [UIFont systemFontOfSize:72];
    [_textTitle setBackgroundColor:[UIColor clearColor]];
    _textTitle.editable = YES;
    _textTitle.scrollEnabled = NO;
    _textTitle.delegate = self;
    _textTitle.textContainer.maximumNumberOfLines = 1;
    [_textTitle setFrame:[self getTextViewFrameSize:_textTitle withX:0 withY:self.view.bounds.size.height-statusBarFrame.size.height-140]];
    
    
    //body text
    _content = [[UITextView alloc] init];
    _content.text = self.contentText;
    _content.textColor = [UIColor whiteColor];
    _content.font = [UIFont systemFontOfSize:20];
    [_content setBackgroundColor:[UIColor clearColor]];
    _content.editable = YES;
    _content.scrollEnabled = NO;
    _content.delegate = self;
    [_content setFrame:[self getTextViewFrameSize:_content withX:0 withY:self.view.bounds.size.height-statusBarFrame.size.height-35]];
    
    
    NSInteger h1 =_textTitle.frame.size.height;
    NSInteger h2 = _content.frame.size.height;
    NSInteger h3 = self.view.bounds.size.height;
    [_scroll setContentSize:CGSizeMake(self.view.bounds.size.width, h1 + h2 + h3*2)];
    
    [_scroll addSubview:spaceFiller];
    [_scroll addSubview:_textTitle];
    [_scroll addSubview:_content];
    
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//    singleTapGestureRecognizer.numberOfTapsRequired = 1;
//    singleTapGestureRecognizer.enabled = YES;
//    singleTapGestureRecognizer.cancelsTouchesInView = NO;
//    [_content addGestureRecognizer:singleTapGestureRecognizer];
    
//    UIPanGestureRecognizer *twoFingerPan = [[UIPanGestureRecognizer alloc] init];
//    twoFingerPan.minimumNumberOfTouches = 2;
//    twoFingerPan.maximumNumberOfTouches = 2;
//    [_scroll addGestureRecognizer:twoFingerPan];
//    //_scroll.multipleTouchEnabled = NO;
//    UISwipeGestureRecognizer *getLastImage = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastPicture:)];
//    getLastImage.numberOfTouchesRequired = 2;
//    getLastImage.direction = UISwipeGestureRecognizerDirectionDown;
//    //getLastImage.delaysTouchesBegan = YES;
//    [_scroll addGestureRecognizer:getLastImage];
//    
//    UISwipeGestureRecognizer *getNextImage = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPicture:)];
//    getNextImage.numberOfTouchesRequired = 2;
//    getNextImage.direction = UISwipeGestureRecognizerDirectionUp;
//    //getNextImage.delaysTouchesBegan = YES;
//    [_scroll addGestureRecognizer:getNextImage];
    
//    [twoFingerPan requireGestureRecognizerToFail:getLastImage];
//    [twoFingerPan requireGestureRecognizerToFail:getNextImage];
    
    _scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:_scroll];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *imageName = [self.dataObject description];
//    imageName = [imageName lowercaseString];
    
//    UIImage* image = [self resizeImage:[UIImage imageNamed:imageName] newSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
 
    [self displayFloatingText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:0.3];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:0.5];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:0.5];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:0.5];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}


-(void)nextPicture{
    if(_imageIndex+1 < [_imageArray count]){
        if(_imageArray[_imageIndex+1] != nil){
            _imageIndex += 1;
            _backGroundImageView.image = _imageArray[_imageIndex];
        }
    }else{
        _imageIndex = 0;
        _backGroundImageView.image = _imageArray[_imageIndex];
    }

}

-(void) addButtonClicked{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Add Image or Page"
                                 message:@"Select an action"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* image = [UIAlertAction
                         actionWithTitle:@"Add Image"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self addImage];
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* page =[UIAlertAction
                          actionWithTitle:@"Add Page"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [self createNewTopic];
                              [view dismissViewControllerAnimated:YES completion:nil];
                              
                          }];

    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:image];
    [view addAction:page];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)deleteButtonClicked{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Delete Image or Page"
                                 message:@"Select an action"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* image = [UIAlertAction
                            actionWithTitle:@"Delete Image"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [modelController deleteImage:_imageIndex withDataViewController:self];
                                [self nextPicture];
                                
                            }];
    UIAlertAction* page =[UIAlertAction
                          actionWithTitle:@"Delete Page"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [modelController deletePage:self];
                              [self willMoveToParentViewController:nil];
                              [self.view removeFromSuperview];
                              [self removeFromParentViewController];
                              
                          }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:image];
    [view addAction:page];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)createNewTopic{
    _otherPageImagePicker = [[UIImagePickerController alloc] init];
    _otherPageImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _otherPageImagePicker.delegate = self;
    
    [self presentViewController:_otherPageImagePicker animated:YES completion:NULL];
}

- (void)addImage{
    _currentPageImagePicker = [[UIImagePickerController alloc] init];
    _currentPageImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _currentPageImagePicker.delegate = self;
    
    [self presentViewController:_currentPageImagePicker animated:YES completion:NULL];
}
//image picker for adding new photos;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _importedImage = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if(picker == _currentPageImagePicker){
        _imageIndex = [modelController addImage:_importedImage viewController:self];
        _backGroundImageView.image = _importedImage;
    }else if(picker == _otherPageImagePicker){
        [modelController addNewPage:_importedImage];
    }
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(CGRect) getTextViewFrameSize:(UITextView *)textView withX:(NSInteger) offsetX withY:(NSInteger) offsetY{
    CGFloat fixedWidth = self.view.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = CGRectMake(offsetX, offsetY, fmaxf(newSize.width, fixedWidth), newSize.height);
    return newFrame;
}

-(void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect,_content.frame.origin)) {
//        CGPoint scrollPoint = CGPointMake(0.0, _content.frame.size.height+kbSize.height);
//        [_scroll setContentOffset:scrollPoint animated:YES];
//    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
}


- (void) textViewDidBeginEditing:(UITextView *) textView {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    [_addButton removeFromSuperview];
    [_switchButton removeFromSuperview];
    [_deleteButton removeFromSuperview];
    if(![_doneButton isDescendantOfView:self.view]) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect doneButtonFrame = CGRectMake(self.view.bounds.size.width-100, statusBarFrame.size.height + 5, 100, 30);
        _doneButton.frame = doneButtonFrame;
        _doneButton.backgroundColor = [UIColor clearColor];
        _doneButton.layer.cornerRadius = 5;
        _doneButton.layer.borderWidth = 1;
        _doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        [_doneButton addTarget:self
                        action:@selector(finishedEditing)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_doneButton];
    }
   
    
}

- (void)finishedEditing{
    [self.view endEditing:YES];
}

- (void) textViewDidChange:(UITextView *)textView{
    

    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    if(textView == _textTitle){
        [_textTitle setFrame:[self getTextViewFrameSize:_textTitle withX:0 withY:self.view.bounds.size.height-statusBarFrame.size.height-140]];
    }else if(textView == _content){
        [_content setFrame:[self getTextViewFrameSize:_content withX:0 withY:self.view.bounds.size.height-statusBarFrame.size.height-35]];
    }
    NSInteger h1 =_textTitle.frame.size.height;
    NSInteger h2 = _content.frame.size.height;
    NSInteger h3 = self.view.bounds.size.height;
    [_scroll setContentSize:CGSizeMake(self.view.bounds.size.width, h1 + h2 + h3*2)];
    

    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSInteger h1 =_textTitle.frame.size.height;
    NSInteger h2 = _content.frame.size.height;
    NSInteger h3 = self.view.bounds.size.height;
    [_scroll setContentSize:CGSizeMake(self.view.bounds.size.width, h1 + h2 + h3*2)];
    [self.view addSubview:_addButton];
    [self.view addSubview:_switchButton];
    [self.view addSubview:_deleteButton];
    [_doneButton removeFromSuperview];
    
    [modelController updateTextInfo:_textTitle.text withBodyText:_content.text withViewController:self];
    _contentText = _content.text;
    _dataObject = _textTitle.text;
    //[self displayFloatingText];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        [self displayFloatingText];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
       
        
        
    }];
}


//tap to scroll content to top/hide content.
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    if (_scroll.contentOffset.y == 0) {
        int numLines = self.view.bounds.size.height/10 - 3;
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        [_scroll setContentOffset:CGPointMake(0, numLines*10-statusBarFrame.size.height - 85)];

    }else{
        [_scroll setContentOffset:CGPointMake(0, 0)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
