//
//  DataManager.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "APIDataManager.h"
#import "HandManager.h"
#import "Hand.h"
#import "Card.h"
#import <AudioToolbox/AudioToolbox.h>


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kGamesURL [NSURL URLWithString:@"http://www.mobilefringeserver.com/slowpoker/games_ver2.json"]
#define kTurnsURL [NSURL URLWithString:@"http://www.mobilefringeserver.com/slowpoker/turns.json"]

@implementation DataManager

@synthesize games;
@synthesize yourTurnGames;
@synthesize theirTurnGames;
@synthesize completedGames;
@synthesize currentGame;
@synthesize currentHand;
@synthesize currentGameID;
@synthesize myUserID;
@synthesize df;
@synthesize gamesUpdated;
@synthesize gameDetailsUpdates;
@synthesize betRound;
@synthesize myUserName;
@synthesize cardImages;
@synthesize currentTurnUserID;
@synthesize currentTurnUserName;
@synthesize deck;
@synthesize recentPlayers;
@synthesize myFriends;
@synthesize deviceTok;
@synthesize gameMessages;
@synthesize newMessagesCount;
@synthesize utcFormatter;
static BOOL logging = YES;
static BOOL debugMode = NO;


-(id)init{
    self = [super init];
	if (self != nil) {
               
        self.cardImages = [[NSMutableDictionary alloc] init];
        [cardImages setValue:[UIImage imageNamed:@"2C.png"] forKey:@"2C"];
        [cardImages setValue:[UIImage imageNamed:@"2D.png"] forKey:@"2D"];
        [cardImages setValue:[UIImage imageNamed:@"2H.png"] forKey:@"2H"];
        [cardImages setValue:[UIImage imageNamed:@"2S.png"] forKey:@"2S"];
        [cardImages setValue:[UIImage imageNamed:@"3C.png"] forKey:@"3C"];
        [cardImages setValue:[UIImage imageNamed:@"3D.png"] forKey:@"3D"];
        [cardImages setValue:[UIImage imageNamed:@"3H.png"] forKey:@"3H"];
        [cardImages setValue:[UIImage imageNamed:@"3S.png"] forKey:@"3S"];
        [cardImages setValue:[UIImage imageNamed:@"4C.png"] forKey:@"4C"];
        [cardImages setValue:[UIImage imageNamed:@"4D.png"] forKey:@"4D"];
        [cardImages setValue:[UIImage imageNamed:@"4H.png"] forKey:@"4H"];
        [cardImages setValue:[UIImage imageNamed:@"4S.png"] forKey:@"4S"];
        [cardImages setValue:[UIImage imageNamed:@"5C.png"] forKey:@"5C"];
        [cardImages setValue:[UIImage imageNamed:@"5D.png"] forKey:@"5D"];
        [cardImages setValue:[UIImage imageNamed:@"5H.png"] forKey:@"5H"];
        [cardImages setValue:[UIImage imageNamed:@"5S.png"] forKey:@"5S"];
        [cardImages setValue:[UIImage imageNamed:@"6C.png"] forKey:@"6C"];
        [cardImages setValue:[UIImage imageNamed:@"6D.png"] forKey:@"6D"];
        [cardImages setValue:[UIImage imageNamed:@"6H.png"] forKey:@"6H"];
        [cardImages setValue:[UIImage imageNamed:@"6S.png"] forKey:@"6S"];
        [cardImages setValue:[UIImage imageNamed:@"7C.png"] forKey:@"7C"];
        [cardImages setValue:[UIImage imageNamed:@"7D.png"] forKey:@"7D"];
        [cardImages setValue:[UIImage imageNamed:@"7H.png"] forKey:@"7H"];
        [cardImages setValue:[UIImage imageNamed:@"7S.png"] forKey:@"7S"];
        [cardImages setValue:[UIImage imageNamed:@"8C.png"] forKey:@"8C"];
        [cardImages setValue:[UIImage imageNamed:@"8D.png"] forKey:@"8D"];
        [cardImages setValue:[UIImage imageNamed:@"8H.png"] forKey:@"8H"];
        [cardImages setValue:[UIImage imageNamed:@"8S.png"] forKey:@"8S"];
        [cardImages setValue:[UIImage imageNamed:@"9C.png"] forKey:@"9C"];
        [cardImages setValue:[UIImage imageNamed:@"9D.png"] forKey:@"9D"];
        [cardImages setValue:[UIImage imageNamed:@"9H.png"] forKey:@"9H"];
        [cardImages setValue:[UIImage imageNamed:@"9S.png"] forKey:@"9S"];
        [cardImages setValue:[UIImage imageNamed:@"TC.png"] forKey:@"TC"];
        [cardImages setValue:[UIImage imageNamed:@"TD.png"] forKey:@"TD"];
        [cardImages setValue:[UIImage imageNamed:@"TH.png"] forKey:@"TH"];
        [cardImages setValue:[UIImage imageNamed:@"TS.png"] forKey:@"TS"];
        [cardImages setValue:[UIImage imageNamed:@"JC.png"] forKey:@"JC"];
        [cardImages setValue:[UIImage imageNamed:@"JD.png"] forKey:@"JD"];
        [cardImages setValue:[UIImage imageNamed:@"JH.png"] forKey:@"JH"];
        [cardImages setValue:[UIImage imageNamed:@"JS.png"] forKey:@"JS"];
        [cardImages setValue:[UIImage imageNamed:@"QC.png"] forKey:@"QC"];
        [cardImages setValue:[UIImage imageNamed:@"QD.png"] forKey:@"QD"];
        [cardImages setValue:[UIImage imageNamed:@"QH.png"] forKey:@"QH"];
        [cardImages setValue:[UIImage imageNamed:@"QS.png"] forKey:@"QS"];
        [cardImages setValue:[UIImage imageNamed:@"KC.png"] forKey:@"KC"];
        [cardImages setValue:[UIImage imageNamed:@"KD.png"] forKey:@"KD"];
        [cardImages setValue:[UIImage imageNamed:@"KH.png"] forKey:@"KH"];
        [cardImages setValue:[UIImage imageNamed:@"KS.png"] forKey:@"KS"];
        [cardImages setValue:[UIImage imageNamed:@"AC.png"] forKey:@"AC"];
        [cardImages setValue:[UIImage imageNamed:@"AD.png"] forKey:@"AD"];
        [cardImages setValue:[UIImage imageNamed:@"AH.png"] forKey:@"AH"];
        [cardImages setValue:[UIImage imageNamed:@"AS.png"] forKey:@"AS"];
        [cardImages setValue:[UIImage imageNamed:@"back.png"] forKey:@"?"];

        if(!utcFormatter){
            self.utcFormatter = [[NSDateFormatter alloc] init];
            [utcFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
            NSTimeZone *UTCTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [utcFormatter setTimeZone:UTCTimeZone];
        }
        
        self.deck = [[NSMutableArray alloc] init];
        
    }
    return self;
}


#pragma mark - Push Notifications


-(void)registerForAPN{
    if(!deviceTok){
        return; 
    }
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *registerDict = [[NSMutableDictionary alloc] init];
        [registerDict setValue:myUserID forKey:@"userID"];
        [registerDict setValue:deviceTok forKey:@"deviceToken"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:registerDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *results = [[APIDataManager sharedInstance] registeriDevice:jsonString];
        if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
            //NSLog(@"registerForAPN Results:%@",results);
        }
    });
}

-(void)sendAPN:(NSMutableArray *)players message:(NSString *)message payLoad:(NSMutableDictionary *)payLoad{
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *apnDict = [[NSMutableDictionary alloc] init];
        [apnDict setValue:players forKey:@"players"];
        [apnDict setValue:message forKey:@"message"];
        [apnDict setValue:payLoad forKey:@"payLoad"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:apnDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"sendAPN Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] sendNotification:jsonString];
        if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
            NSLog(@"sendAPN Results:%@",results);
        }
        NSLog(@"sendAPN Results:%@",results);
    });
    
}


#pragma mark - Register & Login

-(NSMutableDictionary *)registerPlayer:(NSMutableDictionary *)playerData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] registerPlayer:jsonString];
    //NSLog(@"results:%@",results);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        self.myUserID = [NSString stringWithFormat:@"%@",[results objectForKey:@"userID"]];
        self.myUserName = [results objectForKey:@"userName"];
        [prefs setObject:[results objectForKey:@"userName"] forKey:@"userName"];
        [prefs setObject:[results objectForKey:@"email"] forKey:@"email"];
        [prefs setObject:[playerData objectForKey:@"password"] forKey:@"password"];
        [self registerForAPN];
        [prefs synchronize];
    }
    return results;
    
}

