//
//  CardingTransitionController.h
//  Carding
//
//  Created by Zsolt Kiraly on 9/27/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardingTransitionToSingleControllerDelegate <NSObject>
-(void)interactionBeganAtPoint:(CGPoint)p;
@end

@interface CardingTransitionToSingleController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic) id <CardingTransitionToSingleControllerDelegate> delegate;
@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) UINavigationControllerOperation navigationOperation;
@property (nonatomic) UICollectionView* collectionView;

@end
