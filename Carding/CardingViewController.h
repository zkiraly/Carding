//
//  CardingViewController.h
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardingVCAncestor.h"

@interface CardingViewController : CardingVCAncestor <UINavigationControllerDelegate>

@property (nonatomic, retain) NSIndexPath* selectedIndexPath;

@end