-(NSMutableDictionary *)loginPlayer:(NSMutableDictionary *)playerData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSLog(@"loginPlayer:%@",playerData);
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] loginPlayer:jsonString];
    //NSLog(@"results:%@",results);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        self.myUserID = [NSString stringWithFormat:@"%@",[results objectForKey:@"userID"]];
        self.myUserName = [results objectForKey:@"userName"];
        self.myFriends = [results objectForKey:@"friends"];
        [prefs setObject:[results objectForKey:@"userName"] forKey:@"userName"];
        [prefs setObject:[results objectForKey:@"email"] forKey:@"email"];
        [prefs setObject:[playerData objectForKey:@"password"] forKey:@"password"];
        [self registerForAPN];
        [prefs synchronize];
    }
    return results;
    
}



#pragma mark - Load Games & Game Details

-(void)loadUserGames{
    if(isGamesUpdating){
        return;
    }
    dispatch_async(kBgQueue, ^{
        isGamesUpdating = YES;
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:self.myUserID forKey:@"userID"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       // NSLog(@"jsonString:%@",jsonString);
        NSMutableArray *results = [[APIDataManager sharedInstance] getPlayerGames:jsonString];
        
        [self performSelectorOnMainThread:@selector(fetchedUserGames:) 
                               withObject:results waitUntilDone:YES];
    });
}



-(void)fetchedUserGames:(NSMutableArray *)gameArray {
    isGamesUpdating = NO;
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"games_updated_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSError* error;
    
    self.games = gameArray;
    [self addFriends:games];
    if(error){
        NSLog(@"error:%@",error);
    }
    //NSLog(@"Games:%@",games);
    
    [self arrangeUserGames];
        //used as an observer
    self.gamesUpdated = YES;
}

-(void)loadGameDetails:(NSString *)gameID{
    if(isGameDetailsUpdating){
        return;
    }
    dispatch_async(kBgQueue, ^{
        isGameDetailsUpdating = YES;
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:gameID forKey:@"gameID"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // NSLog(@"Start loadGameDetails");
        NSMutableDictionary *game = [[APIDataManager sharedInstance] getGame:jsonString];
        //NSLog(@"End loadGameDetails");
        
        
        [self performSelectorOnMainThread:@selector(fetchedGameDetails:) 
                               withObject:game waitUntilDone:YES];
        
    });
}


- (void)fetchedGameDetails:(NSMutableDictionary *)game{
    isGameDetailsUpdating = NO;
    self.currentGame = game;
    NSString *gameMessagesKey = [NSString stringWithFormat:@"gameMessages_%@_%@",currentGameID,myUserID];
    self.gameMessages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:gameMessagesKey]];
    //NSLog(@"local messages:%@",gameMessages);
    NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
    if([hands count] > 0){
        self.currentHand = [hands objectAtIndex:0];
    }
    self.gameDetailsUpdates = YES;
    if([self isMyTurn:currentGame]){
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }else{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}






-(void)arrangeUserGames{
    if(!yourTurnGames){
        self.yourTurnGames = [[NSMutableArray alloc] init];
    }
    [yourTurnGames removeAllObjects];
    
    if(!theirTurnGames){
        self.theirTurnGames = [[NSMutableArray alloc] init];
    }
    [theirTurnGames removeAllObjects];
    
    if(!completedGames){
        self.completedGames = [[NSMutableArray alloc] init];
    }
    [completedGames removeAllObjects];
    
    
    
    
    for (NSMutableDictionary *game in games) {
        ////NSLog(@"Game:%@",game);
        if([self hasMeInGame:game]){
            if([self isGameActive:game]){
                if([self isMyTurn:game] || [self isPlayerMePendingForGame:game]){
                    [yourTurnGames addObject:game];
                }else{
                    [theirTurnGames addObject:game];
                }
            }else if([self isGamePending:game]){
                if([self isPlayerMePendingForGame:game] || ([self hasEnoughPlayersToStart:game] && [[game valueForKey:@"gameOwnerID"] isEqualToString:myUserID])){
                    [yourTurnGames addObject:game];
                }else{
                    [theirTurnGames addObject:game];
                }
            }else if([self isGameComplete:game]){
                [completedGames addObject:game];
            }
        }
    }
    
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[yourTurnGames count]];
}

#pragma mark - Chat

-(void)postMessageForCurrentGame:(NSString *)message{
    NSMutableDictionary *localMessageDict = [[NSMutableDictionary alloc] init];
    [localMessageDict setValue:myUserID forKey:@"userID"];
    [localMessageDict setValue:message forKey:@"message"];
    [localMessageDict setValue:myUserName forKey:@"userName"];
    [localMessageDict setValue:currentGameID forKey:@"gameID"];
    [localMessageDict setValue:[utcFormatter stringFromDate:[NSDate date]] forKey:@"created_at"];
    [self updateGameMessages:localMessageDict];
    dispatch_async(kBgQueue, ^{
        
        NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
        NSMutableArray *recipients = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
            if(![[player valueForKey:@"userID"] isEqualToString:myUserID]){
                //NSMutableDictionary *recipientDict = [[NSMutableDictionary alloc] init];
                //[recipientDict setValue:[player valueForKey:@"userID"] forKey:@"userID"];
                [recipients addObject:[player valueForKey:@"userID"]];
            }
        }
        [messageDict setValue:recipients forKey:@"recipients"];
        [messageDict setValue:message forKey:@"message"];
        [messageDict setValue:myUserID forKey:@"userID"];
        [messageDict setValue:myUserName forKey:@"userName"];
        [messageDict setValue:currentGameID forKey:@"gameID"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       // NSLog(@"postMessageForCurrentGame Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] postMessge:jsonString];
        if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
            NSLog(@"postMessageForCurrentGame Results:%@",results);
        }
       // NSLog(@"postMessageForCurrentGame Results:%@",results);
    });
}

-(void)fetchedNewMessages:(NSMutableDictionary *)newMessages{
    
    
    for (NSMutableDictionary *messageDict in [newMessages valueForKey:@"messages"]) {
        [self updateGameMessages:messageDict];
    }
    self.newMessagesCount = newMessagesCount + [[newMessages valueForKey:@"messages"] count];
    
    if(newMessagesCount > 0){
        //AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        NSLog(@"new Messages:%@",newMessages);
    }
}

-(void)updateGameMessages:(NSMutableDictionary *)messageDict{
    [gameMessages addObject:messageDict];
    NSString *gameMessagesKey = [NSString stringWithFormat:@"gameMessages_%@_%@",[messageDict valueForKey:@"gameID"],myUserID];
    [[NSUserDefaults standardUserDefaults] setObject:gameMessages forKey:gameMessagesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadNewMessages{
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
        [messageDict setValue:myUserID forKey:@"userID"];
        [messageDict setValue:currentGameID forKey:@"gameID"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       // NSLog(@"loadNewMessages Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] getLastMessage:jsonString];
        
       // NSLog(@"loadNewMessages Results:%@",results);
        
        [self performSelectorOnMainThread:@selector(fetchedNewMessages:) 
                               withObject:results waitUntilDone:YES];
    });
}






-(void)addFriends:(NSMutableArray *)playerGames{
    if(playerGames && playerGames.count > 0){
        BOOL hasNewFriends = NO;
        if(!myFriends){
            self.myFriends = [[NSMutableArray alloc] init];
        }
        for (NSMutableDictionary *game in playerGames) {
            NSMutableArray *players = [[game valueForKey:@"turnState"] valueForKey:@"players"];
            for (NSMutableDictionary *player in players) {
                if(![myUserID isEqualToString:[player valueForKey:@"userID"]]){
                    BOOL hasFriend = NO;
                    for (NSMutableDictionary *friend in self.myFriends) {
                        if([[friend valueForKey:@"userID"] isEqualToString:[player valueForKey:@"userID"]]){
                            hasFriend = YES;
                            break;
                        }
                    }
                    if(!hasFriend){
                        hasNewFriends = YES;
                        NSMutableDictionary *newFriend = [[NSMutableDictionary alloc] init];
                        [newFriend setValue:[player valueForKey:@"userID"] forKey:@"userID"];
                        [newFriend setValue:[player valueForKey:@"userName"] forKey:@"userName"];
                        [myFriends addObject:newFriend];
                    }
                }
            }
        }
        if(hasNewFriends){
            [self updateFriends];
        }
    }
}

-(void)updateFriends{
    dispatch_async(kBgQueue, ^{
        NSError *error;
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:self.myUserID forKey:@"userID"];
        [userDict setValue:myFriends forKey:@"friends"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *results = [[APIDataManager sharedInstance] updatePlayerFriends:jsonString];
        
        [self performSelectorOnMainThread:@selector(updatedFriends:) 
                               withObject:results waitUntilDone:YES];
    });
}

-(void)updatedFriends:(NSMutableDictionary *)results{
    //NSLog(@"updatedFriends:%@",results);
}




-(NSMutableDictionary *)searhForUser:(NSString *)userIdentity{
    NSMutableDictionary *userIdentityDict = [[NSMutableDictionary alloc] init];
    [userIdentityDict setValue:userIdentity forKey:@"login"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userIdentityDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] searchForUser:jsonString];
    //NSLog(@"results:%@",results);
    return results;
}

