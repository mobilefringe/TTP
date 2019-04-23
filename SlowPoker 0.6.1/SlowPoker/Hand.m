//
//  Hand.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Hand.h"
#import "Card.h"

@implementation Hand

@synthesize cards;
@synthesize value;
@synthesize type;
@synthesize userID;
@synthesize userName;
@synthesize processed;
@synthesize straightRanks;
@synthesize flushRanks;
@synthesize typeValues;


-(id)initWithCards:(NSMutableArray *)cardStrings{
    
    straightRank = -1;
    quadRank = -1;
    tripleRank = -1;
    flushSuit = -1;
    flushRank = -1;
    straightFlushRank = -1;
    
    wheelingAce = NO;
    int  RANKING_FACTORS[]  = {371293, 28561, 2197, 169, 13, 1};
    self = [super init];
	if (self != nil) {
        self.cards = [[NSMutableArray alloc] init];
        for (NSString *cardStr in cardStrings) {
            Card *card = [[Card alloc] initWithCard:cardStr];
            [cards addObject:card];
        }
    }
    
    cards =  [NSMutableArray arrayWithArray:[cards sortedArrayUsingSelector:@selector(compare:)]];
    self.straightRanks = [[NSMutableArray alloc] init];
    self.flushRanks = [[NSMutableArray alloc] init];
    
    [self calculateDistributions];
    [self findStraight];
    [self findFlush];
    [self findDuplicates];
   
    
    // Find special values.
    BOOL isSpecialValue =
    ([self isStraightFlush] ||
     [self isFourOfAKind]   ||
     [self isFullHouse]    ||
     [self isFlush]         ||
     [self isStraight]      ||
     [self isThreeOfAKind]  ||
     [self isTwoPairs]      ||
     [self isOnePair]);
    if (!isSpecialValue) {
        [self calculateHighCard];
    }
    
    // Calculate value.
    for (int i = 0; i < NO_OF_RANKINGS; i++) {
        value += rankings[i] * RANKING_FACTORS[i];
    }
    
    
    
    //[self logHand];
    return self;
}

-(void)calculateDistributions{
    for (Card *card in cards) {
        rankDist[card.rank]++;
        suitDist[card.suit]++;
    }
    /*
    for(int i = 0; i < NO_OF_RANKS;i++){
         NSLog(@"rankDist %d:%d",i,rankDist[i]);
    }
    for(int i = 0; i < NO_OF_SUITS;i++){
        NSLog(@"suitDist %d:%d",i,suitDist[i]);
    }*/
}

-(void)findStraight{
    BOOL inStraight = NO;
    int rank = -1;
    int count = 0;
    int continuousCount = 0;
    for (int i = NO_OF_RANKS -1; i >= 0; i--) {
        if (rankDist[i] == 0) {
            inStraight = NO;
            count = 0;
        } else {
            if (!inStraight) {
                // First card of the potential Straight.
                inStraight = true;
                rank = i;
            }
            count++;
            if (count >= 5) {
                // Found a Straight!
                straightRank = rank;
                [straightRanks addObject:[NSNumber numberWithInt:straightRank-continuousCount]];
                continuousCount++;
            }
        }
    }
    // Special case for the 'Steel Wheel' (Five-high Straight with a 'wheeling Ace') .
    if ((count == 4) && (rank == FIVE) && (rankDist[ACE] > 0)) {
        wheelingAce = YES;
        straightRank = rank;
    }
}

-(void)findFlush{
    for (int i = NO_OF_SUITS -1; i >= 0; i--) {
        int multiCardFlush = 0;
        if (suitDist[i] >= 5) {
            multiCardFlush = (suitDist[i] - 5)+1;
            flushSuit = i;
            for (Card *card in cards) {
                if (card.suit == flushSuit && multiCardFlush > 0) {
                    if (!wheelingAce || card.rank != ACE) {
                        flushRank = card.rank;
                        [flushRanks addObject:[NSNumber numberWithInt:flushRank]];
                        multiCardFlush--;
                    }
                }
            }
            break;
        }
    }
    
}

-(void)findDuplicates{
    for (int i = NO_OF_RANKS - 1; i >= 0 ; i--) {
        if (rankDist[i] == 4) {
            quadRank = i;
        } else if (rankDist[i] == 3) {
            noOfTripples++;
            if(i > tripleRank){
                tripleRank = i;
            }else{
                pairs[noOfPairs++] = i;
            }
        } else if (rankDist[i] == 2) {
            if (noOfPairs < MAX_NO_OF_PAIRS) {
                pairs[noOfPairs++] = i;
            }
        }
    }
}

-(void)calculateHighCard{
    type = @"HIGH_CARD";
    rankings[0] = 0;
    // Get the five highest ranks.
    int index = 1;
    for (Card *card in cards) {
        rankings[index++] = card.rank;
        if (index > 5) {
            break;
        }
    }
    
    int usedCardsinHand = 5;

    for (Card *card in cards) {
        if (usedCardsinHand > 0) {
            card.usedInHand = YES;
            usedCardsinHand--;
            
        }
    }

}

