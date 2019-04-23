//
//  Card.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize rank;
@synthesize suit;
@synthesize ranks;
@synthesize suits;
@synthesize cardString;
@synthesize usedInHand;
@synthesize dealtCard;

-(id)init{
    self = [super init];
	if (self != nil) {
        self.ranks = [NSArray arrayWithObjects:@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"T", @"J", @"Q", @"K", @"A", nil];
        self.suits = [NSArray arrayWithObjects:@"D",@"C",@"H",@"S",nil];
    }
    return self;
}

-(id)initWithCard:(NSString *)cardStr{
    self = [self init];
    self.cardString = cardStr;
    if (self != nil) {
        NSString *rankStr = [cardStr substringToIndex:1];
        NSString *suitStr = [cardStr substringFromIndex:1];
        
        rank = -1;
        for (int i = 0; i < [ranks count]; i++) {
            if ([rankStr isEqualToString:[ranks objectAtIndex:i]] ) {
                self.rank = i;
                break;
            }
        }
        
        suit = -1;
        for (int i = 0; i < [suits count]; i++) {
            if ([suitStr isEqualToString:[suits objectAtIndex:i]] ) {
                self.suit = i;
                break;
            }
        }
    }
    return self;
    
}

- (NSComparisonResult)compare:(Card *)otherObject {
    if(self.cardValue > otherObject.cardValue){
        return NSOrderedAscending;
    }else if(self.cardValue < otherObject.cardValue){
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

-(int)cardValue{
    return rank * NO_OF_SUITS + suit;
}






@end