-(NSMutableDictionary *)updatePlayer:(NSMutableDictionary *)playerDict{
    [playerDict setValue:[currentGame valueForKey:@"gameID"] forKey:@"gameID"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] updatePlayerToGame:jsonString];
    //NSLog(@"results:%@",results);
    return results;
}

-(NSMutableDictionary *)invitePlayer:(NSMutableDictionary *)playerDict{
    
    NSMutableArray *invitePlayers = [[NSMutableArray alloc] init];
    [invitePlayers addObject:[playerDict valueForKey:@"userID"]];
    NSString *message = [NSString stringWithFormat:@"%@ has invited you to a %@ game",myUserName,NSLocalizedString([[currentGame valueForKey:@"gameSettings"] valueForKey:@"type"],nil)];
    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
    [payLoad setValue:currentGameID forKey:@"gameID"];
    [self sendAPN:invitePlayers message:message payLoad:payLoad];
    
    
    [playerDict setValue:[currentGame valueForKey:@"gameID"] forKey:@"gameID"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] addPlayerToGame:jsonString];
    //NSLog(@"results:%@",results);
    return results;
}

-(void)addBettingRoundIfNeeded{
    if([self isCurrentGameMyTurn] || debugMode){
        if(currentGame && [currentGame objectForKey:@"gameState"] && [@"active" isEqualToString:[currentGame valueForKey:@"status"]]){
            if([[currentGame objectForKey:@"gameState"] objectForKey:@"hands"]){
                NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
                if([hands count] > 0){
                    self.currentHand = [hands objectAtIndex:0];
                    NSMutableArray *rounds = [[hands objectAtIndex:0] objectForKey:@"rounds"];
                    
                    
                    NSMutableDictionary *lastRount = [rounds objectAtIndex:0];
                    if(lastRount && ![@"YES" isEqualToString:[lastRount objectForKey:@"MY_BET_ROUND"]]){
                        self.betRound = [[NSMutableDictionary alloc] initWithCapacity:0];
                        [betRound setValue:@"YES" forKey:@"MY_BET_ROUND"];
                        
                        [betRound setValue:currentTurnUserID forKey:@"userID"];
                        [betRound setValue:currentTurnUserName forKey:@"userName"];
                        
                        [betRound setValue:@"NO" forKey:@"showCards"];
                        
                        
                        NSMutableDictionary *currentPlayerState = [[[DataManager sharedInstance] getCurrentPlayerForCurrentGame] objectForKey:@"playerState"];
                        [betRound setValue:[currentPlayerState valueForKey:@"isDealer"] forKey:@"isDealer"];
                        [betRound setValue:[currentPlayerState valueForKey:@"cardOne"] forKey:@"cardOne"];
                        [betRound setValue:[currentPlayerState valueForKey:@"cardTwo"] forKey:@"cardTwo"];
                        double userStack = [[currentPlayerState objectForKey:@"userStack"] doubleValue];
                        [betRound setValue:[NSString stringWithFormat:@"%.2f",userStack] forKey:@"userStack"];
                       // AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                        [rounds insertObject:betRound atIndex:0];
                    }
                }
            }
        }
    }
    
}


-(void)deleteGame:(NSMutableDictionary *)game{
    NSMutableDictionary *playerDict = [[NSMutableDictionary alloc] init];
    [playerDict setValue:myUserID forKey:@"userID"];
    [playerDict setValue:[game valueForKey:@"gameID"] forKey:@"gameID"];
    [playerDict setValue:@"leave" forKey:@"status"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] updatePlayerToGame:jsonString];
    NSLog(@"deleteGame:%@",results);
}



-(void)updateCurrentGame{
    
    //dispatch_async(kBgQueue, ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:currentGame options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"updateGame JSON:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] updateGame:jsonString];
        
        [self performSelectorOnMainThread:@selector(didFinishUpdate:) 
                               withObject:results waitUntilDone:YES];
        
   //  });
    
}

-(void)didFinishUpdate:(NSMutableDictionary *)updateResults{
    NSLog(@"didFinishUpdate:%@",updateResults);
    NSMutableArray *playersForAPN = [[NSMutableArray alloc] init];
    [playersForAPN addObject:[currentGame valueForKey:@"nextActionForUserID"]];
    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
    [payLoad setValue:currentGameID forKey:@"gameID"];
    if([currentGame valueForKey:@"lastActionMessage"] && [[currentGame valueForKey:@"lastActionMessage"] length] > 0){
        [self sendAPN:playersForAPN message:[NSString stringWithFormat:@"%@. Your Turn",[currentGame valueForKey:@"lastActionMessage"]] payLoad:payLoad];
    }
}


-(NSMutableArray *)getPlayersForGame:(NSMutableDictionary *)game{
    return [[game objectForKey:@"turnState"] objectForKey:@"players"];
}



-(NSString *)getGameActivityMessageForGame:(NSMutableDictionary *)gameDict{
    
    if(logging){
        //NSLog(@"game:%@",gameDict);
    }
    
    NSString *message = @"";
    if(gameDict){
        message = [message stringByAppendingFormat:@"%@",[gameDict objectForKey:@"lastActionMessage"]];
        
        NSString *nextActionForUserID =  [gameDict objectForKey:@"nextActionForUserID"];
        NSMutableDictionary *turnState = [gameDict objectForKey:@"turnState"];
        
        NSMutableArray *players = [turnState objectForKey:@"players"];
        for (NSMutableDictionary *player in players) {
            if([[player objectForKey:@"userID"] isEqualToString:nextActionForUserID]){
                message = [message stringByAppendingFormat:@" to %@",[player objectForKey:@"userName"]];
            }
        }
    }
    return message;
}



-(BOOL)isMyTurn:(NSMutableDictionary *)gameDict{
    return [myUserID isEqualToString:[gameDict valueForKey:@"nextActionForUserID"]];
}


-(BOOL)isCurrentGameOwnerMe{
    return [myUserID isEqualToString:[currentGame valueForKey:@"gameOwnerID"]];
}

-(NSString *)getCurrentGameOwnerUserName{
    if(currentGame){
        if([currentGame objectForKey:@"turnState"]){
            if([[currentGame objectForKey:@"turnState"] objectForKey:@"players"]){
                NSMutableArray *players = [[currentGame objectForKey:@"turnState"] objectForKey:@"players"];
                for (NSMutableDictionary *player in players) {
                    if([[player objectForKey:@"userID"] isEqualToString:[currentGame valueForKey:@"gameOwnerID"]]){
                        return [player objectForKey:@"userName"];
                    }
                }
                
            }
            
        }
    }
    return @"N/A";
}

-(BOOL)hasMeInGame:(NSMutableDictionary *)game{
    if([game objectForKey:@"turnState"]){
        if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
            NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
            for (NSMutableDictionary *player in players) {
                if([[player objectForKey:@"userID"] isEqualToString:myUserID]){
                    return YES;
                }
            }
            
        }
        
    }
    return NO;
}

-(BOOL)isCurrentGameMyTurn{
    return [self isMyTurn:currentGame];
}

-(BOOL)isGameActive:(NSMutableDictionary *)gameDict{
    return [@"active" isEqualToString:[gameDict valueForKey:@"status"]];
}

-(BOOL)isCurrentGameActive{
    return [self isGameActive:currentGame];
}

-(BOOL)isGamePending:(NSMutableDictionary *)gameDict{
    return [@"pending" isEqualToString:[gameDict valueForKey:@"status"]];
}

-(BOOL)isGameComplete:(NSMutableDictionary *)gameDict{
    return [@"complete" isEqualToString:[gameDict valueForKey:@"status"]];
}


-(BOOL)isCurrentGameComplete{
    return [self isGameComplete:currentGame];
}



