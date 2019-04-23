//
//  Hand.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Hand : NSObject{
    NSMutableArray *cards;
    int value;
    NSString *type;
    int rankDist[NO_OF_RANKS];
    int suitDist[NO_OF_SUITS];
    int pairs[MAX_NO_OF_PAIRS];
    int rankings[NO_OF_RANKINGS];
    int straightRank;
    int flushSuit;
    int flushRank;
    int straightFlushRank;
    int tripleRank;
    int quadRank;
    int noOfPairs;
    int noOfTripples;
    BOOL wheelingAce;
    NSString *userID;
    NSString *userName;
    BOOL processed;
    NSMutableArray *straightRanks;
    NSMutableArray *flushRanks;
    NSString *typeValues;
}

@property (nonatomic,retain)NSMutableArray *cards;
@property (readwrite)int value;
@property (readwrite)BOOL processed;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSString *userID;
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSMutableArray *straightRanks;
@property (nonatomic,retain)NSMutableArray *flushRanks;
@property (nonatomic,retain)NSString *typeValues;
-(id)initWithCards:(NSMutableArray *)cardStrings;
-(void)addCard:(Card *)card;
-(void)resetHand;
-(void)logHand;
-(void)calculateDistributions;
-(void)findStraight;
-(void)findFlush;
-(void)findDuplicates;
-(void)calculateHighCard;
-(BOOL)isStraightFlush;
-(BOOL)isFourOfAKind;
-(BOOL)isFullHouse;
-(BOOL)isFlush;
-(BOOL)isStraight;
-(BOOL)isThreeOfAKind;
-(BOOL)isTwoPairs;
-(BOOL)isOnePair;
-(NSMutableArray *)getUsedInHandCards;
-(NSMutableDictionary *)getHandDetails;

@end
