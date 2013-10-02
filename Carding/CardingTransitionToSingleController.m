//
//  CardingTransitionController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/27/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardingTransitionToSingleController.h"
#import "CardingViewController.h"
#import "CardingSingleViewController.h"
#import "CardingCell.h"

@interface CardingTransitionToSingleController() {
    
}


//@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CardingTransitionToSingleController

- (id)initWithParentViewController:(CardingViewController *)viewController {
    if (!(self = [super init])) return nil;
    
    _parentViewController = viewController;
    
    return self;
}

#pragma mark UIGestureRecognizer handlers

- (void)userDidPan:(UIPanGestureRecognizer*)recognizer {
    
    static CGFloat startingDistanceToTop;
    static UIView *cardToPan = nil;
    static CGPoint offset;
    static CGPoint startingFrameOrigin;
    CGFloat progress;
    NSLog(@"CardingTransitionToSingleController handlePushRecognizer");
    
    CGPoint location = [recognizer locationInView:self.parentViewController.view];
    //CGPoint velocity = [recognizer velocityInView:self.parentViewController.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"got UIGestureRecognizerStateBegan");
#if 0
        // We're being invoked via a gesture recognizer – we are necessarily interactive
        self.interactive = YES;
        // start the transition
        // get distance to the top
        startingDistanceToTop = location.y;
        
        // Create a interactive transition and pop the view controller
        //_parentViewController.interactiveAnimatedPushTransition = self;
        
        // get the cell index path under that touch
        NSIndexPath *indexPath = [_parentViewController.collectionView indexPathForItemAtPoint:location];
        offset = [recognizer locationInView:[_parentViewController.collectionView cellForItemAtIndexPath:indexPath]];
        startingFrameOrigin = [self.collectionView cellForItemAtIndexPath:indexPath].frame.origin;
        NSLog(@"offset x: %f, y: %f", offset.x, offset.y);
        [_parentViewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        // now initiate the push
        [_parentViewController collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
#endif
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"got UIGestureRecognizerStateChanged");
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Depending on our state and the velocity, determine whether to cancel or complete the transition.
        NSLog(@"got UIGestureRecognizerStateEnded");
        
        //[self finishInteractiveTransition];
        [self cancelInteractiveTransition];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (void)animationEnded:(BOOL)transitionCompleted {
    // Reset to our default state
    self.interactive = NO;
    //self.presenting = NO;
    self.transitionContext = nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"CardingTransitionToSingleController animateTransition:");
    if(self.interactive) {
        NSLog(@"It is an interactive transition");
        
        
        return;
    }
    NSLog(@"It is a NON-interactive transition");
    
    CardingViewController *fromViewController = (CardingViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CardingSingleViewController *toViewController = (CardingSingleViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // Setup the final view states
    CGRect newVCFrame = [transitionContext finalFrameForViewController:toViewController];
    newVCFrame.origin.y = 64.0;
    
    // add the "to" view
    // get a snapshot using off-screen rendering
    UIGraphicsBeginImageContext(toViewController.view.bounds.size);
    [toViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *toViewSnapshot = [[UIImageView alloc] initWithImage:viewImage];
    toViewSnapshot.tag = 101101;
    
    [containerView addSubview:toViewController.view];
    toViewController.view.hidden = YES;
    //[containerView addSubview:toViewSnapshot];
    
    // Get a snapshot of the thing cell we're transitioning from
    // we need snapshots of the elected cell, and all other visible cells
    NSIndexPath *selectedIndexPath = [[fromViewController.collectionView indexPathsForSelectedItems] firstObject];
    
    NSMutableArray *visibleCellIndexPaths = [[fromViewController.collectionView indexPathsForVisibleItems] mutableCopy];
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
    
    UIView *selectedSnapshot = nil;
    
    // now make snapshots and add them to containerView
    for (int i = 0; i < visibleCellIndexPaths.count; i++) {
        // take asnapshot, add it to the snapshot array
        CardingCell *cell = (CardingCell *)[fromViewController.collectionView cellForItemAtIndexPath:visibleCellIndexPaths[i]];
        UIView *snapshot = [cell snapshotViewAfterScreenUpdates:NO];
        
        // convert the frame of the cell to containerView coords
        CGRect newFrame = [containerView convertRect:cell.frame fromView:cell.superview];

        // check if this is the selected cell
        if (cell.indexPath.item == selectedIndexPath.item) {
            selectedSnapshot = toViewSnapshot; // maybe this is not needed
            [snapshots addObject:selectedSnapshot];
            // set its frame
            CGRect oldFrame = toViewController.view.frame;
            oldFrame.origin.y = newFrame.origin.y;
            newFrame.size.height = oldFrame.size.height;
            selectedSnapshot.frame = newFrame;
            // add to the containerView
            [containerView addSubview:selectedSnapshot];
            // set the proper drop shadow
            selectedSnapshot.layer.masksToBounds = NO;
            [selectedSnapshot.layer setShadowColor:[UIColor blackColor].CGColor];
            [selectedSnapshot.layer setShadowOpacity:0.6];
            [selectedSnapshot.layer setShadowRadius:5.0];
            [selectedSnapshot.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
            [selectedSnapshot.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
        } else {
            [snapshots addObject:snapshot];
            // set its frame
            snapshot.frame = newFrame;
            // add it to the container
            [containerView addSubview:snapshot];
            // set the drop-shadow
            snapshot.layer.masksToBounds = NO;
            [snapshot.layer setShadowColor:[UIColor blackColor].CGColor];
            [snapshot.layer setShadowOpacity:0.6];
            [snapshot.layer setShadowRadius:5.0];
            [snapshot.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
            [snapshot.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
        }
    }
    
    // hide the collection view before the animation
    fromViewController.collectionView.hidden = YES;
    
    // perform the animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // move all snapshots lower than the selected, to the bottom edge of the screen
        for (UIView *snapshot in snapshots)
        {
            if (snapshot.frame.origin.y > selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                CGRect frame = snapshot.frame;
                //frame.origin.y = [UIScreen mainScreen].bounds.size.height+20.0;
                frame.origin.y +=500.0;
                snapshot.frame = frame;
            } else if (snapshot.frame.origin.y < selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                // move the cells above the selected to the top edge
                CGRect frame = snapshot.frame;
                //frame.origin.y = 64.0;
                frame.origin.y += 500.0;
                snapshot.frame = frame;
            } else {
                // nothing to do if this is the selected item
                // as this is done outside this loop
            }
            
        }
        // Move the toViewController's view to the final position
        toViewSnapshot.frame = newVCFrame;
        
    } completion:^(BOOL finished) {
        NSLog(@"Animation completions block, finished: %@", finished ? @"YES" : @"NO");
        NSLog(@"Transition canceled: %@", [transitionContext transitionWasCancelled] ? @"YES": @"NO");
        
        // Clean up
        // unhide the collection view
        fromViewController.collectionView.hidden = NO;
        
        // remove the snapshots
        for (UIView *snapshot in snapshots)
        {
            if (snapshot != selectedSnapshot) {
                [snapshot removeFromSuperview];
            }
            
        }
        
        [toViewSnapshot removeFromSuperview];
        toViewController.view.hidden = NO;
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    //[super startInteractiveTransition:transitionContext];
    
}


#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //[super updateInteractiveTransition:percentComplete];
    
}

- (void)finishInteractiveTransition {
    NSLog(@"CardingTransitoinToSingleController finishInteractiveTransition");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    self.interactive = NO;
    
}

- (void)cancelInteractiveTransition {
    NSLog(@"CardingTransitoinToSingleController cancelInteractiveTransition");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    [transitionContext completeTransition:transitionContext.transitionWasCancelled];
    self.interactive = NO;
}



@end
