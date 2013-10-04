//
//  CardingViewController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingViewController.h"
#import "CardingDetailViewController.h"
#import "CardingDetailLayout.h"
#import "CardingSingleViewController.h"
#import "CardingCell.h"
#import "CardingModel.h"
#import "CardingTransitionToSingleController.h"
#import "CardingTransitionToListController.h"

@interface CardingViewController () //<UIViewControllerTransitioningDelegate>
{
    
}
@property (nonatomic, strong) CardingTransitionToSingleController *interactiveAnimatedPushTransition;

@end

@implementation CardingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Cards";
    self.interactiveAnimatedPushTransition = [[CardingTransitionToSingleController alloc] initWithParentViewController:self];

    UIPanGestureRecognizer *pushRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self.interactiveAnimatedPushTransition action:@selector(userDidPan:)];
    [self.collectionView addGestureRecognizer:pushRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.collectionView reloadData];
    //[self.collectionViewLayout invalidateLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set ourself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
    //NSLog(@"%@", [self.navigationController.view recursiveDescription]);
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"CardingViewController viewWillDisappear");
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

#pragma mark - UIViewControllerTransitioningDelegate methods
#if 1
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    NSLog(@"CardingViewController animationControllerForDismissedController:");
    return [[CardingTransitionToListController alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    NSLog(@"CardingViewController animationControllerForPresentedController:");
    
    return self.interactiveAnimatedPushTransition;
    //return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    NSLog(@"CardingViewController interactionControllerForPresentation:");
    return self.interactiveAnimatedPushTransition;
    //return nil;
}
#endif

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"CardingViewController numberOfSectionsInCollectionView");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"CardingViewController collectionView:numberOfItemsInSection: returning %lu", (unsigned long)[CardingModel sharedInstance].cards.count);
    
    return [CardingModel sharedInstance].cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"CardingViewController collectionView:cellForItemAtIndexPath: %@", indexPath);
    
    CardingCell *cell = (CardingCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    cell.cardNumber.text = [[CardingModel sharedInstance].cards objectAtIndex:indexPath.item];
    
    cell.indexPath = indexPath;
    
    // the following should really be in the cell class, but so far I could not make it work that way
    
#if 1
    // background
    
    //UIColor *backgroundPattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]];
    // background
    cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    //cell.backgroundView = bgView;
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBgView.backgroundColor = [UIColor grayColor];
    //cell.selectedBackgroundView = selectedBgView;
    
    //cell.backgroundView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    
    //cell.backgroundView.backgroundColor = backgroundColor;
    //cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    
    // drop shadow
    cell.layer.masksToBounds = NO;
    [cell.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.layer setShadowOpacity:0.6];
    [cell.layer setShadowRadius:5.0];
    [cell.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
    [cell.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
    
#endif
    
    return cell;
}

#if 0
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"CardingViewController prepareForSegue:sender:");
    
    if ([segue.destinationViewController isKindOfClass:[CardingSingleViewController class]]) {
        // Get the selected item index path
        _selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        
        // Set the thing on the view controller we're about to show
        if (_selectedIndexPath != nil) {
            CardingSingleViewController *secondViewController = (CardingSingleViewController *)segue.destinationViewController;
            secondViewController.item = [[[CardingModel sharedInstance] cards] objectAtIndex:_selectedIndexPath.item];
            secondViewController.transitioningDelegate = self;
        }
    }
}
#endif



#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CardingViewController collectionView:disSelectItemAtIndexPath");
    
    UIStoryboard *storyboard = self.storyboard;
    
    CardingSingleViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"SINGLE_VIEW_CONTROLLER"];
    
    _selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    
    svc.item = [[[CardingModel sharedInstance] cards] objectAtIndex:_selectedIndexPath.item];
    
    //self.interactiveAnimatedPushTransition.theFromViewController = self;
    
    //svc.transitioningDelegate = self;

    [self.navigationController pushViewController:svc animated:YES];
    
    //[self performSegueWithIdentifier:@"CELL_TO_DETAIL_SEGUE" sender:self];
    
}

