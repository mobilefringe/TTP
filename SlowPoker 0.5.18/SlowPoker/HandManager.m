//
//  HandManager.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HandManager.h"
#import "Card.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation HandManager




-(NSMutableArray *)determineWinners:(NSMutableDictionary *)game{
    //see if there is a winner due to folding
    NSMutableDictionary *currentHand = [[[game valueForKey:@"gameState"] valueForKey:@"hands"] objectAtIndex:0];
    int remainingPlayers = 0;
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    NSMutableDictionary *lastManWinner;
    for (NSMutableDictionary *player in [[game valueForKey:@"turnState"] valueForKey:@"players"]) {
        if([@"playing" isEqualToString:[player valueForKey:@"status"]] && ![@"fold" isEqualToString:[[player valueForKey:@"playerState"] objectForKey:@"action"]]){
            remainingPlayers++;
            lastManWinner = player;
        }
    }
    
    if(remainingPlayers==1){
        NSMutableDictionary *winner = [[NSMutableDictionary alloc] init];
        [winner setValue:[lastManWinner valueForKey:@"userID"] forKey:@"userID"];
        [winner setValue:[lastManWinner valueForKey:@"userName"] forKey:@"userName"];
        [winner setValue:[currentHand valueForKey:@"potSize"] forKey:@"amount"];
        [winners addObject:winner];
        return winners;
    }
    [winners removeAllObjects];
    
    
    
    return nil;
}


#pragma mark - View lifecycle

+ (HandManager *)sharedInstance {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];// or some other init method
    });
    return _sharedObject;
    /*
     @synchronized(self) {
     if (myDataManager == nil) {
     [[self alloc] init]; // assignment not done here
     }
     }
     return myDataManager;*/
}


@end
