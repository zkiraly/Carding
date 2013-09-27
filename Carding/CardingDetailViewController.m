//
//  CardingDetailViewController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/27/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingDetailViewController.h"
#import "CardingCell.h"
#import "CardingModel.h"

@interface CardingDetailViewController ()

@end

@implementation CardingDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"CardingDetailViewController numberOfSectionsInCollectionView");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"CardingDetailViewController collectionView:numberOfItemsInSection: returning %lu", (unsigned long)[CardingModel sharedInstance].cards.count);
    
    return [CardingModel sharedInstance].cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"CardingDetailViewController collectionView:cellForItemAtIndexPath: %@", indexPath);
    
    CardingCell *cell = (CardingCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    cell.cardNumber.text = [[CardingModel sharedInstance].cards objectAtIndex:indexPath.item];
    
    cell.indexPath = indexPath;
    
    // the following should really be in the cell class, but so far I could not make it work that way
    
#if 1
    // background
    
    //UIColor *backgroundPattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]];
    // background
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    cell.selectedBackgroundView = bgView;
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = selectedBgView;
    
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    
    //cell.backgroundView.backgroundColor = backgroundColor;
    //cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    
    // drop shadow
    cell.layer.masksToBounds = NO;
    [cell.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.layer setShadowOpacity:0.6];
    [cell.layer setShadowRadius:5.0];
    [cell.layer setShadowOffset:CGSizeMake(0.0, -0.0)];
    [cell.layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
    
#endif
    
    return cell;
}


@end