-(BOOL)isPlayerMePendingForGame:(NSMutableDictionary *)gameDict{
    if(gameDict){
        if([gameDict objectForKey:@"turnState"]){
            if([[gameDict objectForKey:@"turnState"] objectForKey:@"players"]){
                NSMutableArray *players = [[gameDict objectForKey:@"turnState"] objectForKey:@"players"];
                for (NSMutableDictionary *player in players) {
                    if([[player objectForKey:@"userID"] isEqualToString:myUserID]){
                        if([[player objectForKey:@"status"] isEqualToString:@"pending"]){
                            return YES;
                        }
                    }
                }
                
            }
            
        }
    }
    return NO;
}

-(BOOL)hasEnoughPlayersToStart:(NSMutableDictionary *)gameDict{
    int pendingPlayers = 0;
    NSMutableArray *players = [[gameDict objectForKey:@"turnState"] objectForKey:@"players"];
    if([[gameDict valueForKey:@"status"] isEqualToString:@"pending"]){
        if([gameDict objectForKey:@"turnState"]){
            if([[gameDict objectForKey:@"turnState"] objectForKey:@"players"]){
                
                
                for (NSMutableDictionary *player in players) {
                    if([[player objectForKey:@"status"] isEqualToString:@"pending"]){
                        pendingPlayers++;
                    }
                }
                
            }
            
        }
    }
    if([[[gameDict valueForKey:@"gameSettings"] valueForKey:@"type"] isEqualToString:@"cash"] && [players count] - pendingPlayers > 1){
        return YES;
    }else if([[[gameDict valueForKey:@"gameSettings"] valueForKey:@"type"] isEqualToString:@"tournament"] && pendingPlayers == 0){
        return YES;
    }
    
    return NO;
    
}

-(NSString *)getLastUpdatedGamesMessage{
    return  [NSString stringWithFormat:@"Updated %@",[self dateDiff:[[NSUserDefaults standardUserDefaults] objectForKey:@"games_updated_date"]]];
}

-(NSMutableArray *)getTurnStatePlayersForGame:(NSMutableDictionary *)game{
    
    if(game){
        if([game objectForKey:@"turnState"]){
            if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
                return (NSMutableArray *)[[game objectForKey:@"turnState"] objectForKey:@"players"];
            }
            
        }
    }
    return nil;
    
}

-(NSMutableArray *)getPlayersForCurrentGame{
    return [self getTurnStatePlayersForGame:currentGame];
    
}

-(NSMutableDictionary *)getPlayerMeForGame:(NSMutableDictionary *)game{
    
    if(game){
        if([game objectForKey:@"turnState"]){
            if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
                NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
                for (NSMutableDictionary *player in players) {
                    if([[player objectForKey:@"userID"] isEqualToString:myUserID]){
                        return player;
                    }
                }

            }
            
        }
    }
    return nil;
    
}


-(NSMutableDictionary *)getCurrentPlayerForCurrentGame{
    return [self getCurrentPlayerForGame:currentGame];
}

-(NSMutableDictionary *)getCurrentPlayerForGame:(NSMutableDictionary *)game{
    
    if(game){
        if([game objectForKey:@"turnState"]){
            if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
                NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
                for (NSMutableDictionary *player in players) {
                    if([[player objectForKey:@"userID"] isEqualToString:currentTurnUserID]){
                        return player;
                    }
                }
                
            }
            
        }
    }
    return nil;
    
}



-(BOOL)isCurrentGameTypeCash{
    if([currentGame objectForKey:@"gameSettings"] && [@"cash" isEqualToString:[[currentGame objectForKey:@"gameSettings"] objectForKey:@"type"]]){
        return YES;
        
    }
    return NO;
}

-(NSMutableDictionary *)getPlayerMeForCurrentGame{
    return [self getPlayerMeForGame:currentGame];
}

-(NSMutableDictionary *)getPlayerStateMeForCurrentGame{
    return [[self getPlayerMeForGame:currentGame] objectForKey:@"playerState"];
    
}

-(NSMutableDictionary *)getPlayerStateCurrentTurnForCurrentGame{
    
    if([currentGame objectForKey:@"turnState"]){
        if([[currentGame objectForKey:@"turnState"] objectForKey:@"players"]){
            NSMutableArray *players = [[currentGame objectForKey:@"turnState"] objectForKey:@"players"];
            for (NSMutableDictionary *player in players) {
                if([[player objectForKey:@"userID"] isEqualToString:currentTurnUserID]){
                    return [player objectForKey:@"playerState"];
                }
            }
            
        }
        
    }
    
    return [[self getPlayerMeForGame:currentGame] objectForKey:@"playerState"];
    
}



-(NSString *)getCurrentPlayersTurn{
    return [self getPlayersTurnForGame:self.currentGame];
}

-(NSString *)getPlayersTurnForGame:(NSMutableDictionary *)game{
    if(game){
        if([game objectForKey:@"turnState"]){
            if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
                NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
                for (NSMutableDictionary *player in players) {
                    //NSLog(@"PLAYER:%@",player);
                    //NSLog(@"GAME:%@",game);
                    if([[player objectForKey:@"userID"] isEqualToString:[game objectForKey:@"nextActionForUserID"]]){
                        if([self.myUserID isEqualToString:[player objectForKey:@"userID"]]){
                            return @"Your";
                        }else{
                            return [NSString stringWithFormat:@"%@'s",[player objectForKey:@"userName"]];
                        }
                    }
                }
                
            }
        }
    }
    return @"N/A";
}

-(NSMutableDictionary *)getPlayerForID:(NSString *)userID game:(NSMutableDictionary *)game{
    if(game){
        if([game objectForKey:@"turnState"]){
            if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
                NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
                for (NSMutableDictionary *player in players) {
                    if([[player objectForKey:@"userID"] isEqualToString:userID]){
                        return player;
                    }
                }
                
            }
            
        }
    }
    return nil;
}

-(NSMutableDictionary *)getPlayerForIDCurrentGame:(NSString *)userID{
    return [self getPlayerForID:userID game:currentGame];
}


-(double)getPotEntryForUser:(NSString *)userID hand:(NSMutableDictionary *)hand{
    double potEntry = 0;
    
    for (NSMutableDictionary *round in [self getRoundsForHand:hand]) {
        if([[round valueForKey:@"userID"] isEqualToString:userID]){
            potEntry = potEntry + [[round valueForKey:@"amount"] doubleValue];
        }
    }
    return potEntry;
}




//game details

