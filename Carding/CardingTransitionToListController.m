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
    id <UIViewControllerContextTransitioning> _transitionContext;
}

@end

@implementation CardingTransitionToListController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // save the context
    _transitionContext = transitionContext;
    
    CardingSingleViewController *fromViewController = (CardingSingleViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CardingViewController *toViewController = (CardingViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    toViewController.view.hidden = YES;
    
    // take snapshot of fromView
    UIView *fromSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    fromSnapshot.frame = [containerView convertRect:fromViewController.view.frame fromView:fromViewController.view.superview];
    // switch the fromView with the snapshot
    fromViewController.view.hidden = YES;
    fromViewController.view.alpha = 0.0;
    
    
    // get the selected item's path
    NSIndexPath *selectedIndexPath = toViewController.selectedIndexPath;
    
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
        fromSnapshot.frame = fromFrame;
        
    } completion:^(BOOL finished) {
        NSLog(@"CardingTransitionToListController animateTransition: in completion.");
        // remove the snapshots
        for (UIView *snapshot in snapshots) {
            [snapshot removeFromSuperview];
            
        }
        [fromSnapshot removeFromSuperview];
        
        // make the toView visible
        toViewController.view.hidden = NO;
        toViewController.view.alpha = 1.0;
        
        // Declare that we've finished
        [transitionContext completeTransition:YES];
    
    }];
    

}

- (void)animationEnded:(BOOL)transitionCompleted {
    NSLog(@"CardingTransitionToListController animationEnded: %@", transitionCompleted ? @"YES" : @"NO");
    
    CardingSingleViewController *fromViewController = (CardingSingleViewController*)[_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CardingViewController *toViewController = (CardingViewController*)[_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [_transitionContext containerView];
    
    if (!transitionCompleted) {
        for (UIView *view in containerView.subviews) {
            [view removeFromSuperview];
        }
        
        [containerView addSubview:fromViewController.view];
        fromViewController.view.alpha = 1.0;
        fromViewController.view.hidden = NO;
    }
    
    
}


- (void)animateTransition1:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    CardingSingleViewController *fromViewController = (CardingSingleViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CardingViewController *toViewController = (CardingViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // get the selected item's path
    NSIndexPath *selectedIndexPath = toViewController.selectedIndexPath;
    
    // we are popping the single view
    // we want the popped card to be the topmost one
    // so have the collection view scroll to the correct offset
    // and then have it slide over the snapshot of the popped card
    // with the cell corresponding to the popped card invisible
    
    // Setup the view states
    CGRect containerFrame = containerView.frame;
    
    CGRect finalToFrame = toViewController.view.frame;
    finalToFrame.origin.y += 64.0;
    
    // add the "to" view
    // we can't take a snapshot of this view, as it's not been rendered.
    // so this view will be animated directly
    [containerView addSubview:toViewController.view];
    
    // get the selected cell invisible
    UICollectionViewCell *selectedCell = [toViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    // get its frame
    CGRect selectedCellFrame = selectedCell.frame;
    // make it invisible
    selectedCell.alpha = 0.0;
    //selectedCell.hidden = YES;
    UIColor *collectionViewBgColor = toViewController.collectionView.backgroundColor;
    //toViewController.collectionView.backgroundColor = [UIColor clearColor];
    
    UIColor *toViewBgColor = toViewController.view.backgroundColor;
    //toViewController.view.backgroundColor = [UIColor clearColor];
    
    // set the collectionview offset
    toViewController.collectionView.contentOffset = selectedCellFrame.origin;
    
    // move the collection view down to the starting position
    CGRect startingToFrame = finalToFrame;
    startingToFrame.origin.y = finalToFrame.size.height;
    toViewController.view.frame = startingToFrame;
    
    // now we can animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // move the collectionview to the final position
        toViewController.view.frame = finalToFrame;
        
    } completion:^(BOOL finished) {
        // Clean up
        // unhide the selected cell
        selectedCell.hidden = NO;
        selectedCell.alpha = 1.0;
        
        //toViewController.collectionView.backgroundColor = collectionViewBgColor;
        //toViewController.view.backgroundColor = toViewBgColor;
        
        // hide the from view
        fromViewController.view.hidden = YES;
        fromViewController.view.alpha = 0.0;

        // Declare that we've finished
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
