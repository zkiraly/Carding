//
//  CardingViewController.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingViewController.h"
#import "CardingDetailViewController.h"
#import "CardingDetailLayout.h"
#import "CardingSingleViewController.h"
#import "CardingCell.h"
#import "CardingModel.h"

@interface CardingViewController (){
    NSInteger _selectedIndex;
}
@end

@implementation CardingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Cards";

}

- (void)viewWillAppear:(BOOL)animated {
    //[self.collectionView reloadData];
    //[self.collectionViewLayout invalidateLayout];
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
    
    CardingCell *cell = (CardingCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    cell.cardNumber.text = [[CardingModel sharedInstance].cards objectAtIndex:indexPath.item];
    
    cell.indexPath = indexPath;
    
    // the following should really be in the cell class, but so far I could not make it work that way
    
#if 1
    // background
    
    //UIColor *backgroundPattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]];
    // background
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    //cell.backgroundView = bgView;
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBgView.backgroundColor = [UIColor grayColor];
    //cell.selectedBackgroundView = selectedBgView;
    
    //cell.backgroundView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"CardingViewController prepareForSegue:sender:");
    
    if ([segue.destinationViewController isKindOfClass:[CardingSingleViewController class]]) {
        // Get the selected item index path
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        
        // Set the thing on the view controller we're about to show
        if (selectedIndexPath != nil) {
            CardingSingleViewController *secondViewController = (CardingSingleViewController *)segue.destinationViewController;
            secondViewController.item = [NSString stringWithFormat:@"%2d", selectedIndexPath.item];;
        }
    }
}



#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CardingViewController collectionView:disSelectItemAtIndexPath");
    [self performSegueWithIdentifier:@"CELL_TO_DETAIL_SEGUE" sender:self];
}

@end
