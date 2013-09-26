//
//  CardingModel.m
//  Carding
//
//  Created by Zsolt Kiraly on 9/26/13.
//  Copyright (c) 2013 resetBit. All rights reserved.
//

#import "CardingModel.h"

@implementation CardingModel
//@synthesize cards;

- (id)init {
    if (self = [super init]) {
        // perform initialization
        _cards = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4",
                                                  @"5", @"6", @"7",@"8", @"9",
                                                  @"10", @"11", @"12", @"13",
                                                  @"14", @"15", @"16", @"17",
                                                  @"18", @"19"]];
       
        return self;
    } else {
        return nil;
    }
}

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

@end
