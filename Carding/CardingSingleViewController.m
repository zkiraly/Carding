//
//  CardingSingleViewController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/30/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingSingleViewController.h"
#import "CardingTransitionToListController.h"
#import "CardingViewController.h"

@interface CardingSingleViewController ()
{
    
}

//@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation CardingSingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.cardNumber.text = self.item;
    
    //self.interactiveAnimatedPopTransition = [[CardingTransitionToListController alloc] initWithParentViewController:self];
    
    //UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    //UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.interactiveAnimatedPopTransition action:@selector(handlePopRecognizer:)];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactiveAnimatedPopTransition action:@selector(userDidPan:)];
    
    
    //popRecognizer.edges = UIRectEdgeLeft;
    //[self.view addGestureRecognizer:popRecognizer];
    [self.view addGestureRecognizer:panRecognizer];
    
    UISwipeGestureRecognizer *swipeToPopRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.interactiveAnimatedPopTransition action:@selector(userDidSwipe:)];
    [self.view addGestureRecognizer:swipeToPopRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"CardingSingeViewController viewWillAppear:");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"CardingSingeViewController viewDidAppear:");
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"CardingSingeViewController viewWillDisappear:");
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate methods
#if 1

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    NSLog(@"CardingSingleViewController in nav controller delegate animationControllerForOperation");
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[CardingViewController class]]) {
        //return [[CardingTransitionToListController alloc] init];
        return self.interactiveAnimatedPopTransition;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    NSLog(@"CardingSingleViewController in nav controller delegate interactionControllerForAnimationController");
    // Check if this is for our custom transition
    if ([animationController isKindOfClass:[CardingTransitionToListController class]] && [_interactiveAnimatedPopTransition isInteractive]) {
        return self.interactiveAnimatedPopTransition;
    }
    else {
        return nil;
    }
}
#endif

#pragma mark UIGestureRecognizer handlers

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    NSLog(@"CardingSingleViewController handlePopRecognizer got UIScreenEdgePan");
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        //self.interactiveAnimatedPopTransition = [[CardingTransitionToListController alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactiveAnimatedPopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactiveAnimatedPopTransition finishInteractiveTransition];
        }
        else {
            [self.interactiveAnimatedPopTransition cancelInteractiveTransition];
        }
        
        self.interactiveAnimatedPopTransition = nil;
    }
    
}



@end
