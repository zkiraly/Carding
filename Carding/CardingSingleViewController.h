//
//  CardingSingleViewController.h
//  Carding
//
//  Created by Zsolt Kiraly on 9/30/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardingSingleViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *cardNumber;
@property (nonatomic, retain) NSString *item;

@end