-(BOOL)isStraightFlush{
    
    for (NSNumber *straightRankNum in straightRanks) {
        //NSLog(@"straightRankNum:%@",straightRankNum);
        for (NSNumber *flushRankNum in flushRanks) {
            //NSLog(@"flushRankNum:%@",flushRankNum);
            if([straightRankNum intValue] == [flushRankNum intValue]){
                straightFlushRank = [straightRankNum intValue]; 
            }
        }
    }
        
    
    
    
    if (straightFlushRank != -1) {
        // Flush and Straight (possibly separate); check for Straight Flush.
        int straightRank2 = -1;
        int lastSuit = -1;
        int lastRank = -1;
        int inStraight = 1;
        int inFlush = 1;
        for (Card *card in cards) {
            
            int rank = card.rank;
            int suit = card.suit;
            int rankDiff = lastRank - rank;
            if(rank == straightFlushRank && suit == flushSuit){
                card.usedInHand = YES;
            }
            //NSLog(@"rank:%d  suite:%d",card.rank,card.suit);
            if (lastRank != -1) {
                
                if (rankDiff == 1) {
                    // Consecutive rank; possible straight!
                    
                    inStraight++;
                    if (straightRank2 == -1) {
                        straightRank2 = lastRank;
                    }
                    if (suit == lastSuit) {
                        inFlush++;
                        card.usedInHand = YES;
                    } else {
                        inFlush = 1;
                    }
                    if (inStraight >= 5 && inFlush >= 5) {
                        // Straight!
                        break;
                    }
                } else if (rankDiff == 0) {
                    card.usedInHand = NO;
                    // Duplicate rank; skip.
                } else {
                    // Non-consecutive; reset.
                    straightRank2 = -1;
                    inStraight = 1;
                    inFlush = 1;
                    
                }
            }
            if(rankDiff != 0){
                lastRank = rank;
                lastSuit = suit;
            }
        }
        
        if (inStraight >= 5 && inFlush >= 5) {
            if (straightFlushRank == ACE) {
                // Royal Flush.
                type = @"ROYAL_FLUSH";
                rankings[0] = 9;
                return true;
            } else {
                // Straight Flush.
                type = @"STRAIGHT_FLUSH";
                rankings[0] = 8;
                rankings[1] = straightRank2;
                return true;
            }
        } else if (wheelingAce && inStraight >= 4 && inFlush >= 4) {
            // Steel Wheel (Straight Flush with wheeling Ace).
            type = @"STRAIGHT_FLUSH";
            rankings[0] = 8;
            rankings[1] = straightRank2;
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

-(BOOL)isFourOfAKind{
    if (quadRank != -1) {
        type = @"FOUR_OF_A_KIND";
        rankings[0] = 7;
        rankings[1] = quadRank;
        // Get the remaining card as kicker.
        int index = 2;
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank != quadRank) {
                if(index == 2){
                    rankings[index++] = rank;
                    card.usedInHand = YES;
                }
            }else{
                card.usedInHand = YES;
            }
        }
        return true;
    } else {
        return false;
    }
}

-(BOOL)isFullHouse{
    if ((tripleRank != -1) && ( (noOfPairs > 0) || noOfTripples > 1)) {
        type = @"FULL_HOUSE";
        rankings[0] = 6;
        rankings[1] = tripleRank;
        rankings[2] = pairs[0];
        int usedCardsinHand = 5;
        for (Card *card in cards) {
            for (int i = NO_OF_RANKS - 1; i >= 0 ; i--) {
                if (rankDist[i] == 3 && i == card.rank && usedCardsinHand > 0) {
                    card.usedInHand = YES;
                    usedCardsinHand--;
                } else if (rankDist[i] == 2  && i == card.rank && usedCardsinHand > 0) {
                    card.usedInHand = YES;
                    usedCardsinHand--;
                }
            }
        }
        
        return true;
    } else {
        return false;
    }
}

-(BOOL)isFlush{
    if (flushSuit != -1) {
        type = @"FLUSH";
        rankings[0] = 5;
        int index = 1;
        for (Card *card in cards) {
            if (card.suit == flushSuit) {
                int rank = card.rank;
                if (index == 1) {
                    flushRank = rank;
                }
                rankings[index++] = rank;
                card.usedInHand = YES;
                if (index > 5) {
                    // We don't need more kickers.
                    break;
                }
            }
        }
        return true;
    } else {
        return false;
    }
}

-(BOOL)isStraight{
    if([straightRanks count] == 0){
        return false;
    }
    straightRank = [[straightRanks objectAtIndex:0] intValue];
    if (straightRank != -1) {
        type = @"STRAIGHT";
        rankings[0] = 4;
        rankings[1] = straightRank;
        
        int usedCardsinHand = 5;
        int userRank = straightRank;
        for (Card *card in cards) {
            if (userRank == card.rank && usedCardsinHand > 0) {
                card.usedInHand = YES;
                usedCardsinHand--;
                userRank--;
            }
        }
        
        
        return true;
    } else {
        return false;
    }
}

-(BOOL)isThreeOfAKind{
    if (tripleRank != -1) {
        type = @"THREE_OF_A_KIND";
        rankings[0] = 3;
        rankings[1] = tripleRank;
        // Get the remaining two cards as kickers.
        int index = 2;
        int usedCardsinHand = 5;
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank != tripleRank) {
                
                rankings[index++] = rank;
                if (index > 3) {
                    // We don't need any more kickers.
                    break;
                }
            }else{
                card.usedInHand = YES;
                usedCardsinHand--;
            }
        }
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank != tripleRank) {
                if (usedCardsinHand > 0) {
                    card.usedInHand = YES;
                    usedCardsinHand--;
                }
            }
        }
        return true;
    } else {
        return false;
    }
}