-(NSMutableArray *)getHandsForCurrentGame{
    
    if(currentGame && [currentGame objectForKey:@"gameState"]){
        return [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
    }
    
    return nil;

}

-(NSMutableArray *)getRoundsForHand:(NSMutableDictionary *)hand{
    
    if(hand){
        return [hand objectForKey:@"rounds"];
    }
    
    return nil;
}


-(NSMutableDictionary *)lastRoundForPlayer:(NSString *)userID{
    
    NSMutableArray *rounds = [self getRoundsForHand:currentHand];
    for (int i = 0; i < rounds.count; i++) {
        NSMutableDictionary *round = [rounds objectAtIndex:i];
        if([userID isEqualToString:[round objectForKey:@"userID"]]){
            return round;
        }
    }
    return nil;
}

-(void)postRound:(NSMutableDictionary *)round{
    [self.currentGame setValue:@"" forKey:@"lastActionMessage"];
    int handState = [[currentHand objectForKey:@"state"] intValue];
    NSMutableDictionary *currentPlayerState = [[[DataManager sharedInstance] getCurrentPlayerForCurrentGame] objectForKey:@"playerState"];
    NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
    if([hands count] > 0){
        self.currentHand = [hands objectAtIndex:0];
    }
    [currentPlayerState setValue:[round valueForKey:@"action"] forKey:@"action"];
    [currentPlayerState setValue:[NSString stringWithFormat:@"%d",handState] forKey:@"lastBetHandState"];
    [betRound setValue:[round valueForKey:@"callAmount"] forKey:@"callAmount"];
    [betRound setValue:[round valueForKey:@"raiseAmount"] forKey:@"raiseAmount"];
    [betRound setValue:[round valueForKey:@"amount"] forKey:@"amount"];
    [betRound setValue:[round valueForKey:@"action"] forKey:@"action"];
    [betRound setValue:[NSString stringWithFormat:@"%d",handState] forKey:@"handState"];
    double currentPotSize = [[currentHand objectForKey:@"potSize"] doubleValue];
    currentPotSize = currentPotSize + [[round valueForKey:@"amount"] doubleValue];
    [currentHand setValue:[NSString stringWithFormat:@"%.2f",currentPotSize] forKey:@"potSize"];
    [betRound setValue:[currentPlayerState valueForKey:@"cardOne"] forKey:@"cardOne"];
    [betRound setValue:[currentPlayerState valueForKey:@"cardTwo"] forKey:@"cardTwo"];
    double userStack = [[currentPlayerState objectForKey:@"userStack"] doubleValue];
    double betAmount = [[round valueForKey:@"amount"] doubleValue];
    userStack = userStack - betAmount;
    [betRound setValue:[NSString stringWithFormat:@"%.2f",userStack] forKey:@"userStack"];
    [currentPlayerState setValue:[NSString stringWithFormat:@"%.2f",userStack] forKey:@"userStack"];
    [betRound setValue:@"NO" forKey:@"MY_BET_ROUND"];
    
    
    // must determine if the pot is even with equal bets
    NSMutableArray *rounds = [currentHand valueForKey:@"rounds"];
    NSMutableDictionary *betAmounts = [[NSMutableDictionary alloc] init];
    NSString *compareAmount;
    int numOfBettingRounds = 0;
    for (int i = 0; i < rounds.count; i++) {
        NSMutableDictionary *round = [rounds objectAtIndex:i];
        //NSLog(@"round %d:%@",i,round);
        if([[round valueForKey:@"handState"] intValue] == handState){
            double userBetAmount = [[betAmounts valueForKey:[round valueForKey:@"userID"]] doubleValue];
            userBetAmount = userBetAmount + [[round valueForKey:@"amount"] doubleValue];
            if([[round valueForKey:@"action"] isEqualToString:@"fold"]){
                [betAmounts setValue:@"fold" forKey:[round valueForKey:@"userID"]];
            }else if([[round valueForKey:@"userStack"] doubleValue] == 0){
                [betAmounts setValue:@"allIn" forKey:[round valueForKey:@"userID"]];
            }else{
                numOfBettingRounds++;
                if(![@"fold" isEqualToString:[betAmounts valueForKey:[round valueForKey:@"userID"]]] && ![@"allIn" isEqualToString:[betAmounts valueForKey:[round valueForKey:@"userID"]]]){
                    compareAmount = [NSString stringWithFormat:@"%.2f",userBetAmount];
                    [betAmounts setValue:[NSString stringWithFormat:@"%.2f",userBetAmount] forKey:[round valueForKey:@"userID"]];
                }
            }
        }
    }
    
    BOOL hasAllValidPlayersActedOnHand = YES;
    NSMutableArray *players = [self getPlayersForCurrentGame];
    for (NSMutableDictionary *player in players) {
        if([self canPlayerBet:player] && [[[player valueForKey:@"playerState"] valueForKey:@"lastBetHandState"] intValue] != handState){
            hasAllValidPlayersActedOnHand = NO;
        }
    }
    

    //NSLog(@"betAmounts:%@",betAmounts);
    BOOL increaseHandState = hasAllValidPlayersActedOnHand;
    if(increaseHandState){
        for(NSString *aKey in betAmounts){
            NSLog(@"betAmount:%@  compareAmount:%@",[betAmounts valueForKey:aKey],compareAmount);
            if(![[betAmounts valueForKey:aKey] isEqualToString:compareAmount] && ![@"fold" isEqualToString:[betAmounts valueForKey:aKey]] && ![@"allIn" isEqualToString:[betAmounts valueForKey:aKey]]){
                //not all the pots are equal, let them keep betting or checking
                increaseHandState = NO;
            }
        }
    }
    
    NSMutableDictionary *nextPlayersTurn = [self getNextTurnPlayerFromCurrentGame:increaseHandState];
    if(increaseHandState){
        handState++;
        if(handState == 2){
            [self.betRound setValue:@"FLOP" forKey:@"HAND_STATE"];
        }else if(handState == 3){
            [self.betRound setValue:@"TURN" forKey:@"HAND_STATE"];
        }else if(handState == 4){
            [self.betRound setValue:@"RIVER" forKey:@"HAND_STATE"];
        }
        [currentHand setValue:[NSString stringWithFormat:@"%d",handState] forKey:@"state"];
    }
    [self.currentGame setValue:[nextPlayersTurn objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    
    
    NSMutableArray *winners = [self determineWinners:currentGame evenPot:increaseHandState];
    //NSLog(@"winner:%@",winners);
    if(winners && [winners count] > 0){
        double highestWinnerAmount = 0;
        NSString *highestWinnerName = @"";
        for (NSMutableDictionary *winner in winners) {
            if([[winner valueForKey:@"amount"] doubleValue] > highestWinnerAmount){
                highestWinnerAmount = [[winner valueForKey:@"amount"] doubleValue];
                highestWinnerName = [winner valueForKey:@"userName"];
            }
            NSMutableDictionary *playerState = [[self getPlayerForID:[winner valueForKey:@"userID"] game:currentGame] valueForKey:@"playerState"];
            double newUserStack = [[playerState valueForKey:@"userStack"] doubleValue] + [[winner valueForKey:@"amount"] doubleValue];
            [playerState setValue:[NSString stringWithFormat:@"%.2f",newUserStack] forKey:@"userStack"];
        }
        [currentHand setValue:[NSString stringWithFormat:@"%d",5] forKey:@"state"];
        [currentHand setValue:winners forKey:@"winners"];
        
        //update show hands 
        for (int i = 0; i < rounds.count; i++) {
            NSMutableDictionary *round = [rounds objectAtIndex:i];
            NSMutableDictionary *playerStateForRound = [[self getPlayerForIDCurrentGame:[round valueForKey:@"userID"]] valueForKey:@"playerState"];
            if(![[playerStateForRound valueForKey:@"action"] isEqualToString:@"fold"]){
                [round setValue:@"YES" forKey:@"showCards"];
            }
        }
        
        /*
         APN
         */
        NSMutableArray *losersArray = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
            BOOL isPlayerWinner = NO;
            for (NSMutableDictionary *winner in winners) {
                if([[winner valueForKey:@"userID"] isEqualToString:[player valueForKey:@"userID"]]){
                    isPlayerWinner = YES;
                    NSMutableArray *winnerPlayer = [[NSMutableArray alloc] init];
                    [winnerPlayer addObject:[player valueForKey:@"userID"]];
                    NSString *message = [NSString stringWithFormat:@"You won $%@!",[winner valueForKey:@"amount"]] ;
                    
                    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
                    [payLoad setValue:currentGameID forKey:@"gameID"];
                    [self sendAPN:winnerPlayer message:message payLoad:payLoad];
                }
            }
            if(!isPlayerWinner){
                [losersArray addObject:[player valueForKey:@"userID"]];
            }    
        }
        
        if([losersArray count] > 0){
            NSString *message = [NSString stringWithFormat:@"%@ won $%.2f",highestWinnerName,highestWinnerAmount] ;
            NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
            [payLoad setValue:currentGameID forKey:@"gameID"];
            [self sendAPN:losersArray message:message payLoad:payLoad];
        }
        [self dealNewHand];
    }else{
        //determine action message for APN
        NSString *actionMessage = @"";
        if([[round valueForKey:@"action"] isEqualToString:@"raise"]){
            actionMessage = [NSString stringWithFormat:@"%@ raised to $%@",myUserName,[round valueForKey:@"amount"]]; 
        }else if([[round valueForKey:@"action"] isEqualToString:@"call"]){
            actionMessage = [NSString stringWithFormat:@"%@ called $%@",myUserName,[round valueForKey:@"amount"]];
        }else if([[round valueForKey:@"action"] isEqualToString:@"check"]){
            actionMessage = [NSString stringWithFormat:@"%@ checked",myUserName];
        }else if([[round valueForKey:@"action"] isEqualToString:@"fold"]){
            actionMessage = [NSString stringWithFormat:@"%@ folded",myUserName];
        }
        [self.currentGame setValue:actionMessage forKey:@"lastActionMessage"];
        [self updateCurrentGame];
    }
}



-(NSMutableArray *)determineWinners:(NSMutableDictionary *)game evenPot:(BOOL)evenPot{
    int handState = [[currentHand objectForKey:@"state"] intValue];
    
    //see if there is a winner due to folding
    int remainingPlayers = 0;
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    NSMutableDictionary *lastManWinner;
    NSMutableArray *communityCards = [currentHand valueForKey:@"communityCards"];
    int playerWithMoneyLeft = 0;
    for (NSMutableDictionary *player in [[game valueForKey:@"turnState"] valueForKey:@"players"]) {
        NSMutableDictionary *playerState = [player valueForKey:@"playerState"];
       // NSLog(@"playerState:%@",playerState);
        if([@"playing" isEqualToString:[player valueForKey:@"status"]] && ![@"fold" isEqualToString:[playerState objectForKey:@"action"]]){
            remainingPlayers++;
            lastManWinner = player;
        }
        
        if([self canPlayerBet:player]){
            playerWithMoneyLeft++;
        }
    }
    
    //NSMutableDictionary *currentPlayerState = [[self getCurrentPlayerForCurrentGame] valueForKey:@"playerState"];
   // NSLog(@"currentPlayerState:%@",currentPlayerState);
    if(playerWithMoneyLeft <  2 && evenPot){
        handState = 5;
    }
    
    
    
    if(remainingPlayers==1){
        NSMutableDictionary *winner = [[NSMutableDictionary alloc] init];
        [winner setValue:[lastManWinner valueForKey:@"userID"] forKey:@"userID"];
        [winner setValue:[lastManWinner valueForKey:@"userName"] forKey:@"userName"];
        [winner setValue:[currentHand valueForKey:@"potSize"] forKey:@"amount"];
        [winner setValue:@"USER_FOLD" forKey:@"type"];
        [winners addObject:winner];
        return winners;
    }else if(handState == 5){
        NSMutableArray *hands = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *player in [[game valueForKey:@"turnState"] valueForKey:@"players"]) {
            NSMutableDictionary *playerState = [player valueForKey:@"playerState"];
            if([@"playing" isEqualToString:[player valueForKey:@"status"]] && ![@"fold" isEqualToString:[playerState objectForKey:@"action"]]){
                NSMutableArray *playerCards = [NSMutableArray arrayWithObjects:[playerState objectForKey:@"cardOne"],[playerState objectForKey:@"cardTwo"], nil];
                [playerCards addObjectsFromArray:communityCards];
                //NSLog(@"playerCards:%@",playerCards);
                Hand *hand = [[Hand alloc] initWithCards:playerCards];
                [hand setUserID:[player valueForKey:@"userID"]];
                [hand setUserName:[player valueForKey:@"userName"]];
                [hands addObject:hand];
            }
        }
        
        int maxHandValue=0;
        for (Hand *hand in hands) {
            if(hand.value > maxHandValue){
                maxHandValue = hand.value;
            }
        }
        
        for (Hand *hand in hands) {
            if(hand.value == maxHandValue){
                NSMutableDictionary *winner = [[NSMutableDictionary alloc] init];
                [winner setValue:[hand userID] forKey:@"userID"];
                [winner setValue:[hand userName] forKey:@"userName"];
                [winner setValue:[hand type] forKey:@"type"];
                [winner setValue:[currentHand valueForKey:@"potSize"] forKey:@"amount"];
                [winners addObject:winner];
            }
        }
        return winners;
        
    }
    
    
    return nil;
}


-(BOOL)canPlayerBet:(NSMutableDictionary *)player{
    if(player && [[player valueForKey:@"status"] isEqualToString:@"playing"] && [player valueForKey:@"playerState"]){
        if(![[[player valueForKey:@"playerState"] valueForKey:@"action"] isEqualToString:@"fold"]){
            if([[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] > 0){
                return YES;
            }
        }
    }
    return NO;
}

-(NSMutableDictionary *)getNextTurnPlayerFromCurrentGame:(BOOL)isFirstActor{
    

    int currentPlayerOrder = 0;
    int nextPlayerOrder = 0;
    NSMutableDictionary *nextPlayer = nil;
    
    NSMutableArray *players = [self getPlayersForCurrentGame];
    if(isFirstActor){
        for (NSMutableDictionary *player in players) {
            if([[[player valueForKey:@"playerState"] valueForKey:@"isDealer"] isEqualToString:@"YES"]){
                currentPlayerOrder = [[player valueForKey:@"order"] intValue];
            }
        }
    }else{
        currentPlayerOrder = [[[[DataManager sharedInstance] getPlayerForID:[currentGame objectForKey:@"nextActionForUserID"] game:currentGame] objectForKey:@"order"] intValue];
    }
    
    nextPlayerOrder = currentPlayerOrder + 1;
    while(nextPlayerOrder !=currentPlayerOrder){
        
        
        
        if(nextPlayerOrder > players.count){
            nextPlayerOrder = 0;
        }
        
        for (int i = 0; i < players.count;i++) {
            
            nextPlayer = [players objectAtIndex:i];
            if(nextPlayerOrder == [[nextPlayer objectForKey:@"order"] intValue] && [self canPlayerBet:nextPlayer]){
                NSLog(@"nextPlayer:%@",nextPlayer);
                return nextPlayer;
            }
        }
        
        nextPlayerOrder++;
        
        
        
    }
    return nextPlayer;
}




-(void)createNewGame:(NSMutableDictionary *)game{
    //invite via APN
    NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
    NSMutableArray *invitePlayers = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *player in players) {
        if(![[player valueForKey:@"userID"] isEqualToString:myUserID]){
            [invitePlayers addObject:[player valueForKey:@"userID"]];
        }
    }
    NSString *message = [NSString stringWithFormat:@"%@ has invited you to a %@ game",myUserName,NSLocalizedString([[game valueForKey:@"gameSettings"] valueForKey:@"type"],nil)] ;
    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
    [payLoad setValue:currentGameID forKey:@"gameID"];
    [self sendAPN:invitePlayers message:message payLoad:payLoad];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:game options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] createGame:jsonString];
    if(![@"1" isEqualToString:[results objectForKey:@"success"]]){
        NSLog(@"There was an error creating the game:%@",results);
    }
 
    [self arrangeUserGames];
    
}

