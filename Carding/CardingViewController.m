//
//  CardingViewController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingViewController.h"
#import "CardingCell.h"
#import "CardingModel.h"

@interface CardingViewController ()

@end

@implementation CardingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view.
    UINib *cellNib = [UINib nibWithNibName:@"CardingCellView" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CARDING_CELL"];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(320.0, 582.0);
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"CardingViewController numberOfSectionsInCollectionView");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"CardingViewController collectionView:numberOfItemsInSection: returning %lu", (unsigned long)[CardingModel sharedInstance].cards.count);
    
    
    return [CardingModel sharedInstance].cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"CardingViewController collectionView:cellForItemAtIndexPath: %@", indexPath);
    
    CardingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CARDING_CELL" forIndexPath:indexPath];
    
    cell.cardNumber.text = [[CardingModel sharedInstance].cards objectAtIndex:indexPath.item];
    
    return cell;
}



@end
