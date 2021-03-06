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
#import "CardingModel.h"

@interface CardingTransitionToSingleController() {
    
}

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIView *detailViewSnapshot;
@property (nonatomic, assign) CGRect finalFrame;

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
    //static UIView *cardToPan = nil;
    static CGPoint offset;
    static CGPoint startingFrameOrigin;
    static CGPoint startingTouch;
    CGPoint touch = [recognizer locationInView:_parentViewController.collectionView];
    CGFloat progress;
    NSLog(@"CardingTransitionToSingleController handlePushRecognizer");
    
    CGPoint location = [recognizer locationInView:self.parentViewController.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"got UIGestureRecognizerStateBegan");

        // We're being invoked via a gesture recognizer – we are necessarily interactive
        self.interactive = YES;
        // start the transition
        // get distance to the top
        startingDistanceToTop = location.y;
        startingTouch = location;
        
        // get the cell index path under that touch
        CGPoint collectionViewLocation = [_parentViewController.collectionView convertPoint:location fromView:_parentViewController.view];
        NSIndexPath *indexPath = [_parentViewController.collectionView indexPathForItemAtPoint:collectionViewLocation];
        UICollectionViewCell *cell = [_parentViewController.collectionView cellForItemAtIndexPath:indexPath];
        offset = [recognizer locationInView:cell];
        CGPoint startingFrameOriginInCollectionView = [_parentViewController.collectionView cellForItemAtIndexPath:indexPath].frame.origin;
        startingFrameOrigin = [_parentViewController.view convertPoint:startingFrameOriginInCollectionView fromView:_parentViewController.collectionView];
        NSLog(@"offset x: %f, y: %f", offset.x, offset.y);
        [_parentViewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        // now initiate the push
        [_parentViewController collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"got UIGestureRecognizerStateChanged");
        // Update the interactive transition's progress
        progress = -1*(location.y - startingTouch.y) / startingDistanceToTop;
        progress = MIN(1.0, MAX(0.0, progress));
        CGPoint touchInContainerView = [_parentViewController.view convertPoint:touch fromView:_parentViewController.collectionView];
        
        NSLog(@"touches x: %f y: %f progress: %f", touchInContainerView.x, touchInContainerView.y, progress);
        
        // get the UIView we need to drag
        CGRect viewFrame = _detailViewSnapshot.frame;
        viewFrame.origin.y = touchInContainerView.y - offset.y;//+64.0;
        viewFrame.origin.y = MAX(64.0f, viewFrame.origin.y);
        NSLog(@"Progress: %f, newframe location: %f", progress, viewFrame.origin.y);
        // repositino the view we are dragging
        _detailViewSnapshot.frame = viewFrame;

        [self updateInteractiveTransition:progress];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Depending on our state and the velocity, determine whether to cancel or complete the transition.
        NSLog(@"got UIGestureRecognizerStateEnded");
        
        // Finish or cancel the interactive transition
        progress = -1*(location.y - startingTouch.y) / startingDistanceToTop;
        progress = MIN(1.0, MAX(0.0, progress));
        
        NSLog(@"touches x: %f y: %f progress: %f", touch.x, touch.y, progress);
        
        if (progress > 0.25) {
            [self finishInteractiveTransition];
            // get the UIView we need to drag
            CGRect viewFrame = _detailViewSnapshot.frame;
            viewFrame.origin.y = 0.0;
            // animate
            [UIView animateWithDuration:[self duration]*(1.0-progress) animations:^{
                _detailViewSnapshot.frame = _finalFrame;
            }];
        }
        else {
            NSLog(@"Cancelling the interactive transition");
            // remove the views used for animation, and restore the collection view
            
            
            // get the UIView we need to drag
            CGRect viewFrame = _detailViewSnapshot.frame;
            viewFrame.origin.y = startingFrameOrigin.y;
            // animate
            [UIView animateWithDuration:[self duration]*progress animations:^{
                _detailViewSnapshot.frame = viewFrame;
            }];
            
            [self cancelInteractiveTransition];
            
        }
        _interactive = NO;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (void)animationEnded:(BOOL)transitionCompleted {
    // Reset to our default state
    self.interactive = NO;
    self.transitionContext = nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if(self.interactive) {
        return 0.3f;
    } else {
        return 0.5f;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"CardingTransitionToSingleController animateTransition:");
    
#if 1
    CardingViewController *fromViewController = (CardingViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
#else
    UINavigationController *navController = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CardingViewController *fromViewController = (CardingViewController *)[navController.viewControllers objectAtIndex:0];
#endif
    
    CardingSingleViewController *toViewController = (CardingSingleViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // Setup the final view states
    CGRect newVCFrame = [transitionContext finalFrameForViewController:toViewController];
    newVCFrame.origin.y = 64.0;
    _finalFrame = newVCFrame;
    
    // add the "to" view
    // get a snapshot using off-screen rendering
    UIGraphicsBeginImageContext(toViewController.view.bounds.size);
    [toViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    UIImageView *toViewSnapshot = [[UIImageView alloc] initWithImage:viewImage];
    toViewSnapshot.tag = 101101;
    _detailViewSnapshot = toViewSnapshot;
    
    toViewController.view.hidden = YES;
    [containerView addSubview:toViewController.view];
    
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
    
    if(self.interactive) {
        
    }
    
    long animationOptions = UIViewAnimationOptionCurveEaseInOut;
    // perform the animation
    if (self.interactive) {
        animationOptions = UIViewAnimationOptionCurveEaseOut;
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:animationOptions animations:^{
        // move all snapshots lower than the selected, to the bottom edge of the screen
        for (UIView *snapshot in snapshots)
        {
            if (snapshot.frame.origin.y > selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                CGRect frame = snapshot.frame;
                frame.origin.y +=500.0;
                snapshot.frame = frame;
            } else if (snapshot.frame.origin.y < selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                // move the cells above the selected to the top edge
                CGRect frame = snapshot.frame;
                frame.origin.y += 500.0;
                snapshot.frame = frame;
            } else {
                // nothing to do if this is the selected item
                // as this is done outside this loop
            }
            
        }
        // Move the toViewController's view to the final position
        if (!self.interactive) {
            toViewSnapshot.frame = newVCFrame;
        }
        
        
    } completion:^(BOOL finished) {
        NSLog(@"Animation completions block, finished: %@", finished ? @"YES" : @"NO");
        NSLog(@"Transition canceled: %@", [transitionContext transitionWasCancelled] ? @"YES": @"NO");

        if ([transitionContext transitionWasCancelled]) {
            NSLog(@"Completion block: transition cancelled");
            // Clean up
            // unhide the collection view
            fromViewController.collectionView.hidden = NO;
            fromViewController.collectionView.alpha = 1.0;
            [toViewController.view removeFromSuperview];
            [transitionContext completeTransition:NO];

        } else {
            NSLog(@"Completion block: transition completed");
            toViewController.view.hidden = NO;
            toViewController.view.alpha = 1.0;
            fromViewController.collectionView.hidden = NO;
            fromViewController.collectionView.alpha = 1.0;
            fromViewController.view.hidden = NO;
            fromViewController.view.alpha = 1.0;
            [transitionContext completeTransition:YES];
        }
        
        
        // remove the snapshots
        for (UIView *snapshot in snapshots)
        {
            if (snapshot != selectedSnapshot) {
                [snapshot removeFromSuperview];
            }
            
        }
       
        [toViewSnapshot removeFromSuperview];
    }];

    
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];
    NSLog(@"UIViewControllerInteractiveTransitioning startInteractiveTransition:");
    
    self.transitionContext = transitionContext;
}


#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    NSLog(@"UIViewControllerInteractiveTransitioning updateInteractiveTransition:");
    
    [super updateInteractiveTransition:percentComplete];
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    [transitionContext updateInteractiveTransition:percentComplete];
    
}

- (void)finishInteractiveTransition {
    NSLog(@"UIViewControllerInteractiveTransitioning finishInteractiveTransition");
    
    [super finishInteractiveTransition];
    
    NSLog(@"CardingTransitoinToSingleController finishInteractiveTransition");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    self.interactive = NO;
    [transitionContext finishInteractiveTransition];
    
}

- (void)cancelInteractiveTransition {
    NSLog(@"UIViewControllerInteractiveTransitioning cancelInteractiveTransition");
    [super cancelInteractiveTransition];
    
    NSLog(@"CardingTransitoinToSingleController cancelInteractiveTransition");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    [transitionContext cancelInteractiveTransition];
    self.interactive = NO;
}



@end
