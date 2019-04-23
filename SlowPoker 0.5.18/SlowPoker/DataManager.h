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
    NSString *messagesGameID;
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
    int localAchivementsCount;
    NSMutableDictionary *betRound;
    NSMutableDictionary *currentHand;
    NSMutableDictionary *cardImages;
    NSMutableArray *deck;
    NSMutableArray *myFriends;
    NSMutableArray *recentPlayers;
    NSMutableArray *favPlayers;
    NSString *deviceTok;
    NSMutableDictionary *messages;
    NSDateFormatter *utcFormatter;
    NSDate *lastUpdatedDate;
    NSMutableDictionary *playerProfile;
    NSMutableDictionary *myProfile;
    NSMutableArray *localAcievements;
    NSMutableDictionary *gameAchievements;
    NSMutableDictionary *showAchievement;
    NSMutableDictionary *addAchievement;
    NSMutableArray *myInventory;
    BOOL isNewDay;
    BOOL isSendingAchievements;
    NSString *showStatCode;
    NSMutableDictionary *tally;
    NSMutableDictionary *profileStatues;
    int myProChips;
    NSString *joinGameID;
}

@property (nonatomic,retain)NSMutableArray *games;
@property (nonatomic,retain)NSMutableArray *yourTurnGames;
@property (nonatomic,retain)NSMutableArray *theirTurnGames;
@property (nonatomic,retain)NSMutableArray *completedGames;
@property (nonatomic,retain)NSMutableDictionary *currentGame;
@property (nonatomic,retain)NSMutableDictionary *currentHand;
@property (nonatomic,retain)NSMutableDictionary *myProfile;
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
@property (nonatomic,retain)NSMutableArray *favPlayers;
@property (nonatomic, retain) NSString *deviceTok;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
@property (nonatomic, retain) NSDate *lastUpdatedDate;
@property (nonatomic, retain) NSString *messagesGameID;
@property (nonatomic, retain) NSMutableDictionary *messages;
@property (nonatomic, retain) NSMutableDictionary *playerProfile;
@property (nonatomic, retain) NSMutableArray *localAcievements;
@property (nonatomic, retain) NSMutableDictionary *gameAchievements;
@property (nonatomic, retain) NSMutableDictionary *showAchievement;
@property (nonatomic, retain) NSMutableDictionary *addAchievement;
@property (nonatomic, retain) NSString *showStatCode;
@property (nonatomic, retain) NSMutableDictionary *tally;
@property (nonatomic, retain) NSMutableArray *myInventory;
@property (nonatomic, retain) NSMutableDictionary *profileStatues;
@property (nonatomic, retain) NSString *joinGameID;
@property (readwrite) BOOL isNewDay;
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
-(NSMutableArray *)determineHandWinners:(NSMutableDictionary *)game evenPot:(BOOL)evenPot;
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
-(void)postNudgeToCurrentPlayer;
-(BOOL)isCurrentGameTypeTournament;
-(BOOL)isGameTypeTournament:(NSDictionary *)game;
-(BOOL)isGameTypeCash:(NSDictionary *)game;
-(void)postSystemMessageForCurrentGame:(NSString *)message;
-(void)setMessagesAsReadForCurrentGame;
-(int)getUnreadMessageCountForCurrentGame;
-(NSMutableArray *)getMessagesForCurrentGame;
-(NSMutableArray *)getPlayersInTableArangement;
-(void)loadPlayerProfile:(NSString *)userID;
-(void)incrementAchievement:(NSMutableDictionary *)gameAchievement forUser:(NSString *)userID;
-(void)sendAchievements:(BOOL)forceSend;
-(NSMutableArray *)getProfileAchievements:(NSString *)category;
-(void)purchaseShowAchievementForPlayerProfile;
-(int)getCountForUserAchievement:(NSMutableDictionary *)gameAchievement;
-(int)getCountForUserAchievement:(NSString *)code category:(NSString *)category;
-(void)incrementAchievement:(NSString *)code category:(NSString *)category earnedValue:(NSString *)earnedValue forUser:(NSString *)userID;
-(void)incrementAchievement:(NSString *)code category:(NSString *)category earnedValue:(NSString *)earnedValue forUser:(NSString *)userID countInc:(int)countInc;
-(NSMutableDictionary *)getGameAchievementForCode:(NSString *)code category:(NSString *)category;
-(void)checkAchievements:(NSMutableDictionary *)winningHand;
-(NSMutableDictionary *)getPlayerAchievementForCode:(NSString *)code category:(NSString *)category;
-(NSArray *)determinGameWinnerForCurrentGame;
-(void)incrementAcievementValue:(NSString *)code category:(NSString *)category forUser:(NSString *)userID valueInc:(double)valueInc;
-(double)getValueForUserAchievement:(NSString *)code;
-(int)incrementClientTally:(NSString *)code gameID:(NSString *)gameID;
-(NSMutableArray *)getRoundsForCurrentHand;
-(BOOL)isPlayerStatsLocked:(NSString *)userID;
-(BOOL)isCurrentPlayerProfileStatsLocked;
-(void)addInventory:(NSString *)category value:(NSString *)value;
-(int)numOfLocalAchievements;
-(BOOL)shouldIncrementPrimaryAchievement:(NSString *)category;
-(void)arrangeFavsAndRecents;
-(void)loadPlayerStatuses;
-(int)getMyProChips;
-(void)joinGame:(NSString *)gameType;
-(void)setProfileToMe;
@end
