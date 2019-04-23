//
//  DataManager.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataManager : NSObject{
    NSMutableArray *allGames;
    NSMutableArray *yourTurnGames;
    NSMutableArray *theirTurnGames;
    NSMutableArray *completedGames;
    NSMutableArray *games;
    NSString *currentGameID;
    NSMutableDictionary *currentGame;
    NSString *myUserID;
    NSString *myUserName;
    NSString *currentTurnUserID;
    NSString *currentTurnUserName;
    NSDateFormatter *df;
    BOOL gamesUpdated;
    BOOL gameDetailsUpdates;
    BOOL isGamesUpdating;
    BOOL isGameDetailsUpdating;
    int newMessagesCount;
    NSMutableDictionary *betRound;
    NSMutableDictionary *currentHand;
    NSMutableDictionary *cardImages;
    NSMutableArray *deck;
    NSMutableArray *recentPlayers;
    NSMutableArray *myFriends;
    NSString *deviceTok;
    NSMutableArray *gameMessages;
    NSDateFormatter *utcFormatter;
}
@property (nonatomic,retain)NSMutableArray *games;
@property (nonatomic,retain)NSMutableArray *yourTurnGames;
@property (nonatomic,retain)NSMutableArray *theirTurnGames;
@property (nonatomic,retain)NSMutableArray *completedGames;
@property (nonatomic,retain)NSMutableDictionary *currentGame;
@property (nonatomic,retain)NSMutableDictionary *currentHand;
@property (nonatomic,retain)NSString *currentGameID;
@property (nonatomic,retain)NSString *myUserID;
@property (nonatomic,retain)NSString *myUserName;
@property (nonatomic,retain)NSString *currentTurnUserID;
@property (nonatomic,retain)NSString *currentTurnUserName;
@property (nonatomic,retain)NSDateFormatter *df;
@property (readwrite)BOOL gamesUpdated;
@property (readwrite)BOOL gameDetailsUpdates;
@property (readwrite)int newMessagesCount;
@property (nonatomic,retain)NSMutableDictionary *betRound;
@property (nonatomic,retain)NSMutableDictionary *cardImages;
@property (nonatomic,retain)NSMutableArray *deck;
@property (nonatomic,retain)NSMutableArray *recentPlayers;
@property (nonatomic,retain)NSMutableArray *myFriends;
@property (nonatomic,retain)NSMutableArray *gameMessages;
@property (nonatomic, retain) NSString *deviceTok;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
+(DataManager *)sharedInstance;
-(void)loadUserGames;
-(void)loadGameDetails:(NSString *)gameID;
-(void)fetchedUserGames:(NSMutableArray *)gameArray;
-(void)fetchedGameDetails:(NSMutableDictionary *)game;
-(NSString *)getGameActivityMessageForGame:(NSMutableDictionary *)gameDict;
-(NSString *)dateDiff:(NSDate *)origDate;
-(NSString *)getLastUpdatedGamesMessage;
-(BOOL)isMyTurn:(NSMutableDictionary *)gameDict;
-(BOOL)isGameActive:(NSMutableDictionary *)gameDict;
-(BOOL)isCurrentGameActive;
-(BOOL)isGameComplete:(NSMutableDictionary *)gameDict;
-(NSMutableArray *)getTurnStatePlayersForGame:(NSMutableDictionary *)game;
-(NSMutableDictionary *)getPlayerMeForGame:(NSMutableDictionary *)game;
-(NSString *)getCurrentPlayersTurn;
//game details
-(NSMutableArray *)getHandsForCurrentGame;
-(NSMutableArray *)getRoundsForHand:(NSMutableDictionary *)hand;
-(BOOL)isCurrentGameMyTurn;
-(void)postRound:(NSMutableDictionary *)round;
-(NSMutableDictionary *)getNextTurnPlayerFromCurrentGame:(BOOL)isFirstActor;
-(void)arrangeUserGames;
-(NSString *)getPlayersTurnForGame:(NSMutableDictionary *)game;
-(NSMutableDictionary *)getPlayerForID:(NSString *)userID game:(NSMutableDictionary *)game;
-(NSMutableDictionary *)getPlayerMeForCurrentGame;
-(NSMutableDictionary *)getPlayerStateMeForCurrentGame;
-(NSMutableDictionary *)getPlayerStateCurrentTurnForCurrentGame;
-(void)createNewGame:(NSMutableDictionary *)game;
-(BOOL)isCurrentGameTypeCash;
-(void)leaveCurrentGame;
-(void)buyInToCurrentGame:(NSMutableDictionary *)playerState;
-(BOOL)hasMeInGame:(NSMutableDictionary *)game;
-(BOOL)isGameWaitingForOtherPlayers:(NSMutableDictionary *)game;
-(NSMutableDictionary *)getCurrentPlayerForGame:(NSMutableDictionary *)game;
-(NSMutableDictionary *)getCurrentPlayerForCurrentGame;
-(BOOL)isGamePending:(NSMutableDictionary *)gameDict;
-(BOOL)canStartGame:(NSMutableDictionary *)game;
-(NSMutableArray *)getPlayersForCurrentGame;
-(void)startCurrentGame;
-(void)dealNewHand;
-(void)resetDeck;
-(NSString *)getRandomCardFromDeck;
-(double)getCallValue;
-(NSMutableDictionary *)lastRoundForPlayer:(NSString *)userID;
-(NSMutableDictionary *)getNextDealerPlayer;
-(NSMutableDictionary *)registerPlayer:(NSMutableDictionary *)playerData;
-(NSMutableDictionary *)loginPlayer:(NSMutableDictionary *)playerData;
-(void)updateCurrentGame;
-(NSMutableDictionary *)searhForUser:(NSString *)userIdentity;
-(NSString *)getNextPlayerOrderForGame:(NSMutableDictionary *)game;
-(BOOL)isPlayerMePendingForGame:(NSMutableDictionary *)gameDict;
-(BOOL)hasEnoughPlayersToStart:(NSMutableDictionary *)gameDict;
-(void)addBettingRoundIfNeeded;
-(NSMutableDictionary *)invitePlayer:(NSMutableDictionary *)playerDict;
-(NSMutableArray *)determineWinners:(NSMutableDictionary *)game evenPot:(BOOL)evenPot;
-(void)increaseHandState;
-(void)addFriends:(NSMutableArray *)games;
-(void)updateFriends;
-(void)updatedFriends:(NSMutableDictionary *)results;
-(BOOL)isCurrentGameOwnerMe;
-(NSString *)getCurrentGameOwnerUserName;
-(void)deleteGame:(NSMutableDictionary *)game;
-(BOOL)hasCurrentGameMoreHands;
-(BOOL)isCurrentGameComplete;
-(double)getMinRaiseValue;
-(void)registerForAPN;
-(void)sendAPN:(NSMutableArray *)players message:(NSString *)message payLoad:(NSMutableDictionary *)payLoad;
-(void)postMessageForCurrentGame:(NSString *)message;
-(void)loadNewMessages;
-(void)updateGameMessages:(NSMutableDictionary *)messageDict;
-(double)getPotEntryForUser:(NSString *)userID hand:(NSMutableDictionary *)hand;
-(NSMutableDictionary *)getPlayerForIDCurrentGame:(NSString *)userID;
-(BOOL)canPlayerBet:(NSMutableDictionary *)player;
@end
