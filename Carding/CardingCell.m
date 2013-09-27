//
//  CardingCell.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation CardingCell
//@synthesize cardNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // _cardNumber.text = @"00";
        
        // background
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        self.selectedBackgroundView = bgView;
        
        UIView *selectedBgView = [[UIView alloc] initWithFrame:frame];
        selectedBgView.backgroundColor = [UIColor grayColor];
        self.selectedBackgroundView = selectedBgView;
        
        // drop shadow
        self.layer.masksToBounds = NO;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.6];
        [self.layer setShadowRadius:5.0];
        [self.layer setShadowOffset:CGSizeMake(0.0, -0.0)];

    }
    return self;
}

- (void)prepareForReuse {
    NSLog(@"CardingCell prepareForReuse");
    [super prepareForReuse];
    
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
