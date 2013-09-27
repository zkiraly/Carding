//
//  CardingInitialLayout.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingInitialLayout.h"

@implementation CardingInitialLayout {
    NSMutableArray *_attributesArray;
}


- (void)prepareLayout {
    [super prepareLayout];
    
    self.minimumLineSpacing = 5;
    self.itemSize = CGSizeMake(320.0, 192.0);
    
    // We only display one section in this layout.
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc] initWithCapacity:itemCount];
    }
    
    CGFloat yPos = 0.0;
    
    for (NSInteger i = 0; i < itemCount; i ++) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGRect newFrame = CGRectMake(0.0, yPos, 320.0, 192.0);
        yPos += 72.0;
        
        attributes.frame = newFrame;
        //attributes.transform3D = CATransform3DMakeScale(0.96, 0.96, 0.96);
        //attributes.transform3D = CATransform3DRotate(attributes.transform3D, -15*3.14/180.0, 1.0, 0.0, 0.0);
        
        attributes.zIndex = itemCount;
        
        [_attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    //return CGSizeMake(320.0, 1500.0);
    return [super collectionViewContentSize];
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //return [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:_attributesArray.count];
    
    for (UICollectionViewLayoutAttributes *attrib in _attributesArray)
    {
        // preserve the correct z order (from SO)
        attrib.zIndex = attrib.indexPath.item + 1;
        // is it in the rect?
        if (CGRectIntersectsRect(rect, attrib.frame)) {
            
            NSLog(@"CardingInitialLayout layoutAttributesForElementsInRect:\nfor item %@ set zIndex to %lu", attrib.indexPath, attrib.zIndex);
            NSLog(@"hidden: %s", attrib.hidden ? "YES" : "NO");
            [returnArray addObject:attrib];
        }
    }
    
    return returnArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrib = [_attributesArray objectAtIndex:indexPath.item];
    
    // preserve the correct z order (from SO)
    attrib.transform3D = CATransform3DMakeTranslation(0, 0, attrib.indexPath.item);
    
    //attrib.zIndex = indexPath.item + 1;
    NSLog(@"CardingInitialLayout layoutAttributesForItemAtIndexPath:\nfor item %@ set zIndex to %lu", attrib.indexPath, attrib.zIndex);
    NSLog(@"hidden: %s", attrib.hidden ? "YES" : "NO");
    
    return attrib;
}

@end
