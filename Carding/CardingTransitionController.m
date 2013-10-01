//
//  CardingTransitionController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/27/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardingTransitionController.h"
#import "CardingViewController.h"
#import "CardingSingleViewController.h"
#import "CardingCell.h"



@implementation CardingTransitionController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    CardingViewController *fromViewController = (CardingViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CardingSingleViewController *toViewController = (CardingSingleViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // Setup the final view states
    CGRect newVCFrame = [transitionContext finalFrameForViewController:toViewController];
    newVCFrame.origin.y = 64.0;
    
    // add the "to" view
    // we can't take a snapshot of this view, as it's not been rendered.
    // so this view will be animated directly
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
            selectedSnapshot = toViewController.view; // maybe this is not needed
            [snapshots addObject:selectedSnapshot];
            // set its frame
            CGRect oldFrame = toViewController.view.frame;
            oldFrame.origin.y = newFrame.origin.y;
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
                frame.origin.y = [UIScreen mainScreen].bounds.size.height+20.0;
                snapshot.frame = frame;
            } else if (snapshot.frame.origin.y < selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                // move the cells above the selected to the top edge
                CGRect frame = snapshot.frame;
                frame.origin.y = 64.0;
                snapshot.frame = frame;
            } else {
                // nothing to do if this is the selected item
                // as this is done outside this loop
            }
            
        }
        // Move the toViewController's view to the final position
        toViewController.view.frame = newVCFrame;
        
    } completion:^(BOOL finished) {
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
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end