-(BOOL)isTwoPairs{
    if (noOfPairs == 2) {
        type = @"TWO_PAIRS";
        rankings[0] = 2;
        // Get the value of the high and low pairs.
        int highRank = pairs[0];
        int lowRank  = pairs[1];
        rankings[1] = highRank;
        rankings[2] = lowRank;
        // Get the kicker card.
        for (Card *card in cards) {
            int rank = card.rank;
            if ((rank != highRank) && (rank != lowRank)) {
                rankings[3] = rank;
                break;
            }
        }
        
        
        int usedCardsinHand = 5;
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank == highRank) {
                card.usedInHand = YES;
                usedCardsinHand--;
            }else if(rank == lowRank){
                card.usedInHand = YES;
                usedCardsinHand--;
            }
        }
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank != highRank && rank != lowRank) {
                if (usedCardsinHand > 0) {
                    card.usedInHand = YES;
                    usedCardsinHand--;
                }
            }
        }
        
        return true;
    } else {
        return false;
    }
}

-(BOOL)isOnePair{
    if (noOfPairs == 1) {
        type = @"ONE_PAIR";
        rankings[0] = 1;
        // Get the rank of the pair.
        int pairRank = pairs[0];
        rankings[1] = pairRank;
        // Get the three kickers.
        int index = 2;
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank != pairRank) {
                rankings[index++] = rank;
                if (index > 4) {
                    // We don't need any more kickers.
                    break;
                }
            }
        }
        
        int usedCardsinHand = 5;
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank == pairRank) {
                card.usedInHand = YES;
                usedCardsinHand--;
            }
        }
        for (Card *card in cards) {
            int rank = card.rank;
            if (rank != pairRank) {
                if (usedCardsinHand > 0) {
                    card.usedInHand = YES;
                    usedCardsinHand--;
                }
            }
        }
        
        
        return true;
    } else {
        return false;
    }
}

-(void)resetHand{
    [cards removeAllObjects];
}

-(void)addCard:(Card *)card{
    [cards addObject:card];
}

-(NSMutableArray *)getUsedInHandCards{
    NSMutableArray *usedInHandCards = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (Card *card in cards) {
        if (card.usedInHand) {
            [usedInHandCards addObject:[card cardString]];
        }
    }
    return usedInHandCards;
    
}

-(NSMutableDictionary *)getHandDetails{
    NSMutableDictionary *handDetails = [[NSMutableDictionary alloc] init];
    [handDetails setValue:[NSString stringWithFormat:@"%d",flushSuit] forKey:@"flushSuit"];
    if(flushRank > -1){
        [handDetails setValue:[NSString stringWithFormat:@"%d",flushRank] forKey:@"flushRank"];
    }else if(straightFlushRank > -1){
        [handDetails setValue:[NSString stringWithFormat:@"%d",straightFlushRank] forKey:@"flushRank"];
    }
    NSMutableArray *rankingArray = [[NSMutableArray alloc] init];
    int count = 0;
    for (int i = 1; i < NO_OF_RANKS ; i++) {
        if(rankings[i] > 0){
            [rankingArray addObject:[NSString stringWithFormat:@"%d",rankings[i]]];
            count++;
        }
    }
    
    for (int i = count; i < 5 ; i++) {
        //to prevent out of bounds in hand summary view
        [rankingArray addObject:@""];
        
    }
    
    [handDetails setValue:rankingArray forKey:@"rankings"];
    return handDetails;
}

-(void)logHand{
    NSLog(@"Type:%@",type);
    NSLog(@"Value:%d",value);
    NSString *cardString = @"Cards:[ ";
    for (Card *card in cards) {
        cardString =[cardString stringByAppendingFormat:@"(%@ %d|%d|%d) ",card.cardString,card.rank,card.suit,card.usedInHand];
    }
    cardString =[cardString stringByAppendingString:@"]"];
    NSLog(@"Cards:%@",cardString);
}



@end
