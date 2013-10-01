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
    //UIView *collectionView = fromViewController.collectionView;
    
    // Setup the initial view states
    CGRect newVCFrame = [transitionContext finalFrameForViewController:toViewController];
    //newVCFrame.size.height = 192.0 + 64.0;
    newVCFrame.origin.y = 64.0;
    
    //toViewController.view.frame = newVCFrame;
    [containerView addSubview:toViewController.view];
    //UIView *toControllerSnapshot = [toViewController.view snapshotViewAfterScreenUpdates:NO];
    
    //toViewController.view.alpha = 0;
    //toViewController.view.hidden = YES;
#if 0
    UIGraphicsBeginImageContextWithOptions(toViewController.view.bounds.size, toViewController.view.opaque, [[UIScreen mainScreen] scale]);
    [toViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *toControllerSnapshot = [[UIImageView alloc] initWithImage:image];
#endif
    // Get a snapshot of the thing cell we're transitioning from
    NSIndexPath *selectedIndexPath = [[fromViewController.collectionView indexPathsForSelectedItems] firstObject];
    //CardingCell *selectedCell = (CardingCell*)[fromViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    //UIView *cellImageSnapshot = [selectedCell snapshotViewAfterScreenUpdates:NO];
    //cellImageSnapshot.frame = [collectionView convertRect:selectedCell.frame fromView:selectedCell.superview];
    
    NSMutableArray *visibleCellIndexPaths = [[fromViewController.collectionView indexPathsForVisibleItems] mutableCopy];
    NSMutableArray *snapshots = [[NSMutableArray alloc] initWithCapacity:visibleCellIndexPaths.count];
    
    // sort the index paths by item
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
    //UIView *toControllerSnapshot = [toViewController.view snapshotViewAfterScreenUpdates:NO];
    
    // now make snapshots and add them to containerView
    for (int i = 0; i < visibleCellIndexPaths.count; i++) {
        // take asnapshot, add it to the snapshot array
        CardingCell *cell = (CardingCell *)[fromViewController.collectionView cellForItemAtIndexPath:visibleCellIndexPaths[i]];
        UIView *snapshot = [cell snapshotViewAfterScreenUpdates:NO];
        
        CGRect newFrame = [containerView convertRect:cell.frame fromView:cell.superview];

        // check if this is the selected cell
        
        if (cell.indexPath.item == selectedIndexPath.item) {
            selectedSnapshot = toViewController.view;
            [snapshots addObject:selectedSnapshot];
            // set its frame
            CGRect oldFrame = toViewController.view.frame;
            oldFrame.origin.y = newFrame.origin.y;
            selectedSnapshot.frame = newFrame;
            [containerView addSubview:selectedSnapshot];
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
        }
        
        
        // set its frame
        //snapshot.frame = [containerView convertRect:cell.frame fromView:cell.superview];
        // drop shadow
        snapshot.layer.masksToBounds = NO;
        [snapshot.layer setShadowColor:[UIColor blackColor].CGColor];
        [snapshot.layer setShadowOpacity:0.6];
        [snapshot.layer setShadowRadius:5.0];
        [snapshot.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
        [snapshot.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
        
        
    }
    
    //cell.hidden = YES;
    fromViewController.collectionView.hidden = YES;
    
    
    //[collectionView addSubview:cellImageSnapshot];
    //cellImageSnapshot.layer.zPosition = indexPath.item;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // Fade in the second view controller's view
        toViewController.view.alpha = 1.0;
        
        
        
        // move all snapshots lower than the selected, to the bottom edge of the screen
        for (UIView *snapshot in snapshots)
        {
            if (snapshot.frame.origin.y > selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                CGRect frame = snapshot.frame;
                frame.origin.y = [UIScreen mainScreen].bounds.size.height+20.0;
                snapshot.frame = frame;
            }
#if 1
            else if (snapshot.frame.origin.y < selectedSnapshot.frame.origin.y && snapshot != selectedSnapshot) {
                CGRect frame = snapshot.frame;
                //frame.origin.y = [UIScreen mainScreen].bounds.size.height / 2.0 - 100.0;
                frame.origin.y = 64.0;
                snapshot.frame = frame;
            } else {
                // it is the toViewController view
                //toViewController.view.frame = newVCFrame;
            }
#endif
            //toViewController.view.frame = newVCFrame;
            
        }
        // Move the cell snapshot so it's over the second view controller's image view
        CGRect frame = [containerView convertRect:toViewController.view.frame fromView:toViewController.view];

        toViewController.view.frame = newVCFrame;
        
    } completion:^(BOOL finished) {
        // Clean up
        toViewController.view.hidden = NO;
        //cell.hidden = NO;
        fromViewController.collectionView.hidden = NO;
        //[cellImageSnapshot removeFromSuperview];
        
        // remove the snapshots
        for (UIView *snapshot in snapshots)
        {
            if (snapshot != selectedSnapshot) {
                [snapshot removeFromSuperview];
            }
            
        }
        //[toControllerSnapshot removeFromSuperview];
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end
