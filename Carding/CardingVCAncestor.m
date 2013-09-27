//
//  CardingVCAncestor.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/27/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingVCAncestor.h"
#import "CardingCell.h"

@interface CardingVCAncestor ()

@end

@implementation CardingVCAncestor

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // The view for the cell is in a nib (xib) file, not in the main storyboard
    UINib *cellNib = [UINib nibWithNibName:@"CardingCellView" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CARDING_CELL"];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"CardingViewController collectionView:cellForItemAtIndexPath: %@", indexPath);
    
    CardingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CARDING_CELL" forIndexPath:indexPath];
    
    return cell;
}

@end
