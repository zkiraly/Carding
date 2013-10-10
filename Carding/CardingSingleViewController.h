//
//  CardingSingleViewController.h
//  Carding
//
//  Created by Zsolt Kiraly on 9/30/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardingTransitionToListController.h"


@interface CardingSingleViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *cardNumber;
@property (nonatomic, retain) NSString *item;
@property (nonatomic, strong) CardingTransitionToListController *interactiveAnimatedPopTransition;


@end
