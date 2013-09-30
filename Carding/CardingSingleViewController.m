//
//  CardingSingleViewController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/30/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingSingleViewController.h"

@interface CardingSingleViewController ()

@end

@implementation CardingSingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.cardNumber.text = self.item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
