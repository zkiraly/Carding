//
//  CardingModel.h
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardingModel : NSObject

@property (nonatomic, retain) NSMutableArray *cards;

+ (CardingModel *)sharedInstance;

@end
