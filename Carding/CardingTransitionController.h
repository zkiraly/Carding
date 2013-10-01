//
//  CardingTransitionController.h
//  Carding
//
//  Created by Zsolt Kiraly on 9/27/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardingTransitionControllerDelegate <NSObject>
-(void)interactionBeganAtPoint:(CGPoint)p;
@end

@interface CardingTransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic) id <CardingTransitionControllerDelegate> delegate;
@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) UINavigationControllerOperation navigationOperation;
@property (nonatomic) UICollectionView* collectionView;

-(instancetype)initWithCollectionView:(UICollectionView*)collectionView;

@end
