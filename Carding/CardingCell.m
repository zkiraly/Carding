//
//  CardingCell.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingCell.h"

@implementation CardingCell
//@synthesize cardNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // _cardNumber.text = @"00";
        
        // background
        
        UIColor *backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.png"]];
        //cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = backgroundColor;
        
        // drop shadow
        self.layer.masksToBounds = NO;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:1.0];
        [self.layer setShadowRadius:2.0];
        [self.layer setShadowOffset:CGSizeMake(0.0, -0.0)];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
