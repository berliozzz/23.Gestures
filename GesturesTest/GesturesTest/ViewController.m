//
//  ViewController.m
//  GesturesTest
//
//  Created by Nikolay Berlioz on 10.11.15.
//  Copyright © 2015 Nikolay Berlioz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *testView;

@property (assign, nonatomic) CGFloat testViewScale;
@property (assign, nonatomic) CGFloat testViewRotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 50,
                                                           CGRectGetMidY(self.view.bounds) - 50,
                                                            100, 100)];
    view.backgroundColor = [UIColor greenColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:view];
    
    self.testView = view;
    
    
    //---------------------   tapGesture   ---------------------------------

    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                        action:@selector(handleTap:)];
 
    [self.view addGestureRecognizer:tapGesture];
    
    //--------------------   doubleTapGesture   ----------------------------
    
    UITapGestureRecognizer *doubleTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTap:)];
    
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTapGesture];
    
    //delay before double tap
    [tapGesture  requireGestureRecognizerToFail:doubleTapGesture];
    
    //----------------   doubleTapDoubleTouchGesture   -------------------
    
    UITapGestureRecognizer *doubleTapDoubleTouchGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTapDoubleTouch:)];
    
    doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    doubleTapDoubleTouchGesture.numberOfTouchesRequired = 2;
    
    [self.view addGestureRecognizer:doubleTapDoubleTouchGesture];
    
    //----------------   pinchGesture   -------------------------------

    UIPinchGestureRecognizer *pinchGesture =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePinch:)];
    
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    //----------------   rotationGesture   ---------------------------
    
    UIRotationGestureRecognizer *rotationGesture =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(handleRotation:)];
    
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
    
    //----------------   panGesture   -------------------------------
    
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(handlePan:)];
    panGesture.delegate = self;
    
    [self.view addGestureRecognizer:panGesture];
    
    
    //----------------   verticalSwipeGesture   ---------------------
    
    UISwipeGestureRecognizer *verticalSwipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleVerticalSwipe:)];
    
    verticalSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    verticalSwipeGesture.delegate = self;
    
    [self.view addGestureRecognizer:verticalSwipeGesture];
    
    //----------------   horizontalSwipeGesture   -------------------
    
    UISwipeGestureRecognizer *horizontalSwipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleHorizontalSwipe:)];
    
    horizontalSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    horizontalSwipeGesture.delegate = self;
    
    [self.view addGestureRecognizer:horizontalSwipeGesture];
}

//***************************   Methods  ***************************************

#pragma mark - Methods

- (UIColor*) randomColor
{
    CGFloat red = (float)(arc4random() % 256) / 255;
    CGFloat green = (float)(arc4random() % 256) / 255;
    CGFloat blue = (float)(arc4random() % 256) / 255;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}



//***************************   Gestures  **************************************

#pragma mark - Gestures

- (void) handleTap:(UIGestureRecognizer*) tapGesture
{
    NSLog(@"Tap: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    self.testView.backgroundColor = [self randomColor];
}

- (void) handleDoubleTap:(UIGestureRecognizer*) doubleTapGesture
{
    NSLog(@"DoubleTap: %@", NSStringFromCGPoint([doubleTapGesture locationInView:self.view]));
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.2f, 1.2f);
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.testView.transform = newTransform;
                     }];
    self.testViewScale = 1.2f;
}

- (void) handleDoubleTapDoubleTouch:(UIGestureRecognizer*) doubleTapDoubleTouchGesture
{
    NSLog(@"Double Tap Double Touch: %@", NSStringFromCGPoint([doubleTapDoubleTouchGesture locationInView:self.view]));
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.8f, 0.8f);
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.testView.transform = newTransform;
                     }];
    self.testViewScale = 0.8f;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) pinchGesture
{
    NSLog(@"Handle Pinch %1.3f", pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan)
    {
        self.testViewScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.testView.transform = newTransform;
    
    self.testViewScale = pinchGesture.scale;
}

- (void) handleRotation:(UIRotationGestureRecognizer*) rotationGesture
{
    NSLog(@"handleRotation %1.3f", rotationGesture.rotation);
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan)
    {
        self.testViewRotation = 0;
    }
    
    
    CGFloat newRotation = rotationGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);
   
    self.testView.transform = newTransform;
    self.testViewRotation = rotationGesture.rotation;

}

- (void) handlePan:(UIPanGestureRecognizer*) panGesture
{
    NSLog(@"handlePan");
    
    UIEvent *event = [[UIEvent alloc] init];
    CGPoint point = [panGesture locationInView:self.view];
    UIView *view = [self.view hitTest:point withEvent:event];
    
    if ([view isEqual:self.testView]) //if view == self.testView may take him
    {
        self.testView.center = [panGesture locationInView:self.view];
    }
}

- (void) handleVerticalSwipe:(UISwipeGestureRecognizer*) verticalSwipeGesture
{
     NSLog(@"Vertical Swipe");
}

- (void) handleHorizontalSwipe:(UISwipeGestureRecognizer*) horizontalSwipeGesture
{
     NSLog(@"Horizontal Swipe");
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


@end