-(void)leaveCurrentGame{
    [self deleteGame:currentGame];    
}


-(BOOL)isGameWaitingForOtherPlayers:(NSMutableDictionary *)game{
    
    NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
    int numOfPlayingPlayers = 0;
    for(int i = 0; i < players.count;i++){
        NSMutableDictionary *player = [players objectAtIndex:i];
        
        if([[player objectForKey:@"status"] isEqualToString:@"playing"] || [[player objectForKey:@"status"] isEqualToString:@"buyin"]){
            numOfPlayingPlayers++;
        }
        
        if([[player objectForKey:@"userID"] isEqualToString:myUserID] && ([[player objectForKey:@"status"] isEqualToString:@"pending"] || [[player objectForKey:@"status"] isEqualToString:@"sitout"])){
            return NO;
        }
    }
    
    NSString *gameType = [[game objectForKey:@"gameSettings"] objectForKey:@"type"];
    
    if([@"cash" isEqualToString:gameType]){
        return numOfPlayingPlayers < 2;
    }else if([@"tournament" isEqualToString:gameType]){
        return numOfPlayingPlayers != players.count;
    }

    return NO;
}

-(BOOL)canStartGame:(NSMutableDictionary *)game{
    
    if([[game objectForKey:@"status"] isEqualToString:@"pending"] && [[game objectForKey:@"gameOwnerID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        if(![self isGameWaitingForOtherPlayers:game]){
            return YES;
            
        }
    }
    return NO;
}

-(void)buyInToCurrentGame:(NSMutableDictionary *)playerState{
    NSMutableDictionary *currentPlayer = [self getCurrentPlayerForCurrentGame];
    [currentPlayer setValue:@"buyin" forKey:@"status"];
    [currentPlayer setValue:playerState forKey:@"playerState"];
    [self updatePlayer:currentPlayer];
}


-(void)startCurrentGame{
   
    NSMutableDictionary *gameState = [[NSMutableDictionary alloc] init];
    if(![currentGame valueForKey:@"gameState"] || ![[currentGame valueForKey:@"gameState"] valueForKey:@"hands"]){
        NSMutableArray *hands = [[NSMutableArray alloc] initWithCapacity:1];
        [gameState setValue:hands forKey:@"hands"];
        [currentGame setValue:gameState forKey:@"gameState"];
    }
    
    [self dealNewHand];
    [currentGame setValue:@"active" forKey:@"status"];
     //NSLog(@"currentGame:%@",currentGame);
    [self updateCurrentGame];
    
}

-(void)dealNewHand{
    NSMutableArray *players = [self getPlayersForCurrentGame];
    NSMutableDictionary *gameSummary = [[currentGame valueForKey:@"gameState"] valueForKey:@"gameSummary"];
    if(!gameSummary){
        gameSummary = [[NSMutableDictionary alloc] init];
        [[currentGame valueForKey:@"gameState"] setValue:gameSummary forKey:@"gameSummary"];
    }
    int numPlayingPlayers = 0;
    for (NSMutableDictionary *player in players) {
        if([[player objectForKey:@"status"] isEqualToString:@"buyin"]){
            NSLog(@"player:%@",player);
            double buyInSummary = [[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue];
            buyInSummary = buyInSummary + [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
            [player setValue:@"playing" forKey:@"status"];
            [gameSummary setValue:[NSString stringWithFormat:@"%.2f",buyInSummary] forKey:[player valueForKey:@"userID"]];
        }
        [[player objectForKey:@"playerState"] setValue:@"in" forKey:@"action"];
        [[player objectForKey:@"playerState"] setValue:@"0" forKey:@"lastBetHandState"];
        if([[[player objectForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] <= 0){
            [player setValue:@"pending" forKey:@"status"];
        }
        
        if([[player objectForKey:@"status"] isEqualToString:@"playing"]){
            numPlayingPlayers++;
        }
    }
    
    
    if(![self hasCurrentGameMoreHands]){
        [currentGame setValue:@"complete" forKey:@"status"];
        [self updateCurrentGame];
        return;
    }
    if(numPlayingPlayers <= 1){
        //not enough players left, need to change game to pending
        [currentGame setValue:@"pending" forKey:@"status"];
        [self updateCurrentGame];
        return;
    }
    
    NSMutableDictionary *hand = [[NSMutableDictionary alloc] init];
    
    double smallBlind = [[[currentGame objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    double bigBlind = [[[currentGame objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] doubleValue];
    
    
    
    double potSize = smallBlind + bigBlind;
    [hand setValue:@"1" forKey:@"state"];
    int handNumber = [(NSMutableArray *)[[currentGame objectForKey:@"gameState"] objectForKey:@"hands"] count];
    handNumber++;
    [hand setValue:[NSString stringWithFormat:@"%d",handNumber] forKey:@"number"];
    [hand setValue:[NSString stringWithFormat:@"%.2f",potSize] forKey:@"potSize"];
    [self resetDeck];
    
    NSMutableArray *communityCards = [[NSMutableArray alloc] init];
    [communityCards addObject:[self getRandomCardFromDeck]];
    [communityCards addObject:[self getRandomCardFromDeck]];
    [communityCards addObject:[self getRandomCardFromDeck]];
    [communityCards addObject:[self getRandomCardFromDeck]];
    [communityCards addObject:[self getRandomCardFromDeck]];
    [hand setValue:communityCards forKey:@"communityCards"];
    
    NSMutableDictionary *dealerPlayer = [self getNextDealerPlayer];
    NSLog(@"Dealer Player:%@",[dealerPlayer valueForKey:@"userName"]);
    int numOfPlayingPlayers = 0;
    for (NSMutableDictionary *player in players) {
        if([[player objectForKey:@"status"] isEqualToString:@"playing"]){
            numOfPlayingPlayers++;
            [[player valueForKey:@"playerState"] setValue:[self getRandomCardFromDeck] forKey:@"cardOne"];
            [[player valueForKey:@"playerState"] setValue:[self getRandomCardFromDeck] forKey:@"cardTwo"];
            [[player valueForKey:@"playerState"] setValue:@"NO" forKey:@"isDealer"];
            [[player valueForKey:@"playerState"] setValue:@"NO" forKey:@"isSmallBlind"];
            [[player valueForKey:@"playerState"] setValue:@"NO" forKey:@"isBigBlind"];
            [[player valueForKey:@"playerState"] setValue:@"in" forKey:@"action"];
        }
    }
    if(numOfPlayingPlayers < 2){
        NSLog(@"Game Over!");
        [self updateCurrentGame];
        return;
    }
    NSMutableArray *rounds = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dealerRound = [[NSMutableDictionary alloc] init];
    
    [currentGame setValue:[dealerPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    [[dealerPlayer valueForKey:@"playerState"] setValue:@"YES" forKey:@"isDealer"];
    [dealerRound setValue:@"0" forKey:@"potSize"];
    [dealerRound setValue:@"dealer" forKey:@"action"];
    [dealerRound setValue:@"YES" forKey:@"isDealer"];
    [dealerRound setValue:[[dealerPlayer objectForKey:@"playerState"] objectForKey:@"userStack"] forKey:@"userStack"];
    [dealerRound setValue:[[dealerPlayer objectForKey:@"playerState"] objectForKey:@"cardOne"] forKey:@"cardOne"];
    [dealerRound setValue:[[dealerPlayer objectForKey:@"playerState"] objectForKey:@"cardTwo"] forKey:@"cardTwo"];
    [dealerRound setValue:[dealerPlayer valueForKey:@"userID"] forKey:@"userID"];
    [dealerRound setValue:[dealerPlayer valueForKey:@"userName"] forKey:@"userName"];
    [dealerRound setValue:@"NO" forKey:@"showCards"];
    [dealerRound setValue:@"0" forKey:@"amount"];
    [dealerRound setValue:@"1" forKey:@"handState"];
    //NSLog(@"dealerRound:%@",dealerRound);
    [rounds insertObject:dealerRound atIndex:0];
    
    
    NSMutableDictionary *smallBlindRound = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *smallBlindPlayer = [self getNextTurnPlayerFromCurrentGame:NO];
    NSLog(@"smallBlindPlayer:%@",[smallBlindPlayer valueForKey:@"userName"]);
    [currentGame setValue:[smallBlindPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    [[smallBlindPlayer valueForKey:@"playerState"] setValue:@"YES" forKey:@"isSmallBlind"];
    
    [smallBlindRound setValue:@"0" forKey:@"potSize"];
    [smallBlindRound setValue:@"smallBlind" forKey:@"action"];
    double userStackSmallBlind = [[[smallBlindPlayer objectForKey:@"playerState"] objectForKey:@"userStack"] doubleValue];
    userStackSmallBlind = userStackSmallBlind - smallBlind;
    [smallBlindRound setValue:[NSString stringWithFormat:@"%.2f",userStackSmallBlind] forKey:@"userStack"];
    [[smallBlindPlayer valueForKey:@"playerState"] setValue:[NSString stringWithFormat:@"%.2f",userStackSmallBlind] forKey:@"userStack"];
    [smallBlindRound setValue:[[smallBlindPlayer objectForKey:@"playerState"] objectForKey:@"cardOne"] forKey:@"cardOne"];
    [smallBlindRound setValue:[[smallBlindPlayer objectForKey:@"playerState"] objectForKey:@"cardTwo"] forKey:@"cardTwo"];
    
    [smallBlindRound setValue:[smallBlindPlayer valueForKey:@"userID"] forKey:@"userID"];
    [smallBlindRound setValue:[smallBlindPlayer valueForKey:@"userName"] forKey:@"userName"];
    [smallBlindRound setValue:@"NO" forKey:@"showCards"];
    [smallBlindRound setValue:[NSString stringWithFormat:@"%.2f",smallBlind] forKey:@"amount"];
    [smallBlindRound setValue:@"0" forKey:@"callAmount"];
    [smallBlindRound setValue:[NSString stringWithFormat:@"%.2f",smallBlind] forKey:@"raiseAmount"];
    [smallBlindRound setValue:@"1" forKey:@"handState"];
    [rounds insertObject:smallBlindRound atIndex:0];
    
    
    NSMutableDictionary *bigBlindRound = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bigBlindPlayer = [self getNextTurnPlayerFromCurrentGame:NO];
    NSLog(@"bigBlindPlayer:%@",[bigBlindPlayer valueForKey:@"userName"]);
    [currentGame setValue:[bigBlindPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    [[bigBlindPlayer valueForKey:@"playerState"] setValue:@"YES" forKey:@"isBigBlind"];
    [bigBlindRound setValue:@"0" forKey:@"potSize"];
    [bigBlindRound setValue:@"bigBlind" forKey:@"action"];
    double userStackBigBlind = [[[bigBlindPlayer objectForKey:@"playerState"] objectForKey:@"userStack"] doubleValue];
    userStackBigBlind = userStackBigBlind - bigBlind;
    [bigBlindRound setValue:[NSString stringWithFormat:@"%.2f",userStackBigBlind] forKey:@"userStack"];
    [[bigBlindPlayer valueForKey:@"playerState"] setValue:[NSString stringWithFormat:@"%.2f",userStackBigBlind] forKey:@"userStack"];
    
    [bigBlindRound setValue:[[bigBlindPlayer objectForKey:@"playerState"] objectForKey:@"cardOne"] forKey:@"cardOne"];
    [bigBlindRound setValue:[[bigBlindPlayer objectForKey:@"playerState"] objectForKey:@"cardTwo"] forKey:@"cardTwo"];
    [bigBlindRound setValue:[[bigBlindPlayer objectForKey:@"playerState"] objectForKey:@"isDealer"] forKey:@"isDealer"];
    [bigBlindRound setValue:[bigBlindPlayer valueForKey:@"userID"] forKey:@"userID"];
    [bigBlindRound setValue:[bigBlindPlayer valueForKey:@"userName"] forKey:@"userName"];
    [bigBlindRound setValue:@"NO" forKey:@"showCards"];
    [bigBlindRound setValue:[NSString stringWithFormat:@"%.2f",bigBlind] forKey:@"amount"];
    [bigBlindRound setValue:[NSString stringWithFormat:@"%.2f",smallBlind] forKey:@"callAmount"];
    [bigBlindRound setValue:[NSString stringWithFormat:@"%.2f",bigBlind-smallBlind] forKey:@"raiseAmount"];
    [bigBlindRound setValue:@"1" forKey:@"handState"];
    [rounds insertObject:bigBlindRound atIndex:0];
    
    
    NSMutableDictionary *nextPlayer = [self getNextTurnPlayerFromCurrentGame:NO];
    NSLog(@"nextPlayer:%@",[nextPlayer valueForKey:@"userName"]);
    [currentGame setValue:[nextPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    
    [hand setValue:rounds forKey:@"rounds"];
    
    
    [(NSMutableArray *)[[currentGame valueForKey:@"gameState"] valueForKey:@"hands"] insertObject:hand atIndex:0];
    self.currentHand = hand;
    //[self addBettingRoundIfNeeded];
    [self updateCurrentGame];
    
}


-(BOOL)hasCurrentGameMoreHands{
    
    if([self isCurrentGameTypeCash]){
        int numOfHands =[[[currentGame valueForKey:@"gameSettings"] valueForKey:@"numOfHands"] intValue];
        int currentHandNum = [[currentHand valueForKey:@"number"] intValue];
        if(numOfHands <=currentHandNum){
            return NO;
        }
    }
    return YES;
}

-(NSMutableDictionary *)getNextDealerPlayer{
    
    NSMutableArray *players = [self getPlayersForCurrentGame];
    for (NSMutableDictionary *player in players) {
        NSMutableDictionary *playerState = [player objectForKey:@"playerState"];
        if([playerState objectForKey:@"isDealer"] && [@"YES" isEqualToString:[playerState objectForKey:@"isDealer"]]){
            [currentGame setValue:[player objectForKey:@"userID"] forKey:@"nextActionForUserID"];
            return [self getNextTurnPlayerFromCurrentGame:NO];
        }
       
    }
    return [self getCurrentPlayerForCurrentGame];
    
    
    
}

-(NSString *)getRandomCardFromDeck{
    int number = (arc4random()%[deck count]);
    NSString *card = [deck objectAtIndex:number];
    [deck removeObjectAtIndex:number];
    return card;
}


-(void)resetDeck{
    [deck removeAllObjects];
     [deck addObject:@"2C"];
     [deck addObject:@"2D"];
     [deck addObject:@"2H"];
     [deck addObject:@"2S"];
     [deck addObject:@"3C"];
     [deck addObject:@"3D"];
     [deck addObject:@"3H"];
     [deck addObject:@"3S"];
     [deck addObject:@"4C"];
     [deck addObject:@"4D"];
     [deck addObject:@"4H"];
     [deck addObject:@"4S"];
     [deck addObject:@"5C"];
     [deck addObject:@"5D"];
     [deck addObject:@"5H"];
     [deck addObject:@"5S"];
     [deck addObject:@"6C"];
     [deck addObject:@"6D"];
     [deck addObject:@"6H"];
     [deck addObject:@"6S"];
     [deck addObject:@"7C"];
     [deck addObject:@"7D"];
     [deck addObject:@"7H"];
     [deck addObject:@"7S"];
     [deck addObject:@"8C"];
     [deck addObject:@"8D"];
     [deck addObject:@"8H"];
     [deck addObject:@"8S"];
     [deck addObject:@"9C"];
     [deck addObject:@"9D"];
     [deck addObject:@"9H"];
     [deck addObject:@"9S"];
     [deck addObject:@"TC"];
     [deck addObject:@"TD"];
     [deck addObject:@"TH"];
     [deck addObject:@"TS"];
     [deck addObject:@"JC"];
     [deck addObject:@"JD"];
     [deck addObject:@"JH"];
     [deck addObject:@"JS"];
     [deck addObject:@"QC"];
     [deck addObject:@"QD"];
     [deck addObject:@"QH"];
     [deck addObject:@"QS"];
     [deck addObject:@"KC"];
     [deck addObject:@"KD"];
     [deck addObject:@"KH"];
     [deck addObject:@"KS"];
     [deck addObject:@"AC"];
     [deck addObject:@"AD"];
     [deck addObject:@"AH"];
     [deck addObject:@"AS"];
    
}

-(NSString *)getNextPlayerOrderForGame:(NSMutableDictionary *)game{
    
    NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
    int maxOrder = 0;
    for (NSMutableDictionary *player in players) {
        if([[player valueForKey:@"order"] intValue] > maxOrder){
            maxOrder = [[player valueForKey:@"order"] intValue];
        }
        
    }
    maxOrder++;
    return [NSString stringWithFormat:@"%d",maxOrder];
}









//util

-(NSString *)dateDiff:(NSDate *)origDate {

    NSDate *todayDate = [NSDate date];
    double ti = [origDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"";
    } else      if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }   
}




/*
 Me: call 0 raise 1.00 (raise to 1.00)
 Steve:   call 1.00 raise 1.00 (raise to 2.00)
 Mike:  call 2.00 raise 3.00 (raise to 5.00)
 Me: needs to call 4.00 so sum the raiseAmounts
 
 
 */

-(double)getCallValue{
    
    //NSLog(@"currentHand:%@",self.currentHand);
    
    NSMutableArray *rounds = [self.currentHand objectForKey:@"rounds"];
    double raiseAmountSum = 0;

    for(int i = 1; i < rounds.count; i++){
        NSMutableDictionary *round = [rounds objectAtIndex:i];
        if([[round objectForKey:@"userID"] isEqualToString:currentTurnUserID]){
            
            break;
        }
        
        raiseAmountSum = raiseAmountSum + [[round valueForKey:@"raiseAmount"] doubleValue];
        
        
    }
   
    return raiseAmountSum;
}


-(double)getMinRaiseValue{
    
    double minRaiseValue = [[[currentGame valueForKey:@"gameSettings"] valueForKey:@"bigBlind"] doubleValue];
    NSMutableArray *rounds = [self.currentHand objectForKey:@"rounds"];
    for(int i = 1; i < rounds.count; i++){
        NSMutableDictionary *round = [rounds objectAtIndex:i];
        if([[round objectForKey:@"userID"] isEqualToString:currentTurnUserID]){
            
            break;
        }
        double raiseAmount = [[round valueForKey:@"raiseAmount"] doubleValue];
        if(raiseAmount > minRaiseValue){
            minRaiseValue = raiseAmount;
        }
    }
    
    return minRaiseValue;

    
}

/*
-(double)getCallValueForCurrentPlayer{
    
    
    
    
    //NSLog(@"currentHand:%@",self.currentHand);
    
    NSMutableArray *rounds = [self.currentHand objectForKey:@"rounds"];
    double maxRaise = 0;
    double lastRaise = 0;
    double roundRaise = 0;
    for(int i = 1; i < rounds.count; i++){
        NSMutableDictionary *round = [rounds objectAtIndex:i];
        if([[round objectForKey:@"userID"] isEqualToString:currentTurnUserID]){
            if([[round objectForKey:@"action"] isEqualToString:@"raise"] || [[round objectForKey:@"action"] isEqualToString:@"smallBlind"]){
                lastRaise = [[round objectForKey:@"amount"] doubleValue];
            }
            break;
        }
                
        if(![[round objectForKey:@"action"] isEqualToString:@"call"]){
            roundRaise = [[round objectForKey:@"amount"] doubleValue];
            if(roundRaise > maxRaise){
                maxRaise = roundRaise;
            }

        }
        
    }
    if(maxRaise - lastRaise < 0){
        return 0;
    }
    return maxRaise - lastRaise;
}*/

-(void)setImageBackground: (UIView*)view imageName: (NSString*) imageName topbarHeight: (CGFloat) topbarHeight{
    CGSize size = view.frame.size;
    size.height = size.height;
    UIGraphicsBeginImageContext(size);
    CGRect bounds = view.bounds;
    bounds.origin.y = bounds.origin.y + topbarHeight;
    bounds.size.height = bounds.size.height - topbarHeight;
    [[UIImage imageNamed:imageName] drawInRect:bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(CGFloat)getBottomPadding{
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
       UIWindow *window = UIApplication.sharedApplication.keyWindow;
       bottomPadding = window.safeAreaInsets.bottom + 40;
    }
    return bottomPadding;
}


// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (DataManager *)sharedInstance {
    
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
