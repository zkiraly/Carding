//
//  CardingTransitionToListController.h
//  Carding
//
//  Created by Zsolt Kiraly on 10/1/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CardingSingleViewController;

@protocol CardingTransitionToListControllerDelegate <NSObject>
-(void)interactionBeganAtPoint:(CGPoint)p;
@end

@interface CardingTransitionToListController : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

- (id)initWithParentViewController:(CardingSingleViewController *)viewController;
- (void)userDidSwipe:(UISwipeGestureRecognizer *)recognizer;
- (void)userdidPan:(UIPanGestureRecognizer *)recognizer;

@property (nonatomic) id <CardingTransitionToListControllerDelegate> delegate;
@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) UINavigationControllerOperation navigationOperation;
@property (nonatomic) UICollectionView* collectionView;

@property (nonatomic, readonly) CardingSingleViewController *parentViewController;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@end