#pragma mark - UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        // clear the selectedIndexPath after display
        _selectedIndexPath = nil;
    }
    
}
#if 1
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[CardingSingleViewController class]]) {
        NSLog(@"CardingViewController returning an animationController");
        return self.interactiveAnimatedPushTransition;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    // Check if this is for our custom transition
    if ([animationController isKindOfClass:[CardingTransitionToSingleController class]] && [_interactiveAnimatedPushTransition isInteractive]) {
        NSLog(@"CardingViewController returning an interactionController");
        return self.interactiveAnimatedPushTransition;
        //return nil;
    }
    else {
        return nil;
    }
}
#endif

#if 0
#pragma mark UIGestureRecognizer handlers

- (void)handlePushRecognizer:(UIPanGestureRecognizer*)recognizer {
    static CGFloat startingDistanceToTop;
    static UIView *cardToPan = nil;
    static CGPoint offset;
    static CGPoint startingFrameOrigin;
    CGPoint touch = [recognizer locationInView:self.collectionView];
    CGFloat progress;
    NSLog(@"CardingViewController handlePushRecognizer");
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        // get distance to the top
        startingDistanceToTop = touch.y;
        
        // Create a interactive transition and pop the view controller
        self.interactiveAnimatedPushTransition = [[CardingTransitionToSingleController alloc] init];
        
        // get the cell index path under that touch
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:touch];
        offset = [recognizer locationInView:[self.collectionView cellForItemAtIndexPath:indexPath]];
        startingFrameOrigin = [self.collectionView cellForItemAtIndexPath:indexPath].frame.origin;
        NSLog(@"offset x: %f, y: %f", offset.x, offset.y);
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        // now initiate the push
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
        // Update the interactive transition's progress
        progress = -1*[recognizer translationInView:self.view].y / startingDistanceToTop;
        progress = MIN(1.0, MAX(0.0, progress));
        
        NSLog(@"touches x: %f y: %f progress: %f", touch.x, touch.y, progress);
        
        // get the UIView we need to drag
        UIView *dragingView = [self.navigationController.view viewWithTag:101101];
        CGRect viewFrame = dragingView.frame;
        //viewFrame.origin.x = touch.x - offset.x;
        viewFrame.origin.y = touch.y - offset.y+64.0;
        // animate
        [UIView animateWithDuration:0.1 animations:^{
            dragingView.frame = viewFrame;
        }];
        
        [self.interactiveAnimatedPushTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"UIGestureRecognizerStateEnded || UIGestureRecognizerStateCancelled");
        // Finish or cancel the interactive transition
        progress = -1*[recognizer translationInView:self.view].y / startingDistanceToTop;
        progress = MIN(1.0, MAX(0.0, progress));
        
        NSLog(@"touches x: %f y: %f progress: %f", touch.x, touch.y, progress);
        
        if (progress > 0.5) {
            [self.interactiveAnimatedPushTransition finishInteractiveTransition];
            // get the UIView we need to drag
            UIView *dragingView = [self.navigationController.view viewWithTag:101101];
            CGRect viewFrame = dragingView.frame;
            //viewFrame.origin.x = touch.x - offset.x;
            viewFrame.origin.y = 0.0+64.0;
            // animate
            [UIView animateWithDuration:0.3 animations:^{
                dragingView.frame = viewFrame;
            }];
        }
        else {
            NSLog(@"Cancelling the interactive transition");
            // remove the views used for animation, and restore the collection view
            
            
            // get the UIView we need to drag
            UIView *dragingView = [self.navigationController.view viewWithTag:101101];
            CGRect viewFrame = dragingView.frame;
            //viewFrame.origin.x = touch.x - offset.x;
            viewFrame.origin.y = startingFrameOrigin.y;
            // animate
            [UIView animateWithDuration:1.0 animations:^{
                dragingView.frame = viewFrame;
            }];
            
            [self.interactiveAnimatedPushTransition cancelInteractiveTransition];

        }
        
        
        self.interactiveAnimatedPushTransition = nil;
    }
    
}
#endif

@end
