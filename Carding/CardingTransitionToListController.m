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

@implementation CardingTransitionToListController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
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
    toViewController.collectionView.backgroundColor = [UIColor clearColor];
    
    UIColor *toViewBgColor = toViewController.view.backgroundColor;
    toViewController.view.backgroundColor = [UIColor clearColor];
    
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
        
        toViewController.collectionView.backgroundColor = collectionViewBgColor;
        toViewController.view.backgroundColor = toViewBgColor;
        
        // hide the from view
        fromViewController.view.hidden = YES;
        fromViewController.view.alpha = 0.0;

        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
