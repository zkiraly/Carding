//
//  CardingTransitionToListController.m
//  Carding
//
//  Created by Zsolt Kiraly on 10/1/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingTransitionToListController.h"
#import "CardingViewController.h"
#import "CardingSingleViewController.h"
#import "CardingCell.h"

@interface CardingTransitionToListController() {
    
}

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIView *detailViewSnapshot;
@property (nonatomic, assign) CGRect cellFrame;

@end

@implementation CardingTransitionToListController

- (id)initWithParentViewController:(CardingSingleViewController *)viewController {
    if (!(self = [super init])) return nil;
    
    _parentViewController = viewController;
    
    return self;
}

#pragma mark UIGestureRecognizer handlers

- (void)userDidSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"CardingTransitionToListController userDidSwipe");
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        
    }
    
    self.interactive = NO;
    [_parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)userDidPan:(UIPanGestureRecognizer*)recognizer {
    self.interactive = YES;
    static CGFloat startingDistanceToTop;
    //static UIView *cardToPan = nil;
    static CGPoint offset;
    //static CGPoint startingFrameOrigin;
    static CGPoint startingTouch;
    CGPoint touch = [recognizer locationInView:_parentViewController.view];
    CGFloat progress;
    NSLog(@"CardingTransitionToListController userDidPan");
    
    CGPoint location = [recognizer locationInView:self.parentViewController.view];
    
    //CGPoint velocity = [recognizer velocityInView:self.parentViewController.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"got UIGestureRecognizerStateBegan");
#if 1
        
        
        // We're being invoked via a gesture recognizer – we are necessarily interactive
        self.interactive = YES;
        // start the transition
        // get distance to the top
        //location.y -=64.0;
        startingDistanceToTop = location.y;
        startingTouch = location;
        
        // Create a interactive transition and pop the view controller
        //_parentViewController.interactiveAnimatedPushTransition = self;
        
        
        
        
        
        // now initiate the push
        
        //[_parentViewController.navigationController popViewControllerAnimated:YES];
        [_parentViewController dismissViewControllerAnimated:YES completion:nil];

#endif
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"got UIGestureRecognizerStateChanged");
        // Update the interactive transition's progress
        //progress = -1*(location.y - startingTouch.y) / startingDistanceToTop;
        progress = location.y / _cellFrame.origin.y;
        progress = MIN(1.0, MAX(0.0, progress));
        CGPoint touchInContainerView = touch;//[_parentViewController.view convertPoint:touch fromView:_parentViewController.collectionView];
        
        NSLog(@"touches x: %f y: %f progress: %f", touchInContainerView.x, touchInContainerView.y, progress);
        
        // get the UIView we need to drag
        //UIView *draggingView = [_parentViewController.navigationController.view viewWithTag:101101];
        UIView *draggingView = _detailViewSnapshot;
        NSLog(@"draggingView: %@", draggingView);
        CGRect viewFrame = draggingView.frame;
        //viewFrame.origin.x = touch.x - offset.x;
        viewFrame.origin.y = touchInContainerView.y - offset.y;//+64.0;
        NSLog(@"Newframe location: %f", viewFrame.origin.y);
        // animate
        //[UIView animateWithDuration:0.02 animations:^{
        draggingView.frame = viewFrame;
        //}];
        
        [self updateInteractiveTransition:progress];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Depending on our state and the velocity, determine whether to cancel or complete the transition.
        NSLog(@"got UIGestureRecognizerStateEnded");
        
        // Finish or cancel the interactive transition
        progress = location.y / _cellFrame.origin.y;
        progress = MIN(1.0, MAX(0.0, progress));
        
        NSLog(@"touches x: %f y: %f progress: %f", touch.x, touch.y, progress);
        
        if (progress > 0.25) {
            NSLog(@"Finishing interactive transition, progress: %f", progress);
            [self finishInteractiveTransition];
#if 1
            // get the UIView we need to drag
            UIView *draggingView = _detailViewSnapshot;//[_parentViewController.navigationController.view viewWithTag:101101];
            CGRect viewFrame = draggingView.frame;
            //viewFrame.origin.x = touch.x - offset.x;
            viewFrame.origin.y = _cellFrame.origin.y;
            // animate
            [UIView animateWithDuration:[self duration]*(1.0-progress) animations:^{
                draggingView.frame = viewFrame;
            }];
#endif
        }
        else {
            NSLog(@"Cancelling the interactive transition, progress: %f", progress);
#if 1
            // remove the views used for animation, and restore the collection view
            
            
            // get the UIView we need to drag
            //UIView *draggingView = [_parentViewController.navigationController.view viewWithTag:101101];
            UIView *draggingView = _detailViewSnapshot;
            CGRect viewFrame = draggingView.frame;
            //viewFrame.origin.x = touch.x - offset.x;
            viewFrame.origin.y = 0.0f;//startingFrameOrigin.y;
            // animate
            [UIView animateWithDuration:[self duration]*progress animations:^{
                //    [UIView animateWithDuration:1.0f animations:^{
                    
                draggingView.frame = viewFrame;
            }];
#endif
            
            [self cancelInteractiveTransition];
            
        }
        
        //[self cancelInteractiveTransition];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"Returning  transition to list duration");
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // save the context
    _transitionContext = transitionContext;
    
    CardingSingleViewController *fromViewController = (CardingSingleViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UINavigationController *navController = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
    CardingViewController *toViewController = (CardingViewController *)[navController.viewControllers objectAtIndex:0];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:navController.view];
    navController.view.hidden = YES;
    
    // take snapshot of fromView
    UIView *fromSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    _detailViewSnapshot = fromSnapshot;
    NSLog(@"fromSnapshot: %@", fromSnapshot);
    fromSnapshot.frame = [containerView convertRect:fromViewController.view.frame fromView:fromViewController.view.superview];
    // switch the fromView with the snapshot
    fromViewController.view.hidden = YES;
    fromViewController.view.alpha = 0.0;
    
    
    // get the selected item's path
    //NSIndexPath *selectedIndexPath = toViewController.selectedIndexPath;
    
    // get the visible cell index paths
    NSMutableArray *visibleCellIndexPaths = [[toViewController.collectionView indexPathsForVisibleItems] mutableCopy];
    // initialize the snapshots array
    NSMutableArray *snapshots = [[NSMutableArray alloc] initWithCapacity:visibleCellIndexPaths.count];
    
    // sort the index paths by item, otherwise they are random order
    [visibleCellIndexPaths sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger r1 = ((NSIndexPath*)obj1).item;
        NSInteger r2 = ((NSIndexPath*)obj2).item;
        if (r1 > r2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (r1 < r2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // get some info on the screen
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    CGRect selectedCellFrame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    
    // starting offset
    int startingYOffset = screenRect.size.height + 20.0;

    // now make snapshots and add them to containerView
    for (int i = 0; i < visibleCellIndexPaths.count; i++) {
        
        // take asnapshot, add it to the snapshot array
        CardingCell *cell = (CardingCell *)[toViewController.collectionView cellForItemAtIndexPath:visibleCellIndexPaths[i]];
        // leave out the selected cell
        if (cell.indexPath.item != toViewController.selectedIndexPath.item) {
            // get a snapshot using off-screen rendering
            UIGraphicsBeginImageContext(cell.bounds.size);
            [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageView *cellSnapshot = [[UIImageView alloc] initWithImage:cellImage];
            
            [snapshots addObject:cellSnapshot];
            [containerView addSubview:cellSnapshot];
            
            // set up the initial position
            // start 20 points below the screen
            CGRect cellFrame = [containerView convertRect:cell.frame fromView:cell.superview];
            cellFrame.origin.y += startingYOffset;
            cellSnapshot.frame = cellFrame;
            
            // set the drop-shadow
            cellSnapshot.layer.masksToBounds = NO;
            [cellSnapshot.layer setShadowColor:[UIColor blackColor].CGColor];
            [cellSnapshot.layer setShadowOpacity:0.6];
            [cellSnapshot.layer setShadowRadius:5.0];
            [cellSnapshot.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
            [cellSnapshot.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
        } else {
            // this is the selected cell, so save it's frame info
            selectedCellFrame = [containerView convertRect:cell.frame fromView:cell.superview];
            [containerView addSubview:fromSnapshot];
            // set the drop-shadow
            fromSnapshot.layer.masksToBounds = NO;
            [fromSnapshot.layer setShadowColor:[UIColor blackColor].CGColor];
            [fromSnapshot.layer setShadowOpacity:0.6];
            [fromSnapshot.layer setShadowRadius:5.0];
            [fromSnapshot.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
            [fromSnapshot.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];

        }
    }
    _cellFrame = selectedCellFrame;
    
    // everything is in the starting position
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // move the cell snapshots to the final position
        for (UIView *snapshot in snapshots) {
            CGRect snapshotFrame = snapshot.frame;
            // take out the y offset
            snapshotFrame.origin.y -= startingYOffset;
            snapshot.frame = snapshotFrame;
        }
        
        // move the fromSanpshot
        CGRect fromFrame = fromSnapshot.frame;
        fromFrame.origin.y = selectedCellFrame.origin.y;
        // Move the toViewController's view to the final position
        if (!self.interactive) {
            fromSnapshot.frame = fromFrame;
        }

        
        
    } completion:^(BOOL finished) {
        NSLog(@"CardingTransitionToListController animateTransition: in completion.");
        
        // make the toView visible
        navController.view.hidden = NO;
        navController.view.alpha = 1.0;
        
        // remove the snapshots
        for (UIView *snapshot in snapshots) {
            [snapshot removeFromSuperview];
            
        }
        [fromSnapshot removeFromSuperview];
        
        if([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [fromViewController.view removeFromSuperview];
            // Declare that we've finished
            [transitionContext completeTransition:YES];
        }
    
    }];
    

}

- (void)animationEnded:(BOOL)transitionCompleted {
    NSLog(@"CardingTransitionToListController animationEnded: %@ canceled: %@", transitionCompleted ? @"YES" : @"NO",
           [_transitionContext transitionWasCancelled] ? @"YES" : @"NO");
    
    CardingSingleViewController *fromViewController = (CardingSingleViewController*)[_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //CardingViewController *toViewController = (CardingViewController*)[_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [_transitionContext containerView];
    
    if ([_transitionContext transitionWasCancelled]) {
        for (UIView *view in containerView.subviews) {
            [view removeFromSuperview];
        }
        
        [containerView addSubview:fromViewController.view];
        fromViewController.view.alpha = 1.0;
        fromViewController.view.hidden = NO;
    }
    
    
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];
    NSLog(@"CardingTransitionToListController startInteractiveTransition:");
    
    self.transitionContext = transitionContext;
    
    //UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //[[transitionContext containerView] addSubview:toViewController.view];
#if 0
    NSLog(@"raise the selected card a bit");
    
    UIView *draggingView = [_parentViewController.navigationController.view viewWithTag:101101];
    CGRect tempFrame = draggingView.frame;
    tempFrame.origin.y -= 32.0;
    
    [UIView animateWithDuration:0.2 animations:^{
        draggingView.frame = tempFrame;
    }];
#endif
    
    
    
    
    
    //CGRect endFrame = [[transitionContext containerView] bounds];
    
    
    
}


#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    NSLog(@"UIViewControllerInteractiveTransitioning updateInteractiveTransition:");
    
    [super updateInteractiveTransition:percentComplete];
    
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext updateInteractiveTransition:percentComplete];
    
}

- (void)finishInteractiveTransition {
    NSLog(@"UIViewControllerInteractiveTransitioning finishInteractiveTransition");
    
    [super finishInteractiveTransition];
    
    NSLog(@"CardingTransitoinToSingleController finishInteractiveTransition");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    //[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    [transitionContext finishInteractiveTransition];
    //[transitionContext completeTransition:YES];
    self.interactive = NO;
    
}

- (void)cancelInteractiveTransition {
    NSLog(@"UIViewControllerInteractiveTransitioning cancelInteractiveTransition");
    [super cancelInteractiveTransition];
    
    NSLog(@"CardingTransitoinToSingleController cancelInteractiveTransition");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
#if 0
    UIView *containerView = [transitionContext containerView];
    NSArray *subviews = [containerView subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    [containerView addSubview:fromViewController.view];
#endif
    [transitionContext cancelInteractiveTransition];
    //[transitionContext completeTransition:NO];
    
    //[transitionContext completeTransition:transitionContext.transitionWasCancelled];
    self.interactive = NO;
}




@end
