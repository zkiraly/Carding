//
//  CardingTransitionToListController.h
//  Carding
//
//  Created by Zsolt Kiraly on 10/1/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CardingTransitionToListControllerDelegate <NSObject>
-(void)interactionBeganAtPoint:(CGPoint)p;
@end

@interface CardingTransitionToListController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic) id <CardingTransitionToListControllerDelegate> delegate;
@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) UINavigationControllerOperation navigationOperation;
@property (nonatomic) UICollectionView* collectionView;

@end
