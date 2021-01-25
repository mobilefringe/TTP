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
#import "Settings.h"
#import "StoreFront.h"


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
@synthesize favPlayers;
@synthesize deviceTok;
@synthesize newMessagesCount;
@synthesize utcFormatter;
@synthesize lastUpdatedDate;
@synthesize messagesGameID;
@synthesize messages;
@synthesize playerProfile;
@synthesize localAcievements;
@synthesize gameAchievements;
@synthesize showAchievement;
@synthesize addAchievement;
@synthesize isNewDay;
@synthesize showStatCode;
@synthesize tally;
@synthesize myInventory;
@synthesize profileStatues;
@synthesize myProfile;
@synthesize joinGameID;
@synthesize multiPlayerAchievements;
@synthesize avatars;
@synthesize proChipsTotal;
@synthesize proChipsIncrement;
@synthesize products;
@synthesize myProChips;
@synthesize giftUserID;
@synthesize gifts;
@synthesize buyGift;
@synthesize giftUserName;
@synthesize lastLoginDate;
@synthesize isLoggingIn;
@synthesize isUpdatingGame;
@synthesize myDisplayName;
@synthesize myEmail;
@synthesize createGameID;
@synthesize playerProfileLoaded;

static BOOL logging = YES;
static BOOL debugMode = NO;
static BOOL loadFromLocalFile = NO;
static int achivementQueueLimit = 3;


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
        [cardImages setValue:[UIImage imageNamed:@"card_back.png"] forKey:@"?"];

        if(!utcFormatter){
            self.utcFormatter = [[NSDateFormatter alloc] init];
            [utcFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
            NSTimeZone *UTCTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [utcFormatter setTimeZone:UTCTimeZone];
        }
        
        self.deck = [[NSMutableArray alloc] init];
        
        
        NSError *error;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"achievements" ofType:@"json"];  
        NSData *gameData = [NSData dataWithContentsOfFile:filePath];  
        self.gameAchievements = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *filePathProducts = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"json"];  
        NSData *productsData = [NSData dataWithContentsOfFile:filePathProducts];  
        self.products = [NSJSONSerialization JSONObjectWithData:productsData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *giftPathProducts = [[NSBundle mainBundle] pathForResource:@"gifts" ofType:@"json"];  
        NSData *giftsData = [NSData dataWithContentsOfFile:giftPathProducts];  
        self.gifts = [NSJSONSerialization JSONObjectWithData:giftsData options:NSJSONReadingMutableContainers error:&error];
        

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if(![prefs arrayForKey:[NSString stringWithFormat:@"LOCAL_ACHIEVEMENTS_%@",myUserID]]){
            self.localAcievements = [[NSMutableArray alloc] init];
        }else{
            self.localAcievements = [NSMutableArray arrayWithArray:[prefs arrayForKey:[NSString stringWithFormat:@"LOCAL_ACHIEVEMENTS_%@",myUserID]]];
        }
        
        if(![prefs dictionaryForKey:[NSString stringWithFormat:@"LOCAL_TALLY_%@",myUserID]]){
            self.tally = [[NSMutableDictionary alloc] init];
        }else{
            self.tally = [NSMutableDictionary dictionaryWithDictionary:[prefs dictionaryForKey:[NSString stringWithFormat:@"LOCAL_TALLY_%@",myUserID]]];
        }
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
        [apnDict setValue:@"shuffle.wav" forKey:@"sound"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:apnDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"sendAPN Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] sendNotification:jsonString];
        if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
            //NSLog(@"sendAPN Results:%@",results);
        }
        //NSLog(@"sendAPN Results:%@",results);
    });
    
}


#pragma mark - Register & Login

-(NSMutableDictionary *)registerPlayer:(NSMutableDictionary *)playerData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error = nil;
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    [playerData setValue:countryCode forKey:@"countryCode"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] registerPlayer:jsonString];
    //NSLog(@"results:%@",results);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        
        [self processLogin:results playerData:playerData];
        [self registerForAPN];
        [prefs synchronize];
    }
    return results;
    
}

-(NSMutableDictionary *)registerFacebookPlayer:(NSMutableDictionary *)playerData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString:%@",jsonString);
    NSMutableDictionary *results = [[APIDataManager sharedInstance] registerFacebookPlayer:jsonString];
    //NSLog(@"results:%@",results);
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        [self processLogin:results playerData:playerData];
        [self registerForAPN];
        [prefs synchronize];
    }
    return results;
    
}

-(NSMutableDictionary *)registerTwitterPlayer:(NSMutableDictionary *)playerData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] registerTwitterPlayer:jsonString];
    if([@"2" isEqualToString:[results objectForKey:@"success"]] || [@"1" isEqualToString:[results objectForKey:@"success"]]){
        [self processLogin:results playerData:playerData];
        [self registerForAPN];
        [prefs synchronize];
    }
    return results;
    
}

-(NSMutableDictionary *)loginPlayer:(NSMutableDictionary *)playerData{
    
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    [playerData setValue:countryCode forKey:@"countryCode"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] loginGamePlayer:jsonString];
    
    [self processLogin:results playerData:playerData];
        
    return results;
    
}



-(void)finishedLoggingIn{
    self.isLoggingIn = YES;
}

-(NSMutableDictionary *)loginFacebookPlayer:(NSMutableDictionary *)playerData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] loginFacebookPlayer:jsonString];
    [self processLogin:results playerData:playerData];
    return results;
    
}

-(NSMutableDictionary *)loginTwitterPlayer:(NSMutableDictionary *)playerData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] loginTwitterPlayer:jsonString];
    [self processLogin:results playerData:playerData];
    return results;
    
}

-(NSMutableDictionary *)doesTwitterPlayerExist:(NSMutableDictionary *)playerData{
    NSError *error = nil;
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] doesTwitterPlayerExist:jsonString];
    [self processLogin:results playerData:playerData];
    return results;
    
}


-(void)processLogin:(NSMutableDictionary *)results playerData:(NSMutableDictionary *)playerData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        self.myProfile = results;
        self.myUserID = [NSString stringWithFormat:@"%@",[results objectForKey:@"userID"]];
        self.myUserName = [results objectForKey:@"userName"];
        self.myEmail = [results objectForKey:@"email"];
        self.myFriends = [results objectForKey:@"friends"];
        myProChips = [[results valueForKey:@"current_currency"] intValue];
        self.proChipsTotal = [self getMyProChips];
        [self arrangeFavsAndRecents];
        self.myInventory = [results objectForKey:@"inventory"];
        self.myDisplayName = [results objectForKey:@"displayName"];
        if(myDisplayName && [myDisplayName length] > 0){
            self.myUserName = myDisplayName;
        }
        [prefs setObject:[playerData objectForKey:@"password"] forKey:@"password"];
        //NSLog(@"myInventory:%@",myInventory);
        //NSLog(@"results:%@",results);
        
        if([results objectForKey:@"userName"] || [[results objectForKey:@"userName"] length] > 0){
            [prefs setObject:[results objectForKey:@"userName"] forKey:@"userName"];
        }
        if([results objectForKey:@"email"] || [[results objectForKey:@"email"] length] > 0){
            [prefs setObject:[results objectForKey:@"email"] forKey:@"email"];
        }
        if([results objectForKey:@"password"] || [[results objectForKey:@"password"] length] > 0){
            [prefs setObject:[results objectForKey:@"password"] forKey:@"password"];
        }
        if([results objectForKey:@"facebook_id"] || [[results objectForKey:@"facebook_id"] length] > 0){
            [prefs setObject:[results objectForKey:@"facebook_id"] forKey:@"facebook_id"];
        }
        [self registerForAPN];
        self.messages = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:[NSString stringWithFormat:@"messages_%@",myUserID]]];
        if(!messages){
            self.messages = [[NSMutableDictionary alloc] init];
        }
        
        self.lastLoginDate = [utcFormatter dateFromString:[results valueForKey:@"lastLoginDate"]];
        //NSLog(@"playerAchievements:%@",[myProfile valueForKey:@"achievements"]);
        NSMutableDictionary *earnedAchievement = [self getGameAchievementForCode:@"REGISTER" category:@"BLACK"];
        if(![self currentUserHasAchievement:earnedAchievement] && ![myEmail isEqualToString:[prefs valueForKey:@"EMAIL_REGISTERED"]]){
            [prefs setValue:myEmail forKey:@"EMAIL_REGISTERED"];
            [self logAchievements];
            [self incrementAchievement:earnedAchievement forUser:myUserID];
        }
        [prefs synchronize];
        if(![self isSameDay:lastLoginDate date2:[NSDate date]]){
            NSMutableDictionary *earnedAchievement = [self getGameAchievementForCode:@"LOGIN_DAILY" category:@"BLACK"];
            [self incrementAchievement:earnedAchievement forUser:myUserID];
            int consecutiveLogin = [[results valueForKey:@"consecutiveLogin"] intValue];
            if(consecutiveLogin == 3){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"LOGIN_STREAK_3" category:@"BRONZE"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
            }else if(consecutiveLogin == 10){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"LOGIN_STREAK_10" category:@"SILVER"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
            }else if(consecutiveLogin == 20){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"LOGIN_STREAK_20" category:@"GOLD"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
            }else if(consecutiveLogin == 40){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"LOGIN_STREAK_40" category:@"PLATINUM"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
            }
            
        }
//        [[SocialManager sharedInstance] getFacebookFriends];
    }
}


-(void)resetPassWord:(NSString *)email{
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:email forKey:@"email"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"sendAPN Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] resetPlayerPassword:jsonString];
        if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
            //NSLog(@"sendAPN Results:%@",results);
        }
        //NSLog(@"sendAPN Results:%@",results);
    });
    
}




-(BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2{
    //return NO;
    NSDateComponents *lastLoginDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    if([today day] == [lastLoginDay day] &&
       [today month] == [lastLoginDay month] &&
       [today year] == [lastLoginDay year] &&
       [today era] == [lastLoginDay era]) {
        return YES;
    }
    return NO;
}


-(void)arrangeFavsAndRecents{
    
    if(!favPlayers){
        self.favPlayers = [[NSMutableArray alloc] init];
    }
    if(!recentPlayers){
        self.recentPlayers = [[NSMutableArray alloc] init];
    }
    [favPlayers removeAllObjects];
    [recentPlayers removeAllObjects];
    for (NSMutableDictionary *player in myFriends) {
        if([Settings isFavoritePlayer:[player valueForKey:@"userID"]]){
            //[favPlayers addObject:player];
        }else{
            [recentPlayers addObject:player];
        }
        
    }
    //NSLog(@"recentPlayers:%@",recentPlayers);
    //NSLog(@"favPlayers:%@",favPlayers);
}

-(void)loadPlayerStatuses{
    dispatch_async(kBgQueue, ^{
        isGameDetailsUpdating = YES;
        NSMutableArray *profileIDs = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *profileDict in myFriends) {
            [profileIDs addObject:[profileDict valueForKey:@"userID"]];
        }
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:profileIDs options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"loadPlayerStatuses:%@",jsonString);
        NSDictionary *results = [[APIDataManager sharedInstance] getPlayerStatuses:jsonString]; 
        [self performSelectorOnMainThread:@selector(fetchedPlayerStatuses:) 
                               withObject:results waitUntilDone:YES];
    });
}

-(int)getMyProChips{
    int localCurrency = 0;
    for (NSMutableDictionary *localAchievement in localAcievements) {
        if([[localAchievement valueForKey:@"userID"] isEqualToString:myUserID]){
            localCurrency = localCurrency + [[localAchievement valueForKey:@"currencyInc"] intValue];
        }
    }
    
    return myProChips+localCurrency;
}

-(void)resetProChips{
    [localAcievements removeAllObjects];
    [[StoreFront sharedStore] decrementUserCurrency:[self getMyProChips]];
}

-(void)fetchedPlayerStatuses:(NSMutableDictionary *)results{
    //NSLog(@"results:%@",results);
    self.profileStatues = results;
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
        //NSLog(@"loadUserGames jsonString:%@",jsonString);
        NSMutableArray *results = [[APIDataManager sharedInstance] getPlayerGames:jsonString];
        //NSLog(@"loadUserGames results:%@",results);
        if(results){
            [self performSelectorOnMainThread:@selector(fetchedUserGames:) 
                               withObject:results waitUntilDone:YES];
        }
    });
}


-(void)loadPlayerProfile:(NSString *)userID{
    dispatch_async(kBgQueue, ^{
        isGameDetailsUpdating = YES;
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:userID forKey:@"userID"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableArray *results = [[APIDataManager sharedInstance] getPlayerProfile:jsonString]; 
        if(results){
            [self performSelectorOnMainThread:@selector(fetchedPlayerProfile:) 
                               withObject:results waitUntilDone:YES];
        }
    });
}

-(void)fetchedPlayerProfile:(NSMutableDictionary *)playerDict{
    self.playerProfile = playerDict;
    if([[playerProfile valueForKey:@"userID"] isEqualToString:myUserID]){
        self.myInventory = [playerProfile valueForKey:@"inventory"];
    }
    self.playerProfileLoaded = YES;
    //NSLog(@"playerProfile:%@",playerProfile);
}

-(void)addInventory:(NSString *)category value:(NSString *)value{
    dispatch_async(kBgQueue, ^{
        isGameDetailsUpdating = YES;
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:myUserID forKey:@"userID"];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:category,@"CATEGORY",value,@"VALUE",nil];
        
        
        NSMutableDictionary *inventoryItem = [[NSMutableDictionary alloc] init];
        [inventoryItem setValue:category forKey:@"category"];
        [inventoryItem setValue:value forKey:@"value"];
        
        NSMutableArray *inventoryItems = [NSMutableArray arrayWithObject:inventoryItem];
        [userDict setValue:inventoryItems forKey:@"inventory"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"addInvetory Request:%@",jsonString);
        NSMutableArray *results = [[APIDataManager sharedInstance] postInventory:jsonString]; 
        //NSLog(@"addInvetory Response:%@",results);
        
        [self performSelectorOnMainThread:@selector(fetchedMyInventory:) 
                               withObject:results waitUntilDone:YES];
    });
}


-(void)addInventorySynchronous:(NSString *)category value:(NSString *)value{
    isGameDetailsUpdating = YES;
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:myUserID forKey:@"userID"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:category,@"CATEGORY",value,@"VALUE",nil];
    
    
    NSMutableDictionary *inventoryItem = [[NSMutableDictionary alloc] init];
    [inventoryItem setValue:category forKey:@"category"];
    [inventoryItem setValue:value forKey:@"value"];
    
    NSMutableArray *inventoryItems = [NSMutableArray arrayWithObject:inventoryItem];
    [userDict setValue:inventoryItems forKey:@"inventory"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"addInvetory Request:%@",jsonString);
    self.myInventory = [[APIDataManager sharedInstance] postInventory:jsonString]; 
    
}

-(void)fetchedMyInventory:(NSMutableArray *)inventory{
    self.myInventory = inventory;
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
    //if(isGameDetailsUpdating){
      //  return;
    //}
    dispatch_async(kBgQueue, ^{
        isGameDetailsUpdating = YES;
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:gameID forKey:@"gameID"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // NSLog(@"Start loadGameDetails");
        
        NSMutableDictionary *game;
        if(loadFromLocalFile){
            NSError *error;
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gameDetails" ofType:@"json"];  
            NSData *gameData = [NSData dataWithContentsOfFile:filePath];  
            game = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableContainers error:&error];
        }else{
            game = [[APIDataManager sharedInstance] getGame:jsonString];
        }
        
        [self performSelectorOnMainThread:@selector(fetchedGameDetails:) 
                               withObject:game waitUntilDone:YES];
        
    });
}


- (void)fetchedGameDetails:(NSMutableDictionary *)game{
    //isGameDetailsUpdating = NO;
//    NSLog(@"Dictionary: %@", [game description]);
    if(game && [game count] > 0){
        self.currentGame = game;
         self.currentGameID = [currentGame valueForKey:@"gameID"];
         self.currentTurnUserID = [currentGame valueForKey:@"nextActionForUserID"];
         NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getCurrentPlayerForCurrentGame];
         self.currentTurnUserName = [currentPlayer valueForKey:@"userName"];
         NSLog(@"currentGame:%@",currentGame);
         self.lastUpdatedDate = [utcFormatter dateFromString:[currentGame valueForKey:@"lastUpdated"]];
//        NSLog(@"currentGame:%@",lastUpdatedDate);
         
         
         
         /*
         self.gameMessages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:gameMessagesKey]];
         if(!gameMessages){
             self.gameMessages = [[NSMutableArray alloc] initWithCapacity:0];
         }*/
        // NSLog(@"game:%@",game);
         NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
         if([hands count] > 0){
             self.currentHand = [hands objectAtIndex:0];
         }else{
             self.currentHand = nil;
         }
         self.gameDetailsUpdates = YES;
         if([self isMyTurn:currentGame]){
             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
         }else{
             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
         }
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
                if([self isMyTurn:game] || [self isPlayerMePendingForGame:game] || [self cardsDidChange:game]){
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

-(BOOL)cardsDidChange:(NSMutableDictionary *)game{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [game setValue:@"NO" forKey:@"cardsDidChange"];
    if(!game || ![game valueForKey:@"turnState"] || ![[game valueForKey:@"turnState"] valueForKey:@"players"]){
        return NO;
    }
    
    
    NSMutableArray *players = [[game valueForKey:@"turnState"] valueForKey:@"players"];
    NSMutableDictionary *myPlayerState;
    for (NSMutableDictionary *player in players) {
        if([[player valueForKey:@"userID"] isEqualToString:myUserID]){
            myPlayerState = [player valueForKey:@"playerState"];
        }
    }
    if(!myPlayerState){
        return NO;
    }
    NSString *playerCards = [NSString stringWithFormat:@"%@_%@",[myPlayerState valueForKey:@"cardOne"],[myPlayerState valueForKey:@"cardTwo"]];
    if(![prefs valueForKey:[game valueForKey:@"gameID"]]){
        [prefs setValue:playerCards forKey:[game valueForKey:@"gameID"]];
        [prefs synchronize];
        return NO;
    }
    if(![[prefs valueForKey:[game valueForKey:@"gameID"]] isEqualToString:playerCards]){
        [game setValue:@"YES" forKey:@"cardsDidChange"];
        NSArray *cards = [[prefs valueForKey:[game valueForKey:@"gameID"]] componentsSeparatedByString:@"_"];
        [game setValue:[cards objectAtIndex:0] forKey:@"oldCardOne"];
        [game setValue:[cards objectAtIndex:1] forKey:@"oldCardTwo"];
        return YES;
    }
    return NO;
}

#pragma mark - Chat


-(void)postSystemMessageForCurrentGame:(NSString *)message{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    NSMutableDictionary *localMessageDict = [[NSMutableDictionary alloc] init];
    [localMessageDict setValue:message forKey:@"message"];
    [localMessageDict setValue:@"-1" forKey:@"userID"];
    [localMessageDict setValue:@"Dealer" forKey:@"userName"];
    [localMessageDict setValue:currentGameID forKey:@"gameID"];
    [localMessageDict setValue:@"YES" forKey:@"isRead"];
    [localMessageDict setValue:[utcFormatter stringFromDate:[NSDate date]] forKey:@"created_at"];
    [self updateGameMessages:localMessageDict];
    //[self incrementNewMessageCountBy:1];
    self.newMessagesCount++;
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
        [messageDict setValue:@"-1" forKey:@"userID"];
        [messageDict setValue:@"Dealer" forKey:@"userName"];
        [messageDict setValue:currentGameID forKey:@"gameID"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"postSystemMessageForCurrentGame Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] postMessge:jsonString];
        if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
            //NSLog(@"postMessageForCurrentGame Results:%@",results);
        }
        //NSLog(@"postSystemMessageForCurrentGame Results:%@",results);
    });
}



-(void)postMessageForCurrentGame:(NSString *)message{
    NSMutableDictionary *localMessageDict = [[NSMutableDictionary alloc] init];
    [localMessageDict setValue:myUserID forKey:@"userID"];
    [localMessageDict setValue:message forKey:@"message"];
    [localMessageDict setValue:myUserName forKey:@"userName"];
    [localMessageDict setValue:currentGameID forKey:@"gameID"];
    [localMessageDict setValue:@"YES" forKey:@"isRead"];
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
            //NSLog(@"postMessageForCurrentGame Results:%@",results);
        }
       // NSLog(@"postMessageForCurrentGame Results:%@",results);
    });
}

-(void)postNudgeToCurrentPlayer{
    dispatch_async(kBgQueue, ^{
        NSMutableArray *recipients = [[NSMutableArray alloc] init];
        [recipients addObject:[currentGame valueForKey:@"nextActionForUserID"]];
        NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
        [payLoad setValue:currentGameID forKey:@"gameID"];
        [self sendAPN:recipients message:[NSString stringWithFormat:@"%@ is nudging you for game %@.",myUserName,currentGameID] payLoad:payLoad];
        
    });
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
        
         NSLog(@"loadNewMessages Results:%@",results);
        
        [self performSelectorOnMainThread:@selector(fetchedNewMessages:) 
                               withObject:results waitUntilDone:YES];
    });
}

-(void)fetchedNewMessages:(NSMutableDictionary *)newMessages{
    
    
    for (NSMutableDictionary *messageDict in [newMessages valueForKey:@"messages"]) {
       // self.messagesGameID = [messageDict valueForKey:@"messagesGameID"];
        [self updateGameMessages:messageDict];
    }
    self.newMessagesCount = [self getUnreadMessageCountForCurrentGame];
    if(newMessagesCount > 0){
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        //NSLog(@"new Messages:%@",newMessages);
    }
    /*
    NSString *gameMessageCountKey = [NSString stringWithFormat:@"newMessagesCount_%@_%@",messagesGameID,myUserID];
    //NSLog(@"[[NSUserDefaults standardUserDefaults] objectForKey:gameMessageCountKey]:%@",[[NSUserDefaults standardUserDefaults] objectForKey:gameMessageCountKey]);
    [self updateNewMessageCount:[[[NSUserDefaults standardUserDefaults] objectForKey:gameMessageCountKey] intValue] + [[newMessages valueForKey:@"messages"] count]];
    
    */
}

-(void)updateGameMessages:(NSMutableDictionary *)messageDict{
    
    NSMutableArray *gameMessages = [NSMutableArray arrayWithArray:[messages objectForKey:[messageDict valueForKey:@"gameID"]]];
    if(!gameMessages){
        gameMessages = [[NSMutableArray alloc] init];
        
    }
    [messages setObject:gameMessages forKey:[messageDict valueForKey:@"gameID"]];
    [gameMessages addObject:messageDict];
    int myMessagesCount = 0;
    for (NSMutableDictionary *message in gameMessages) {
        if([[message valueForKey:@"userID"] isEqualToString:myUserID]){
            myMessagesCount++;
        }
    }
    if(myMessagesCount == 5){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"CHATTER_BOX_5" category:@"BRONZE"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
    }else if(myMessagesCount == 10){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"CHATTER_BOX_10" category:@"SILVER"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
    }else if(myMessagesCount == 20){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"CHATTER_BOX_20" category:@"GOLD"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
    }else if(myMessagesCount == 40){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"CHATTER_BOX_40" category:@"PLATINUM"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
    }
    [[NSUserDefaults standardUserDefaults] setObject:messages forKey:[NSString stringWithFormat:@"messages_%@",myUserID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getMessagesForCurrentGame{
    return [NSMutableArray arrayWithArray:[messages objectForKey:currentGameID]];
}

-(void)setMessagesAsReadForCurrentGame{
    NSMutableArray *gameMessages = [NSMutableArray arrayWithArray:[messages objectForKey:currentGameID]];
    for (int i = 0; i < [gameMessages count];i++) {
        NSMutableDictionary *messageDict = [NSMutableDictionary dictionaryWithDictionary:[gameMessages objectAtIndex:i]];
        [messageDict setValue:@"YES" forKey:@"isRead"];
        [gameMessages replaceObjectAtIndex:i withObject:messageDict];
    }
    [messages setObject:gameMessages forKey:currentGameID];
    self.newMessagesCount = 0;
    //NSLog(@"messages:%@",messages);
    [[NSUserDefaults standardUserDefaults] setObject:messages forKey:[NSString stringWithFormat:@"messages_%@",myUserID]];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(int)getUnreadMessageCountForCurrentGame{
    int unreadMessagesCount = 0;
    NSMutableArray *gameMessages = [NSMutableArray arrayWithArray:[messages objectForKey:currentGameID]];
    for (int i = 0; i < [gameMessages count];i++) {
        NSMutableDictionary *messageDict = [NSMutableDictionary dictionaryWithDictionary:[gameMessages objectAtIndex:i]];
        if(![@"YES" isEqualToString:[messageDict valueForKey:@"isRead"]]){
            unreadMessagesCount++;
        }
    }
    //NSLog(@"messages:%@",messages);
    return unreadMessagesCount;
}


-(void)addFriends:(NSMutableArray *)playerGames{
    if(playerGames && playerGames.count > 0){
        BOOL hasNewFriends = NO;
        if(!myFriends){
            self.myFriends = [[NSMutableArray alloc] init];
        }
        for (NSMutableDictionary *game in playerGames) {
            if([game valueForKey:@"turnState"] && [[game valueForKey:@"turnState"] valueForKey:@"players"]){
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
                            [newFriend setValue:@"TTP" forKey:@"type"];
                            [myFriends addObject:newFriend];
                        }
                    }
                }
            }
        }
        if(hasNewFriends){
            [self updateFriends];
        }
    }
}

-(void)addfriendsFromFaceBook:(NSMutableDictionary *)results{
    self.myFriends = [results valueForKey:@"friends"];
    [self arrangeFavsAndRecents];
    NSMutableArray *facebookFriends = [results valueForKey:@"facebookFriends"];
    if(facebookFriends && facebookFriends.count > 0){
        BOOL hasNewFriends = NO;
        if(!myFriends){
            self.myFriends = [[NSMutableArray alloc] init];
        }
        for (NSMutableDictionary *friend in facebookFriends) {
            
            if(![self hasFriend:[friend valueForKey:@"userID"]]){
                hasNewFriends = YES;
                NSMutableDictionary *newFriend = [[NSMutableDictionary alloc] init];
                [newFriend setValue:[friend valueForKey:@"userID"] forKey:@"userID"];
                [newFriend setValue:[friend valueForKey:@"userName"] forKey:@"userName"];
                [newFriend setValue:[friend valueForKey:@"userName"] forKey:@"userName"];
                [newFriend setValue:@"Facebook" forKey:@"type"];
                NSLog(@"newFriend:%@",newFriend);
                [myFriends addObject:newFriend];
            }
        }
        if(hasNewFriends){
            [self updateFriends];
        }
    }
}

-(BOOL)hasFriend:(NSString *)userID{
    for (NSMutableDictionary *friend in myFriends) {
        if([userID isEqualToString:[friend valueForKey:@"userID"]]){
            return YES;
        }
    }
    return NO;
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
    NSString *message = [NSString stringWithFormat:@"%@ has invited you to %@ game %@",myUserName,NSLocalizedString([[currentGame valueForKey:@"gameSettings"] valueForKey:@"type"],nil),[currentGame valueForKey:@"gameID"],nil];
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
    //if([self isCurrentGameMyTurn] || debugMode){
        if(currentGame && [currentGame objectForKey:@"gameState"] && [@"active" isEqualToString:[currentGame valueForKey:@"status"]]){
            if([[currentGame objectForKey:@"gameState"] objectForKey:@"hands"]){
                NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
                if([hands count] > 0){
                    self.currentHand = [hands objectAtIndex:0];
                    NSMutableArray *rounds = [[hands objectAtIndex:0] objectForKey:@"rounds"];
                    if([rounds count] > 0){
                        NSMutableDictionary *lastRount = [rounds objectAtIndex:0];
                        if(lastRount && ![@"YES" isEqualToString:[lastRount objectForKey:@"MY_BET_ROUND"]]){
                            self.betRound = [[NSMutableDictionary alloc] initWithCapacity:0];
                            [rounds insertObject:betRound atIndex:0];
                        }
                    }
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
                    
                    
                }
            }
        }
   // }
    
}


-(void)deleteGame:(NSMutableDictionary *)game{
    NSMutableDictionary *playerDict = [[NSMutableDictionary alloc] init];
    [playerDict setValue:myUserID forKey:@"userID"];
    [playerDict setValue:[game valueForKey:@"gameID"] forKey:@"gameID"];
    [playerDict setValue:@"leave" forKey:@"status"];
    if([self isCurrentGameMyTurn]){
        NSMutableDictionary *nextPlayer = [self getNextTurnPlayerFromCurrentGame:NO];
        [playerDict setValue:[nextPlayer valueForKey:@"userID"] forKey:@"nextActionForUserID"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] updatePlayerToGame:jsonString];
    [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"%@ has left the game",myUserName]];
    //NSLog(@"deleteGame:%@",results);
}



-(void)updateCurrentGame{
    //self.isUpdatingGame = YES;
    //dispatch_async(kBgQueue, ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:currentGame options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"updateGame JSON:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] updateGame:jsonString];
        
        [self performSelectorOnMainThread:@selector(didFinishUpdate:) 
                               withObject:results waitUntilDone:YES];
        
     //});
    
}

-(void)didFinishUpdate:(NSMutableDictionary *)updateResults{
    //self.isUpdatingGame = NO;
    NSMutableArray *playersForAPN = [[NSMutableArray alloc] init];
    [playersForAPN addObject:[currentGame valueForKey:@"nextActionForUserID"]];
    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
    [payLoad setValue:currentGameID forKey:@"gameID"];
    if([currentGame valueForKey:@"lastActionMessage"] && [[currentGame valueForKey:@"lastActionMessage"] length] > 0){
        [self sendAPN:playersForAPN message:[NSString stringWithFormat:@"%@. Your turn for game %@.",[currentGame valueForKey:@"lastActionMessage"],currentGameID] payLoad:payLoad];
    }
}


-(NSMutableArray *)getPlayersForGame:(NSMutableDictionary *)game{
    return [self getTurnStatePlayersForGame:game];
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

-(BOOL)isCurrentGamePending{
    return [self isGamePending:currentGame];
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
    NSMutableArray *players = [[NSMutableArray alloc] init];
    if(game){
        if([game objectForKey:@"turnState"]){
            if([[game objectForKey:@"turnState"] objectForKey:@"players"]){
                
                for (NSMutableDictionary *player in (NSMutableArray *)[[game objectForKey:@"turnState"] objectForKey:@"players"]) {
                    if(![[player valueForKey:@"status"] isEqualToString:@"leave"]){
                        [players addObject:player];
                    }
                }
                //return (NSMutableArray *)[[game objectForKey:@"turnState"] objectForKey:@"players"];
            }
            
        }
    }
    return players;
    
}

-(NSMutableArray *)getPlayersForCurrentGame{
    return [self getTurnStatePlayersForGame:currentGame];
    
}

-(BOOL)hasMoreThanOnePlayerForCurrentGame{
    if([[self getPlayersForCurrentGame] count] > 1){
        return YES;
    }
    return NO;
    
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
    return [self isGameTypeCash:currentGame];
}

-(BOOL)isCurrentGameTypeTournament{
    return [self isGameTypeTournament:currentGame];
}

-(BOOL)isGameTypeTournament:(NSDictionary *)game{
    if([game objectForKey:@"gameSettings"] && [@"tournament" isEqualToString:[[game objectForKey:@"gameSettings"] objectForKey:@"type"]]){
        return YES;
    }
    return NO;
}

-(BOOL)isGameTypeCash:(NSDictionary *)game{
    if([game objectForKey:@"gameSettings"] && [@"cash" isEqualToString:[[game objectForKey:@"gameSettings"] objectForKey:@"type"]]){
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
            if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
                potEntry = potEntry + [[round valueForKey:@"amount"] doubleValue];
                break;
            }
        }else{
            if(![[round valueForKey:@"action"] isEqualToString:@"fold"]){
                break;
            }
        }
    }
    return potEntry;
}

-(NSMutableArray *)getRoundsForCurrentHand{
    return [self getRoundsForHand:currentHand];
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

-(void)showYourCard{
//    int handState = [[currentHand objectForKey:@"state"] intValue];
    NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
    if([hands count] > 0){
        self.currentHand = [hands objectAtIndex:0];
    }
    NSMutableDictionary *hand = [[NSMutableDictionary alloc] init];
    hand = self.currentHand;

    NSMutableArray *showCard = [[NSMutableArray alloc] init];
    NSMutableDictionary *handToShow = [[NSMutableDictionary alloc] init];

//    NSMutableDictionary *currentHand = [DataManager sharedInstance].currentHand;
    NSString *cardOne;
    NSString *cardTwo;
    showCard = [hand objectForKey:@"showCard"];
    
    for (NSMutableDictionary *card in showCard){
        if( [[card valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            NSLog(@"DA SHOW");
            return;
        }
    }
    for (NSMutableDictionary *round in [hand valueForKey:@"rounds"]) {
        if([[round valueForKey:@"userID"] isEqualToString:myUserID]){
            cardOne = [round valueForKey:@"cardOne"];
            cardTwo = [round valueForKey:@"cardTwo"];
            break;
        }
    }
    
    [handToShow setValue: myUserName forKey:@"userName"];
    [handToShow setValue: myUserID forKey:@"userID"];
    [handToShow setValue: cardTwo forKey:@"cardTwo"];
    [handToShow setValue: cardOne forKey:@"cardOne"];
    
    if (!showCard){
        showCard = [[NSMutableArray alloc] init];
    }
    [showCard addObject:handToShow];
    
    [hand setValue: showCard forKey:@"showCard"];
    NSLog(@" showYourCard lkdjsf klfsdjf %@", hand);
    self.currentHand = hand;
    [self updateCurrentGame];
}

-(void)postRound:(NSMutableDictionary *)round{
    NSLog(@"postRound   round:%@",round);
    [self.currentGame setValue:@"" forKey:@"lastActionMessage"];
    int handState = [[currentHand objectForKey:@"state"] intValue];
    NSMutableDictionary *currentPlayerState = [[[DataManager sharedInstance] getCurrentPlayerForCurrentGame] objectForKey:@"playerState"];
    NSMutableArray *hands = [[currentGame objectForKey:@"gameState"] objectForKey:@"hands"];
    if([hands count] > 0){
        self.currentHand = [hands objectAtIndex:0];
    }
    [currentPlayerState setValue:[round valueForKey:@"action"] forKey:@"action"];
    [currentPlayerState setValue:[NSString stringWithFormat:@"%d",handState] forKey:@"lastBetHandState"];
    [currentPlayerState setValue:[round valueForKey:@"raiseAmount"] forKey:@"raiseAmount"];
    [betRound setValue:[round valueForKey:@"callAmount"] forKey:@"callAmount"];
    [betRound setValue:[round valueForKey:@"raiseAmount"] forKey:@"raiseAmount"];
    [betRound setValue:[round valueForKey:@"amount"] forKey:@"amount"];
    [betRound setValue:[round valueForKey:@"action"] forKey:@"action"];
    [betRound setValue:[round valueForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] forKey:@"appVersion"];
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
    
    if([[betRound valueForKey:@"action"] isEqualToString:@"fold"]){
        [self incrementAchievement:@"FOLD" category:@"PROFILE" earnedValue:@"0" forUser:myUserID];
    }else{
        if([[betRound valueForKey:@"userStack"] doubleValue] == 0){
            [self incrementAchievement:@"ALL_IN" category:@"PROFILE" earnedValue:@"0" forUser:myUserID];
        }
    }
    if([[betRound valueForKey:@"amount"] doubleValue] > 0){
        [self incrementAcievementValue:@"MONEY_BET" category:@"PROFILE" forUser:myUserID valueInc:[[betRound valueForKey:@"amount"] doubleValue]];
        if([self isCurrentGameTypeCash]){
            [self incrementAcievementValue:@"MONEY_BET_CASH_GAME" category:@"PROFILE" forUser:myUserID valueInc:[[betRound valueForKey:@"amount"] doubleValue]];
        }else if([self isCurrentGameTypeTournament]){
            [self incrementAcievementValue:@"MONEY_BET_TOURNAMENT_GAME" category:@"PROFILE" forUser:myUserID valueInc:[[betRound valueForKey:@"amount"] doubleValue]];
        }
    }
    
    int allIns = 0;
    for (NSMutableDictionary *hand in [[currentGame valueForKey:@"gameState"] valueForKey:@"hands"]) {
        
        for (NSMutableDictionary *round in [hand valueForKey:@"rounds"]) {
            if([[round valueForKey:@"userID"] isEqualToString:myUserID]){
                if([[round valueForKey:@"userStack"] doubleValue] == 0){
                    allIns++;
                }
            }
        }
    }
    
    if(userStack == 0){
        if(allIns == 2){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"ALL_IN_2" category:@"BRONZE"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
        }else if(allIns == 3){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"ALL_IN_3" category:@"SILVER"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
        }else if(allIns == 4){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"ALL_IN_4" category:@"GOLD"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
        }else if(allIns == 5){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"ALL_IN_5" category:@"PLATINUM"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:myUserID];
        }
    }
    
    
    // must determine if the pot is even with equal bets
    NSMutableArray *rounds = [currentHand valueForKey:@"rounds"];
    NSMutableDictionary *betAmounts = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *totalBetAmounts = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *vpipAmounts = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *pfrAmounts = [[NSMutableDictionary alloc] init];
    NSString *compareAmount = @"0.00";
    int numOfBettingRounds = 0;
    BOOL notMeRaise;
    for (int i = 0; i < rounds.count; i++) {
        NSMutableDictionary *round = [rounds objectAtIndex:i];
        //NSLog(@"round %d:%@",i,round);
        if([[round valueForKey:@"handState"] intValue] == handState){
            double userBetAmount = [[betAmounts valueForKey:[round valueForKey:@"userID"]] doubleValue];
            userBetAmount = userBetAmount + [[round valueForKey:@"amount"] doubleValue];
            
            
            double userVPIPAmount = [[vpipAmounts valueForKey:[round valueForKey:@"userID"]] doubleValue];
            userVPIPAmount = userVPIPAmount + [[round valueForKey:@"amount"] doubleValue];
            [vpipAmounts setValue:[NSString stringWithFormat:@"%.2f",userVPIPAmount] forKey:[round valueForKey:@"userID"]];
            
            if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
                double userPFRAmount = [[pfrAmounts valueForKey:[round valueForKey:@"userID"]] doubleValue];
                userPFRAmount = userPFRAmount + [[round valueForKey:@"amount"] doubleValue];
                [pfrAmounts setValue:[NSString stringWithFormat:@"%.2f",userPFRAmount] forKey:[round valueForKey:@"userID"]];
            }
            
            
            if([[round valueForKey:@"action"] isEqualToString:@"fold"]){
                [betAmounts setValue:@"fold" forKey:[round valueForKey:@"userID"]];
            }else{
                numOfBettingRounds++;
                if(![@"fold" isEqualToString:[betAmounts valueForKey:[round valueForKey:@"userID"]]]){
                    if(userBetAmount > [compareAmount doubleValue]){
                        compareAmount = [NSString stringWithFormat:@"%.2f",userBetAmount];
                    }
                    
                    [betAmounts setValue:[NSString stringWithFormat:@"%.2f",userBetAmount] forKey:[round valueForKey:@"userID"]];
                }
            }
            
            double totalBetAmount = [[totalBetAmounts valueForKey:[round valueForKey:@"userID"]] doubleValue];
            totalBetAmount = totalBetAmount + [[round valueForKey:@"amount"] doubleValue];
            [totalBetAmounts setValue:[NSString stringWithFormat:@"%.2f",totalBetAmount] forKey:[round valueForKey:@"userID"]];
        }
        
        if(([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]) && handState == 1 && ![[round valueForKey:@"userID"] isEqualToString:myUserID]){
            notMeRaise = YES;
        }
    }
    
    //blind stealing?
    NSMutableDictionary *playerState = [self getPlayerStateCurrentTurnForCurrentGame];
    if(!notMeRaise && handState == 1 && [[playerState valueForKey:@"isDealer"] isEqualToString:@"YES"]){
        [self incrementAchievement:@"BLIND_STEAL_OPPORTUNITY" category:@"PROFILE" earnedValue:@"0" forUser:myUserID];
        if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
            [self incrementAchievement:@"BLIND_STEAL" category:@"PROFILE" earnedValue:@"0" forUser:myUserID];
        }
    }
    
    BOOL hasAllValidPlayersActedOnHand = YES;
    NSMutableArray *players = [self getPlayersForCurrentGame];
    for (NSMutableDictionary *player in players) {
        if([self canPlayerBet:player] && [[[player valueForKey:@"playerState"] valueForKey:@"lastBetHandState"] intValue] != handState){
            hasAllValidPlayersActedOnHand = NO;
        }
    }
    

   // NSLog(@"betAmounts:%@",betAmounts);
    BOOL increaseHandState = hasAllValidPlayersActedOnHand;
    if(increaseHandState){
        for(NSString *aKey in betAmounts){
            //NSLog(@"betAmount:%@  compareAmount:%@",[betAmounts valueForKey:aKey],compareAmount);
            if(![[betAmounts valueForKey:aKey] isEqualToString:compareAmount] && ![@"fold" isEqualToString:[betAmounts valueForKey:aKey]]){
                NSMutableDictionary *playerState = [[self getPlayerForIDCurrentGame:aKey] valueForKey:@"playerState"];
                NSLog(@"playerState:%@",playerState);
                if([[playerState valueForKey:@"userStack"] doubleValue] > 0){
                    increaseHandState = NO;
                }
                //not all the pots are equal, let them keep betting or checking
                
            }
        }
    }
    
    NSMutableDictionary *nextPlayersTurn = [self getNextTurnPlayerFromCurrentGame:increaseHandState];
    if(increaseHandState){
        //vpip & pfr
        if(handState == 1){
            for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
                //NSLog(@"vpipAmounts:%@",vpipAmounts);
                //NSLog(@"pfrAmounts:%@",pfrAmounts);
                //NSLog(@"gameSettings:%@",[currentGame valueForKey:@"gameSettings"]);
                double vpipBetAmount = [[vpipAmounts valueForKey:[player valueForKey:@"userID"]] doubleValue];
                if(vpipBetAmount > [[[currentGame valueForKey:@"gameSettings"] valueForKey:@"bigBlind"] doubleValue]){
                        [self incrementAchievement:@"VPIP" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                }
                
                double pfrBetAmount = [[pfrAmounts valueForKey:[player valueForKey:@"userID"]] doubleValue];
                if(pfrBetAmount > 0){
                    [self incrementAchievement:@"PFR" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                }
            }
            
        }
        handState++;
        if(handState == 2){
            [self.betRound setValue:@"FLOP" forKey:@"HAND_STATE"];
            for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
                //NSLog(@"player:%@",player);
                if([[player valueForKey:@"status"] isEqualToString:@"playing"] && ([[[player  valueForKey:@"playerState"] valueForKey:@"lastBetHandState"] intValue] == (handState - 1) || [[[player  valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] == 0)){
                    if(![[[player valueForKey:@"playerState"] valueForKey:@"action"] isEqualToString:@"fold"]){
                        [self incrementAchievement:@"SEE_FLOP" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                    }

                }
            }
        }else if(handState == 3){
            [self.betRound setValue:@"TURN" forKey:@"HAND_STATE"];
            for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
                if([[player valueForKey:@"status"] isEqualToString:@"playing"] && ([[[player  valueForKey:@"playerState"] valueForKey:@"lastBetHandState"] intValue] == (handState - 1) || [[[player  valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] == 0)){
                    if(![[[player valueForKey:@"playerState"] valueForKey:@"action"] isEqualToString:@"fold"]){
                        [self incrementAchievement:@"SEE_TURN" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                    }
                    
                }
            }
        }else if(handState == 4){
            [self.betRound setValue:@"RIVER" forKey:@"HAND_STATE"];
            for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
                if([[player valueForKey:@"status"] isEqualToString:@"playing"] && ([[[player  valueForKey:@"playerState"] valueForKey:@"lastBetHandState"] intValue] == (handState - 1) || [[[player  valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] == 0)){
                    if(![[[player valueForKey:@"playerState"] valueForKey:@"action"] isEqualToString:@"fold"]){
                        [self incrementAchievement:@"SEE_RIVER" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                    }
                }
            }
        }
        [currentHand setValue:[NSString stringWithFormat:@"%d",handState] forKey:@"state"];
    }
    [self.currentGame setValue:[nextPlayersTurn objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    
    
    NSMutableArray *winners = [self determineHandWinners:currentGame evenPot:increaseHandState];
    //NSLog(@"winner:%@",winners);
    if(winners && [winners count] > 0){
        BOOL isTableFolded = NO;
        double highestWinnerAmount = 0;
        NSString *highestWinningUserID = @"";
        NSString *highestWinnerName = @"";
        for (NSMutableDictionary *winner in winners) {
            if([[winner valueForKey:@"amount"] doubleValue] > highestWinnerAmount){
                highestWinnerAmount = [[winner valueForKey:@"amount"] doubleValue];
                highestWinnerName = [winner valueForKey:@"userName"];
                highestWinningUserID = [winner valueForKey:@"userID"];
            }
            if([@"USER_FOLD" isEqualToString:[winner valueForKey:@"type"]]){
                isTableFolded = YES;
            }
            NSMutableDictionary *playerState = [[self getPlayerForID:[winner valueForKey:@"userID"] game:currentGame] valueForKey:@"playerState"];
            
            if([[playerState valueForKey:@"userStack"] doubleValue] == 0){
                [self incrementAchievement:@"ALL_IN_WIN" category:@"PROFILE" earnedValue:@"0" forUser:[winner valueForKey:@"userID"]];
            }
            double newUserStack = [[playerState valueForKey:@"userStack"] doubleValue] + [[winner valueForKey:@"amount"] doubleValue];
            [playerState setValue:[NSString stringWithFormat:@"%.2f",newUserStack] forKey:@"userStack"];
            
            if([[winner valueForKey:@"amount"] doubleValue] > 0 ){
                [self incrementAchievement:@"HANDS_WON" category:@"PROFILE" earnedValue:@"0" forUser:[winner valueForKey:@"userID"]];
            }
        }
    
        //win/loss amounts
        for (NSString *userID in totalBetAmounts) {
            double winAmount = 0;
            for (NSMutableDictionary *winner in winners) {
                if([[winner valueForKey:@"userID"] isEqualToString:userID]){
                    winAmount = [[winner valueForKey:@"amount"] doubleValue];
                }
            }
            double winLossAmount = winAmount - [[totalBetAmounts valueForKey:userID] doubleValue];
            if(winLossAmount > 0){
                [self incrementAcievementValue:@"MONEY_WON" category:@"PROFILE" forUser:userID valueInc:winLossAmount];
                if([self isCurrentGameTypeCash]){
                    [self incrementAcievementValue:@"MONEY_WON_CASH_GAME" category:@"PROFILE" forUser:userID valueInc:winLossAmount];
                }else if([self isCurrentGameTypeTournament]){
                    [self incrementAcievementValue:@"MONEY_WON_TOURNAMENT_GAME" category:@"PROFILE" forUser:userID valueInc:winLossAmount];
                }
            }else if(winLossAmount < 0){
                [self incrementAcievementValue:@"MONEY_LOST" category:@"PROFILE" forUser:userID valueInc:winLossAmount];
                if([self isCurrentGameTypeCash]){
                    [self incrementAcievementValue:@"MONEY_LOST_CASH_GAME" category:@"PROFILE" forUser:userID valueInc:winLossAmount];
                }else if([self isCurrentGameTypeTournament]){
                    [self incrementAcievementValue:@"MONEY_LOST_TOURNAMENT_GAME" category:@"PROFILE" forUser:userID valueInc:winLossAmount];
                }
            }
        }
        
    
    
    
    
    
        [currentHand setValue:[NSString stringWithFormat:@"%d",5] forKey:@"state"];
        [currentHand setValue:winners forKey:@"winners"];
        
        //update show hands 
        for (int i = 0; i < rounds.count; i++) {
            NSMutableDictionary *round = [rounds objectAtIndex:i];
            NSMutableDictionary *playerStateForRound = [[self getPlayerForIDCurrentGame:[round valueForKey:@"userID"]] valueForKey:@"playerState"];
            if(![[playerStateForRound valueForKey:@"action"] isEqualToString:@"fold"] && !isTableFolded){
                [round setValue:@"YES" forKey:@"showCards"];
            }
        }
        
        /*
         Update Game and Player States
         */
        int numPlayingPlayers = 0;
        NSMutableDictionary *gameSummary = [[currentGame valueForKey:@"gameState"] valueForKey:@"gameSummary"];
        if(!gameSummary){
            gameSummary = [[NSMutableDictionary alloc] init];
            [[currentGame valueForKey:@"gameState"] setValue:gameSummary forKey:@"gameSummary"];
        }
        NSMutableArray *losersArray = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
            
            BOOL isPlayerWinner = NO;
            for (NSMutableDictionary *winner in winners) {
                if([[winner valueForKey:@"userID"] isEqualToString:[player valueForKey:@"userID"]] && ![[winner valueForKey:@"userID"] isEqualToString:myUserID]){
                    isPlayerWinner = YES;
                    NSMutableArray *winnerPlayer = [[NSMutableArray alloc] init];
                    [winnerPlayer addObject:[player valueForKey:@"userID"]];
                    double winAmount = [[winner objectForKey:@"amount"] doubleValue] - [[DataManager sharedInstance] getPotEntryForUser:[winner objectForKey:@"userID"] hand:currentHand];
                    
                    if(winAmount > 0){
                        NSString *message = [NSString stringWithFormat:@"$%.2f was won in game %@. See who won!",winAmount,[currentGame valueForKey:@"gameID"]] ;
                        NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
                        [payLoad setValue:currentGameID forKey:@"gameID"];
                        [self sendAPN:winnerPlayer message:message payLoad:payLoad];
                    }else{
                        isPlayerWinner = NO;
                    }
                }
            }
            if(!isPlayerWinner){
                if(![[player valueForKey:@"userID"] isEqualToString:myUserID]){
                    [losersArray addObject:[player valueForKey:@"userID"]];
                }
            }
            
            if([[[player objectForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] <= 0){
                if([self isCurrentGameTypeCash]){
                    [player setValue:@"pending" forKey:@"status"];
                }else{
                    [player setValue:@"out" forKey:@"status"];
                }
            }
            if([[player objectForKey:@"status"] isEqualToString:@"playing"]){
                numPlayingPlayers++;
            }
        }
        
        if([losersArray count] > 0){
            highestWinnerAmount = highestWinnerAmount - [[DataManager sharedInstance] getPotEntryForUser:highestWinningUserID hand:currentHand];
            NSString *message = [NSString stringWithFormat:@"$%.2f was won in game %@. See who won!",highestWinnerAmount,[currentGame valueForKey:@"gameID"]] ;
            NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
            [payLoad setValue:currentGameID forKey:@"gameID"];
            [self sendAPN:losersArray message:message payLoad:payLoad];
        }
        
        
        //PFA/WTSD/W$SD
        NSMutableDictionary *postFlopRaises = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *postFlopCalls = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < rounds.count; i++) {
            NSMutableDictionary *round = [rounds objectAtIndex:i];
           
            if([[round valueForKey:@"handState"] intValue] > 1){
                if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
                    int postFlopRaiseCount = [[postFlopRaises valueForKey:[round valueForKey:@"userID"]] intValue];
                    postFlopRaiseCount = postFlopRaiseCount + 1;
                    [postFlopRaises setValue:[NSString stringWithFormat:@"%d",postFlopRaiseCount] forKey:[round valueForKey:@"userID"]];
                }else if([[round valueForKey:@"action"] isEqualToString:@"call"]){
                    int postFlopCallCount = [[postFlopCalls valueForKey:[round valueForKey:@"userID"]] intValue];
                    postFlopCallCount = postFlopCallCount + 1;
                    [postFlopCalls setValue:[NSString stringWithFormat:@"%d",postFlopCallCount] forKey:[round valueForKey:@"userID"]];
                }
                
            }
        }
        for (NSMutableDictionary *player in [[currentGame valueForKey:@"turnState"] valueForKey:@"players"]) {
            int postFlopRaiseCount = [[postFlopRaises valueForKey:[player valueForKey:@"userID"]] intValue];
            int postFlopCallCount = [[postFlopCalls valueForKey:[player valueForKey:@"userID"]] intValue];
            
            [self incrementAchievement:@"POST_FLOP_RAISES" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"] countInc:postFlopRaiseCount];
            
            [self incrementAchievement:@"POST_FLOP_CALLS" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"] countInc:postFlopCallCount];
        }
        
        
        //no more hands
        if(![self hasCurrentGameMoreHands]){
            NSMutableDictionary *gameWinner = [[self determinGameWinnerForCurrentGame] objectAtIndex:0];
            [self incrementAchievement:@"GAMES_WON" category:@"PROFILE" earnedValue:@"0" forUser:[gameWinner valueForKey:@"userID"]];
            if([self isCurrentGameTypeCash]){
                [self incrementAchievement:@"CASH_GAMES_WON" category:@"PROFILE" earnedValue:@"0" forUser:[gameWinner valueForKey:@"userID"]];
            }else if([self isCurrentGameTypeTournament]){
                [self incrementAchievement:@"TOURNAMENT_GAMES_WON" category:@"PROFILE" earnedValue:@"0" forUser:[gameWinner valueForKey:@"userID"]];
            }
            [currentGame setValue:@"complete" forKey:@"status"];
            [self updateCurrentGame];
            return;
        }
        //no more plaers
        if(numPlayingPlayers <= 1){
            //not enough players left, need to change game to pending
            [currentGame setValue:@"pending" forKey:@"status"];
            [self updateCurrentGame];
            return;
        }

        [self dealNewHand];
    }else{
        //determine action message for APN
        NSString *actionMessage = @"";
        if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
            int numberOfRaises = [[DataManager sharedInstance] getNumberOfRaisesforCurrentRound];
            NSString *raiseString = @"";
            if(numberOfRaises==0){
                raiseString = @"bet to";
            }else if(numberOfRaises == 1){
                raiseString = @"raised to";
            }else{
                raiseString = @"reraise to";
            }
            actionMessage = [NSString stringWithFormat:@"%@ %@ to $%@",myUserName,raiseString,[round valueForKey:@"amount"]]; 
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



-(NSMutableArray *)determineHandWinners:(NSMutableDictionary *)game evenPot:(BOOL)evenPot{
    int handState = [[currentHand objectForKey:@"state"] intValue];
    
    //see if there is a winner due to folding
    int remainingPlayers = 0;
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    NSMutableDictionary *lastManWinner;
    NSMutableArray *communityCards = [currentHand valueForKey:@"communityCards"];
    int playerWithMoneyLeft = 0;
    if([game valueForKey:@"turnState"] && [[game valueForKey:@"turnState"] valueForKey:@"players"]){
        for (NSMutableDictionary *player in [[game valueForKey:@"turnState"] valueForKey:@"players"]) {
            NSMutableDictionary *playerState = [player valueForKey:@"playerState"];
            //NSLog(@"player:%@",player);
            if([@"playing" isEqualToString:[player valueForKey:@"status"]] && ![@"fold" isEqualToString:[playerState objectForKey:@"action"]]){
                remainingPlayers++;
                lastManWinner = player;
            }
            
            if([self canPlayerBet:player]){
                playerWithMoneyLeft++;
            }
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
        [winner setValue:[currentHand valueForKey:@"communityCards"] forKey:@"communityCards"];
        [winner setValue:[[lastManWinner valueForKey:@"playerState"] valueForKey:@"cardOne"] forKey:@"cardOne"];
        [winner setValue:[[lastManWinner valueForKey:@"playerState"] valueForKey:@"cardTwo"] forKey:@"cardTwo"];
        [winner setValue:@"USER_FOLD" forKey:@"type"];
        [winners addObject:winner];
        [self incrementAchievement:@"WWSD" category:@"PROFILE" earnedValue:@"0" forUser:[lastManWinner valueForKey:@"userID"]];
        return winners;
    }else if(handState == 5){
        NSMutableArray *hands = [[NSMutableArray alloc] init];
        if([game valueForKey:@"turnState"] && [[game valueForKey:@"turnState"] valueForKey:@"players"]){
            for (NSMutableDictionary *player in [[game valueForKey:@"turnState"] valueForKey:@"players"]) {
                NSMutableDictionary *playerState = [player valueForKey:@"playerState"];
                if([@"playing" isEqualToString:[player valueForKey:@"status"]]){
                    NSMutableArray *playerCards = [NSMutableArray arrayWithObjects:[playerState objectForKey:@"cardOne"],[playerState objectForKey:@"cardTwo"], nil];
                    [playerCards addObjectsFromArray:communityCards];
                    //NSLog(@"playerCards:%@",playerCards);
                    Hand *hand = [[Hand alloc] initWithCards:playerCards];
                    [hand setUserID:[player valueForKey:@"userID"]];
                    [hand setUserName:[player valueForKey:@"userName"]];
                    [hand setCardOne:[playerState objectForKey:@"cardOne"]];
                    [hand setCardTwo:[playerState objectForKey:@"cardTwo"]];
                    [hand setCommunityCards:communityCards];
                    if([@"fold" isEqualToString:[playerState objectForKey:@"action"]]){
                        hand.value = -1;
                    }else{
                        [self incrementAchievement:@"WTSD" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                    }
                    [hands addObject:hand];
                }
            }
        }
        
        
        
        double potAmount = [[currentHand valueForKey:@"potSize"] doubleValue];
        NSMutableArray *rounds = [currentHand valueForKey:@"rounds"];
        NSMutableDictionary *betAmounts = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < rounds.count; i++) {
            NSMutableDictionary *round = [rounds objectAtIndex:i];
            double userBetAmount = [[betAmounts valueForKey:[round valueForKey:@"userID"]] doubleValue];
            userBetAmount = userBetAmount + [[round valueForKey:@"amount"] doubleValue];
            [betAmounts setValue:[NSString stringWithFormat:@"%.2f",userBetAmount] forKey:[round valueForKey:@"userID"]];
        }
        
       // NSLog(@"betAmounts:%@",betAmounts);
       // NSLog(@"------");
        BOOL hasMorePots = YES;
        while(hasMorePots){
            int maxHandValue=0;
            for (Hand *hand in hands) {
                if(hand.value > maxHandValue && !hand.processed){
                    maxHandValue = hand.value;
                }
            }
            
            
            NSMutableArray *losers = [[NSMutableArray alloc] init];
            NSMutableArray *handWinners = [[NSMutableArray alloc] init];
            for (Hand *hand in hands) {
                if(!hand.processed){
                    //NSLog(@"Hand:%@  value:%d",[hand userName],hand.value);
                    [hand logHand];
                    if(hand.value >= maxHandValue){
                        
                        NSMutableDictionary *winner = [[NSMutableDictionary alloc] init];
                        [winner setValue:[hand userID] forKey:@"userID"];
                        [winner setValue:[hand userName] forKey:@"userName"];
                        [winner setValue:[hand type] forKey:@"type"];
                        [winner setValue:[hand getUsedInHandCards] forKey:@"hand"];
                        [winner setValue:[betAmounts valueForKey:[hand userID]] forKey:@"amount"];
                        [winner setValue:[hand getHandDetails] forKey:@"handDetails"];
                        [winner setValue:[hand cardOne] forKey:@"cardOne"];
                        [winner setValue:[hand cardTwo] forKey:@"cardTwo"];
                        [winner setValue:[hand communityCards] forKey:@"communityCards"];
                        //NSLog(@"Winner:%@",[hand userName]);
                        [winners addObject:winner];
                        [handWinners addObject:winner];
                        hand.processed = YES;
                    }else{
                        NSMutableDictionary *loser = [[NSMutableDictionary alloc] init];
                        [loser setValue:[hand userID] forKey:@"userID"];
                        [loser setValue:[hand userName] forKey:@"userName"];
                        [loser setValue:[hand type] forKey:@"type"];
                        [loser setValue:[betAmounts valueForKey:[hand userID]] forKey:@"amount"];
                        [losers addObject:loser];
                    }
                }
            }
            
            for (NSMutableDictionary *winner in handWinners) {
                double winnerContribution = 0;
                winnerContribution = [[winner valueForKey:@"amount"] doubleValue];
                 for (NSMutableDictionary *loser in losers) {
                     double extractAmount = 0;
                     if(winnerContribution > [[loser valueForKey:@"amount"] doubleValue]){
                         extractAmount = [[loser valueForKey:@"amount"] doubleValue]/[handWinners count];
                     }else {
                         extractAmount = winnerContribution/[handWinners count];
                     }
                     double winnerAmount = [[winner valueForKey:@"amount"] doubleValue] + extractAmount;
                     potAmount = potAmount - extractAmount;
                     [winner setValue:[NSString stringWithFormat:@"%.2f",winnerAmount] forKey:@"amount"];
                     
                     double userBetAmount = [[betAmounts valueForKey:[loser valueForKey:@"userID"]] doubleValue];
                     [betAmounts setValue:[NSString stringWithFormat:@"%.2f",userBetAmount - extractAmount] forKey:[loser valueForKey:@"userID"]];
                     
                     userBetAmount = [[betAmounts valueForKey:[winner valueForKey:@"userID"]] doubleValue];
                     [betAmounts setValue:[NSString stringWithFormat:@"%.2f",userBetAmount + extractAmount] forKey:[winner valueForKey:@"userID"]];
                }
                
                
                
                potAmount = potAmount - winnerContribution;
            }
            
            //NSLog(@"betAmounts:%@",betAmounts);
            
            int handsLeftForProcessing = 0;
            for (Hand *hand in hands) {
                if(!hand.processed && hand.value > 0){
                    handsLeftForProcessing++;
                }
            }
            
            if(handsLeftForProcessing <= 1){
                hasMorePots = NO;
                
                for (NSMutableDictionary *winner in winners) {
                    [betAmounts setValue:@"WINNER" forKey:[winner valueForKey:@"userID"]];
                }
                NSLog(@"betAmounts:%@",betAmounts);
                for(NSString *aKey in betAmounts){
                    
                    if(![@"WINNER" isEqualToString:[betAmounts valueForKey:aKey]]){
                        double spillOver = [[betAmounts valueForKey:aKey] doubleValue];
                        NSLog(@"spillOver:%@ %.2f",aKey,spillOver);
                        if(spillOver > 0){
                            NSMutableDictionary *playerState = [[self getPlayerForID:aKey game:currentGame] valueForKey:@"playerState"];
                            double newUserStack = [[playerState valueForKey:@"userStack"] doubleValue] + spillOver;
                            [playerState setValue:[NSString stringWithFormat:@"%.2f",newUserStack] forKey:@"userStack"];
                            NSLog(@"playerState:%@",playerState);
                        }
                    }//made up method
                    
                }
            }
        
        }
        

        NSMutableArray *discardedItems = [NSMutableArray array];
        for (NSMutableDictionary *winner in winners) {
            if([[winner valueForKey:@"amount"] doubleValue] > 0){
                [self incrementAchievement:@"W$SD" category:@"PROFILE" earnedValue:@"0" forUser:[winner valueForKey:@"userID"]];
            }else{
                [discardedItems addObject:winner];
            }
        }
        [winners removeObjectsInArray:discardedItems];
        
        //NSLog(@"winners:%@",winners);
        
        
        
        return winners;
        
   }
    
    
    return nil;
}



-(NSArray *)determinGameWinnerForCurrentGame{
    NSMutableArray *playersComplete = [[NSMutableArray alloc] init];
    NSMutableDictionary *gameSummary = [[currentGame valueForKey:@"gameState"] valueForKey:@"gameSummary"];
    for (NSMutableDictionary *player in [self getPlayersForCurrentGame]) {
        
        double playerTotal = 0;
        if([@"buyin" isEqualToString:[player objectForKey:@"status"]]){
            playerTotal =  (-1.0)*[[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue] - [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
        }else{
            if([self isCurrentGameTypeCash]){
                playerTotal = [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] - [[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue];
            }else{
                playerTotal = [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
                
            }
        }
        NSMutableDictionary *playerComplete = [[NSMutableDictionary alloc] init];
        [playerComplete setValue:[player valueForKey:@"userName"] forKey:@"userName"];
        [playerComplete setValue:[player valueForKey:@"userID"] forKey:@"userID"];
        [playerComplete setValue:[NSNumber numberWithDouble:playerTotal] forKey:@"playerTotal"];
        [playersComplete addObject:playerComplete];
    }

    NSSortDescriptor *playersTotaldDescriptor = [[NSSortDescriptor alloc] initWithKey:@"playerTotal" ascending:NO];
    NSArray * sortedArray = [playersComplete sortedArrayUsingDescriptors:
                             [NSArray arrayWithObject:playersTotaldDescriptor]];

    return sortedArray;
}


-(BOOL)canPlayerBet:(NSMutableDictionary *)player{
    //NSLog(@"player:%@",player);
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
    int highestPlayerOrder = 0;
    NSMutableDictionary *nextPlayer = nil;
    
    NSMutableArray *players = [self getPlayersForCurrentGame];
    for (int i = 0; i < players.count;i++) {
        nextPlayer = [players objectAtIndex:i];
        if([[[players objectAtIndex:i] objectForKey:@"order"] intValue] > highestPlayerOrder){
            highestPlayerOrder = [[[players objectAtIndex:i] objectForKey:@"order"] intValue];
        }
    }
    
    //NSLog(@"players:%@",players);
    if([players count] == 1){
        return [players objectAtIndex:0];
    }
    if(isFirstActor){
        for (NSMutableDictionary *player in players) {
            if([[[player valueForKey:@"playerState"] valueForKey:@"isDealer"] isEqualToString:@"YES"]){
                currentPlayerOrder = [[player valueForKey:@"order"] intValue];
            }
        }
    }else{
        currentPlayerOrder = [[[[DataManager sharedInstance] getPlayerForID:[currentGame objectForKey:@"nextActionForUserID"] game:currentGame] objectForKey:@"order"] intValue];
    }
    if(currentPlayerOrder == 0){
        currentPlayerOrder = [[[self getPlayerMeForCurrentGame] valueForKey:@"order"] intValue];
    }
    //NSLog(@"currentGame:%@",currentGame);
    nextPlayerOrder = currentPlayerOrder + 1;
    while(nextPlayerOrder !=currentPlayerOrder && currentPlayerOrder > 0){
        //NSLog(@"nextPlayer:%@   nextPlayerOrder:%d    currentPlayerOrder:%d",nextPlayer,nextPlayerOrder,currentPlayerOrder);
        
        
        if(nextPlayerOrder > highestPlayerOrder){
            nextPlayerOrder = 0;
        }
        
        for (int i = 0; i < players.count;i++) {
            
            nextPlayer = [players objectAtIndex:i];
            if(nextPlayerOrder == [[nextPlayer objectForKey:@"order"] intValue] && [self canPlayerBet:nextPlayer]){
                //NSLog(@"nextPlayer:%@",nextPlayer);
                return nextPlayer;
            }
        }
        
        nextPlayerOrder++;
        
        
        
    }
    return nextPlayer;
}




-(void)createNewGame:(NSMutableDictionary *)game{
    //invite via APN
       
    
    [game setValue:@"true" forKey:@"isPrivate"];
    NSMutableArray *players = [[game objectForKey:@"turnState"] objectForKey:@"players"];
    NSMutableArray *invitePlayers = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *player in players) {
        if(![[player valueForKey:@"userID"] isEqualToString:myUserID]){
            [invitePlayers addObject:[player valueForKey:@"userID"]];
        }
    }
    [[game valueForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%d",[players count]] forKey:@"numPlayers"];
    
    [[game valueForKey:@"gameSettings"] setValue:[[game valueForKey:@"gameSettings"] valueForKey:@"bigBlind"] forKey:@"originalBigBling"];
    [[game valueForKey:@"gameSettings"] setValue:[[game valueForKey:@"gameSettings"] valueForKey:@"smallBlind"] forKey:@"originalSmallBling"];
    
    NSString *message = [NSString stringWithFormat:@"%@ has invited you to %@ game %@",myUserName,NSLocalizedString([[game valueForKey:@"gameSettings"] valueForKey:@"type"],nil),[game valueForKey:@"gameID"],nil] ;
    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
    [payLoad setValue:currentGameID forKey:@"gameID"];
    [self sendAPN:invitePlayers message:message payLoad:payLoad];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:game options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *results = [[APIDataManager sharedInstance] createGame:jsonString];
    //NSLog(@"createGame results:%@",results);
    if(![@"1" isEqualToString:[results objectForKey:@"success"]]){
        self.createGameID = nil;
        NSLog(@"There was an error creating the game:%@",results);
    }else{
        self.createGameID = [results valueForKey:@"gameID"];
    }
    
    [self arrangeUserGames];
    NSMutableDictionary *earnedAchievement = [self getGameAchievementForCode:@"HOST_GAME" category:@"BLACK"];
    [self incrementAchievement:earnedAchievement forUser:myUserID];
    
}

-(void)offerRematch:(NSMutableDictionary *)game{
    NSMutableDictionary *rematchGame = [[NSMutableDictionary alloc] init];
    [rematchGame setValue:@"true" forKey:@"isPrivate"];
    [rematchGame setValue:myUserID forKey:@"gameOwnerID"];
    [rematchGame setValue:@"pending" forKey:@"status"];
    [rematchGame setValue:myUserID forKey:@"nextActionForUserID"];
    
    NSMutableDictionary *gameSettings = [NSMutableDictionary dictionaryWithDictionary:[game objectForKey:@"gameSettings"]];
    //NSLog(@"originalBigBling:%@",[[game valueForKey:@"gameSettings"] valueForKey:@"originalBigBling"]);
    //NSLog(@"originalSmallBling:%@",[[game valueForKey:@"gameSettings"] valueForKey:@"originalSmallBling"]);
    [gameSettings setValue:[[game valueForKey:@"gameSettings"] valueForKey:@"originalBigBling"] forKey:@"bigBlind"];
    [gameSettings setValue:[[game valueForKey:@"gameSettings"] valueForKey:@"originalSmallBling"] forKey:@"smallBlind"];
    
    [rematchGame setValue:gameSettings forKey:@"gameSettings"];
    //NSLog(@"rematchGame:%@",rematchGame);
    NSMutableArray *players = [[NSMutableArray alloc] init];
    NSMutableArray *existingPlayers = [[game objectForKey:@"turnState"] objectForKey:@"players"];
    NSMutableArray *invitePlayers = [[NSMutableArray alloc] init];
    int order = 0;
    for (NSMutableDictionary *player in existingPlayers) {
        if(![[player valueForKey:@"userID"] isEqualToString:myUserID]){
            [invitePlayers addObject:[player valueForKey:@"userID"]];
        }
        
        NSMutableDictionary *playerData = [[NSMutableDictionary alloc] init];
        order++;
        [playerData setValue:[NSString stringWithFormat:@"%d",order] forKey:@"order"];
        [playerData setValue:@"pending" forKey:@"status"];
        [playerData setValue:[player valueForKey:@"userID"] forKey:@"userID"];
        [playerData setValue:[player valueForKey:@"userName"] forKey:@"userName"];
        [players addObject:playerData];
    }
    NSMutableDictionary *playersDict = [[NSMutableDictionary alloc] init];
    [playersDict setValue:players forKey:@"players"];
    
    [rematchGame setValue:playersDict forKey:@"turnState"];
    [[rematchGame valueForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%d",[players count]] forKey:@"numPlayers"];
    NSString *message = [NSString stringWithFormat:@"%@ has invited you to a rematch. %@ game %@",myUserName,NSLocalizedString([[rematchGame valueForKey:@"gameSettings"] valueForKey:@"type"],nil),[rematchGame valueForKey:@"gameID"],nil] ;
    NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
    [payLoad setValue:currentGameID forKey:@"gameID"];
    [self sendAPN:invitePlayers message:message payLoad:payLoad];
    
    NSError *error;
    ///NSLog(@"rematchGame:%@",rematchGame);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rematchGame options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"rematchJSON:%@",jsonString);
    NSMutableDictionary *results = [[APIDataManager sharedInstance] createGame:jsonString];
    if(![@"1" isEqualToString:[results objectForKey:@"success"]]){
        NSLog(@"There was an error creating the game:%@",results);
    }
    
    [self arrangeUserGames];
    NSMutableDictionary *earnedAchievement = [self getGameAchievementForCode:@"HOST_GAME" category:@"BLACK"];
    [self incrementAchievement:earnedAchievement forUser:myUserID];
    
}

-(void)joinGame:(NSString *)gameType{
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setValue:myUserID forKey:@"userID"];
        [requestDict setValue:gameType forKey:@"category"];
       
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *results = [[APIDataManager sharedInstance] joinGame:jsonString];
        //NSLog(@"results:%@",results);
        if(![@"1" isEqualToString:[results objectForKey:@"success"]]){
            NSLog(@"There was an error joining the game:%@",results);
        }else{
            [self performSelectorOnMainThread:@selector(fetchedJoinGame:) 
                                   withObject:[results valueForKey:@"gameID"] waitUntilDone:YES];
        }
    });
}

-(void)fetchedJoinGame:(NSString *)gameID{
    self.joinGameID = gameID;
}

-(void)leaveCurrentGame{
    [self deleteGame:currentGame];    
}


-(BOOL)isGameWaitingForOtherPlayers:(NSMutableDictionary *)game{
    
    NSMutableArray *players = [self getPlayersForGame:game];
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
    NSMutableDictionary *currentPlayer = [self getPlayerMeForCurrentGame];
    [currentPlayer setValue:@"buyin" forKey:@"status"];
    [currentPlayer setValue:playerState forKey:@"playerState"];
    
    [self updatePlayer:currentPlayer];
    
    NSMutableArray *players = [self getPlayersForCurrentGame];
    int numOfBuyInPlayers = 0;
    for(int i = 0; i < players.count;i++){
        NSMutableDictionary *player = [players objectAtIndex:i];
        
        if([[player objectForKey:@"status"] isEqualToString:@"buyin"]){
            numOfBuyInPlayers++;
        }
    }
    
    if([self isCurrentGameTypeTournament] && [self isCurrentGamePending]){
        if([players count] == numOfBuyInPlayers){
            [[DataManager sharedInstance] startCurrentGame];
            //[[DataManager sharedInstance] addBettingRoundIfNeeded];
            
        }
    }else if([self isCurrentGameTypeCash] && [self isCurrentGamePending]){
        if(numOfBuyInPlayers > 1){
            [[DataManager sharedInstance] startCurrentGame];
            //[[DataManager sharedInstance] addBettingRoundIfNeeded];
            
        }
        
    }
    
    /*
    if([[currentGame valueForKey:@"status"] isEqualToString:@"pending"]){
        NSMutableArray *players = [[currentGame objectForKey:@"turnState"] objectForKey:@"players"];
        int numOfPendingPlayers = 0;
        for(int i = 0; i < players.count;i++){
            NSMutableDictionary *player = [players objectAtIndex:i];
            
            if([[player objectForKey:@"status"] isEqualToString:@"pending"] && ![[player objectForKey:@"userID"] isEqualToString:myUserID]){
                numOfPendingPlayers++;
            }
        }
        if(numOfPendingPlayers == 0){
            NSMutableArray *recipients = [[NSMutableArray alloc] init];
            [recipients addObject:[currentGame valueForKey:@"gameOwnerID"]];
            NSMutableDictionary *payLoad = [[NSMutableDictionary alloc] init];
            [payLoad setValue:currentGameID forKey:@"gameID"];
            [self sendAPN:recipients message:[NSString stringWithFormat:@"%@ is nudging you for game# %@",myUserName,currentGameID] payLoad:payLoad];
        }
    }*/
}


-(void)startCurrentGame{
   
    NSMutableDictionary *gameState = [[NSMutableDictionary alloc] init];
    if(![currentGame valueForKey:@"gameState"] || ![[currentGame valueForKey:@"gameState"] valueForKey:@"hands"]){
        NSMutableArray *hands = [[NSMutableArray alloc] initWithCapacity:1];
        [gameState setValue:hands forKey:@"hands"];
        [currentGame setValue:gameState forKey:@"gameState"];
        NSMutableArray *players = [self getPlayersForCurrentGame];
        for (NSMutableDictionary *player in players) {
            if([[player objectForKey:@"status"] isEqualToString:@"buyin"]){
                if([self isCurrentGameTypeCash]){
                    [self incrementAchievement:@"CASH_GAMES_PLAYED" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                }else if([self isCurrentGameTypeTournament]){
                    [self incrementAchievement:@"TOURNAMENT_GAMES_PLAYED" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
                }
                [self incrementAchievement:@"GAMES_PLAYED" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
            }
        }
    }
    
    [self dealNewHand];
    [currentGame setValue:@"active" forKey:@"status"];
    
     NSLog(@"currentGame:%@",currentGame);
    [self updateCurrentGame];
    
    
}

-(void)dealNewHand{
    NSMutableArray *players = [self getPlayersForCurrentGame];
    
    NSMutableDictionary *gameSummary = [[currentGame valueForKey:@"gameState"] valueForKey:@"gameSummary"];
    if(!gameSummary){
        gameSummary = [[NSMutableDictionary alloc] init];
        [[currentGame valueForKey:@"gameState"] setValue:gameSummary forKey:@"gameSummary"];
    }
    
    for (NSMutableDictionary *player in players) {
        if([[player objectForKey:@"status"] isEqualToString:@"buyin"]){
            //NSLog(@"player:%@",player);
            double buyInSummary = [[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue];
            buyInSummary = buyInSummary + [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
            [player setValue:@"playing" forKey:@"status"];
            [gameSummary setValue:[NSString stringWithFormat:@"%.2f",buyInSummary] forKey:[player valueForKey:@"userID"]];
        }
        [[player objectForKey:@"playerState"] setValue:@"in" forKey:@"action"];
        [[player objectForKey:@"playerState"] setValue:@"0" forKey:@"lastBetHandState"];
        if([[[player objectForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] <= 0){
            if([self isCurrentGameTypeCash]){
                [player setValue:@"pending" forKey:@"status"];
            }else{
                [player setValue:@"out" forKey:@"status"];
            }
        }
    }
        
    NSMutableDictionary *hand = [[NSMutableDictionary alloc] init];
    int handNumber = [(NSMutableArray *)[[currentGame objectForKey:@"gameState"] objectForKey:@"hands"] count];
    int numOfHands = [[[currentGame objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue];
    double smallBlind = [[[currentGame objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    double bigBlind = [[[currentGame objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] doubleValue];
    
    if([self isCurrentGameTypeCash]){
        int handsLeft = numOfHands - [self currentHandInt];
        if(handsLeft == 3){
            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"There are %d hands left in this cash game",handsLeft]];
        }else if(handsLeft == 2){
            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"There are %d hands left in this cash game",handsLeft]];
        }else if(handsLeft == 1){
            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"There are %d hands left in this cash game",handsLeft]];
        }else if(handsLeft == 0){
            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"This is the last hand of this cash game. Make it a good one!"]];
        }
    }
    
    if(handNumber >= numOfHands && [self isCurrentGameTypeTournament]){
        if(handNumber%numOfHands == 0){
            smallBlind = smallBlind*2;
            bigBlind = bigBlind*2;
            [[currentGame objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",smallBlind] forKey:@"smallBlind"];
            [[currentGame objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",bigBlind] forKey:@"bigBlind"];
            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"Blinds have doubled to $%.2f / $%.2f",smallBlind,bigBlind]];
        }
    }
    
    
    
    
    
    double potSize = smallBlind + bigBlind;
    [hand setValue:@"1" forKey:@"state"];
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
    //NSLog(@"Dealer Player:%@",[dealerPlayer valueForKey:@"userName"]);
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
            [self incrementAchievement:@"HANDS_PLAYED" category:@"PROFILE" earnedValue:@"0" forUser:[player valueForKey:@"userID"]];
        }
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
    //NSLog(@"smallBlindPlayer:%@",[smallBlindPlayer valueForKey:@"userName"]);
    [currentGame setValue:[smallBlindPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    [[smallBlindPlayer valueForKey:@"playerState"] setValue:@"YES" forKey:@"isSmallBlind"];
    
    [smallBlindRound setValue:@"0" forKey:@"potSize"];
    [smallBlindRound setValue:@"smallBlind" forKey:@"action"];
    double userStackSmallBlind = [[[smallBlindPlayer objectForKey:@"playerState"] objectForKey:@"userStack"] doubleValue];
    if(userStackSmallBlind < smallBlind){
        smallBlind = userStackSmallBlind;
    }
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
    [self incrementAcievementValue:@"MONEY_BET" category:@"PROFILE" forUser:[smallBlindPlayer valueForKey:@"userID"] valueInc:smallBlind];
    if([self isCurrentGameTypeCash]){
        [self incrementAcievementValue:@"MONEY_BET_CASH_GAME" category:@"PROFILE" forUser:[smallBlindPlayer valueForKey:@"userID"] valueInc:smallBlind];
    }else if([self isCurrentGameTypeTournament]){
        [self incrementAcievementValue:@"MONEY_BET_TOURNAMENT_GAME" category:@"PROFILE" forUser:[smallBlindPlayer valueForKey:@"userID"] valueInc:smallBlind];
    }
    
    
    NSMutableDictionary *bigBlindRound = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bigBlindPlayer = [self getNextTurnPlayerFromCurrentGame:NO];
    //NSLog(@"bigBlindPlayer:%@",[bigBlindPlayer valueForKey:@"userName"]);
    [currentGame setValue:[bigBlindPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    [[bigBlindPlayer valueForKey:@"playerState"] setValue:@"YES" forKey:@"isBigBlind"];
    [bigBlindRound setValue:@"0" forKey:@"potSize"];
    [bigBlindRound setValue:@"bigBlind" forKey:@"action"];
    double userStackBigBlind = [[[bigBlindPlayer objectForKey:@"playerState"] objectForKey:@"userStack"] doubleValue];
    if(userStackBigBlind < bigBlind){
        bigBlind = userStackBigBlind;
    }
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
    [self incrementAcievementValue:@"MONEY_BET" category:@"PROFILE" forUser:[bigBlindPlayer valueForKey:@"userID"] valueInc:bigBlind];
    if([self isCurrentGameTypeCash]){
        [self incrementAcievementValue:@"MONEY_BET_CASH_GAME" category:@"PROFILE" forUser:[bigBlindPlayer valueForKey:@"userID"] valueInc:bigBlind];
    }else if([self isCurrentGameTypeTournament]){
        [self incrementAcievementValue:@"MONEY_BET_TOURNAMENT_GAME" category:@"PROFILE" forUser:[bigBlindPlayer valueForKey:@"userID"] valueInc:bigBlind];
    }
    
    
    NSMutableDictionary *nextPlayer = [self getNextTurnPlayerFromCurrentGame:NO];
    //NSLog(@"nextPlayer:%@",[nextPlayer valueForKey:@"userName"]);
    [currentGame setValue:[nextPlayer objectForKey:@"userID"] forKey:@"nextActionForUserID"];
    
    [hand setValue:rounds forKey:@"rounds"];
    
    
    [(NSMutableArray *)[[currentGame valueForKey:@"gameState"] valueForKey:@"hands"] insertObject:hand atIndex:0];
    self.currentHand = hand;
    [self addBettingRoundIfNeeded];
    [self updateCurrentGame];
    [self sendAchievements:YES];
    
}


-(BOOL)hasCurrentGameMoreHands{
    
    if([self isCurrentGameTypeCash]){
        int numOfHands =[[[currentGame valueForKey:@"gameSettings"] valueForKey:@"numOfHands"] intValue];
        int currentHandNum = [[currentHand valueForKey:@"number"] intValue];
        if(numOfHands <=currentHandNum){
            return NO;
        }
    }else if([self isCurrentGameTypeTournament]){
        int numOfRemainingPlayers = 0;
        NSMutableArray *players = [self getPlayersForCurrentGame];
        for (NSMutableDictionary *player in players) {
            if([[player valueForKey:@"status"] isEqualToString:@"playing"]){
                numOfRemainingPlayers++;
            }
        }
        if(numOfRemainingPlayers < 2){
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

-(int)getNumberOfRaisesforCurrentRound{
    //NSLog(@"currentHand:%@",self.currentHand);
    int numOfRaisesinRound = 0;
    int handState = [[currentHand valueForKey:@"state"] intValue];
    for (NSMutableDictionary *round in [currentHand valueForKey:@"rounds"]) {
        if(round && [[round valueForKey:@"handState"] intValue] == handState){
            if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
                numOfRaisesinRound++;
            }
        }
    }
    return numOfRaisesinRound;
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

-(NSMutableArray *)getPlayersInTableArangement{
    NSMutableArray *seatedPlayers = [[NSMutableArray alloc] init];
    NSMutableDictionary *playerMe = nil;
    int index = 0;
    for (NSMutableDictionary *player in [self getPlayersForCurrentGame]) {
        if(playerMe){
            if(![[player valueForKey:@"status"] isEqualToString:@"leave"]){
                [seatedPlayers addObject:player];
            }
        }else{
            index++;
        }
        if([[player valueForKey:@"userID"] isEqualToString:myUserID]){
            playerMe = player;
            if(![[player valueForKey:@"status"] isEqualToString:@"leave"]){
                [seatedPlayers addObject:player];
            }
        }
        
    }
    
    for(int i=0; i < index-1;i++){
        NSMutableDictionary *player = [[self getPlayersForCurrentGame] objectAtIndex:i];
        if(![[player valueForKey:@"status"] isEqualToString:@"leave"]){
            [seatedPlayers addObject:player];
        }
    }
    
    return seatedPlayers;
}

-(void)purchaseShowAchievementForPlayerProfile{
    if([[StoreFront sharedStore] decrementUserCurrency:[[showAchievement valueForKey:@"purchaseValue"] intValue]]){
        [showAchievement setValue:@"0" forKey:@"earnedValue"];
        [self incrementAchievement:showAchievement forUser:[playerProfile valueForKey:@"userID"]];
    }
}

-(void)incrementAchievement:(NSMutableDictionary *)gameAchievement forUser:(NSString *)userID{
    [self incrementAchievement:[gameAchievement valueForKey:@"code"] category:[gameAchievement valueForKey:@"category"] earnedValue:[gameAchievement valueForKey:@"earnedValue"] forUser:userID];
}

-(void)incrementAchievement:(NSString *)code category:(NSString *)category earnedValue:(NSString *)earnedValue forUser:(NSString *)userID{
    [self incrementAchievement:code category:category earnedValue:earnedValue forUser:userID countInc:1];
    
}

-(void)incrementAchievement:(NSString *)code category:(NSString *)category earnedValue:(NSString *)earnedValue forUser:(NSString *)userID countInc:(int)countInc{
    if(!code){
        return;
    }
    NSLog(@"code:%@  category:%@ userID:%@",code,category,userID);
    if(!localAcievements){
        self.localAcievements = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *achievement;
    for (NSMutableDictionary *localAchievement in localAcievements) {
        if([[localAchievement valueForKey:@"userID"] isEqualToString:userID] &&
           [[localAchievement valueForKey:@"code"] isEqualToString:code] &&
           [[localAchievement valueForKey:@"category"] isEqualToString:category]){
            achievement = localAchievement;
        }
    }
    if(!achievement){
        achievement = [[NSMutableDictionary alloc] init];
        [achievement setValue:userID forKey:@"userID"];
        [achievement setValue:category forKey:@"category"];
        [achievement setValue:code forKey:@"code"];
        [achievement setValue:@"0" forKey:@"countInc"];
        [localAcievements addObject:achievement];
    }
    
    int achievementCount = [[achievement valueForKey:@"countInc"] intValue] + countInc;
    [achievement setValue:[NSNumber numberWithInt:achievementCount] forKey:@"countInc"];
    int currencyInc = [earnedValue intValue];
    [achievement setValue:[NSString stringWithFormat:@"%d",currencyInc*achievementCount] forKey:@"currencyInc"];
    [achievement setValue:earnedValue forKey:@"earnedValue"];
    if(currencyInc !=0){
        self.proChipsIncrement = currencyInc;
    }
    self.addAchievement = achievement;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:localAcievements forKey:[NSString stringWithFormat:@"LOCAL_ACHIEVEMENTS_%@",myUserID]];
    [self sendAchievements:NO];
}

-(void)incrementAcievementValue:(NSString *)code category:(NSString *)category forUser:(NSString *)userID valueInc:(double)valueInc{
    
    if(!localAcievements){
        self.localAcievements = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *achievement;
    for (NSMutableDictionary *localAchievement in localAcievements) {
        if([[localAchievement valueForKey:@"userID"] isEqualToString:userID] &&
           [[localAchievement valueForKey:@"code"] isEqualToString:code] &&
           [[localAchievement valueForKey:@"category"] isEqualToString:category]){
            achievement = localAchievement;
        }
    }
    if(!achievement){
        achievement = [[NSMutableDictionary alloc] init];
        [achievement setValue:userID forKey:@"userID"];
        [achievement setValue:category forKey:@"category"];
        [achievement setValue:code forKey:@"code"];
        [achievement setValue:@"0" forKey:@"valueInc"];
        [localAcievements addObject:achievement];
    }
    
    double achievementValue = [[achievement valueForKey:@"valueInc"] doubleValue] + valueInc;
    [achievement setValue:[NSString stringWithFormat:@"%.2f",achievementValue] forKey:@"valueInc"];
    self.addAchievement = achievement;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:localAcievements forKey:[NSString stringWithFormat:@"LOCAL_ACHIEVEMENTS_%@",myUserID]];
    [self sendAchievements:NO];    
}

-(void)sendAchievements:(BOOL)forceSend{
    
    
    
    
    //NSLog(@"localAcievements:%@",localAcievements);
    if((!isSendingAchievements && [self numOfLocalAchievements] >= achivementQueueLimit) || forceSend){
        //send the achievement to the server
        isSendingAchievements = YES;
        dispatch_async(kBgQueue, ^{
            NSMutableArray *sendingAchievements = [NSMutableArray arrayWithArray:localAcievements];        
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendingAchievements options:NSJSONWritingPrettyPrinted error:&error];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //NSLog(@"jsonString:%@",jsonString);
            NSMutableDictionary *results = [[APIDataManager sharedInstance] postAchievements:jsonString];
            
            if(!results || ![@"1" isEqualToString:[results objectForKey:@"success"]]){
                //NSLog(@"results:%@",results);
            }else{
                [self performSelectorOnMainThread:@selector(finishedSendingAchievements:) 
                                       withObject:sendingAchievements waitUntilDone:YES];
            }
        });
    }else{
        //store the achievement locally until we have enough worth sending, otherwise we kill the server will post achievement calls
        dispatch_async(kBgQueue, ^{
            [[NSUserDefaults standardUserDefaults] synchronize];
         });
    }
    
}

-(void)finishedSendingAchievements:(NSMutableArray *)sentAchievements{
    
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (NSMutableDictionary *localAchievement in localAcievements) {
        for (NSMutableDictionary *sentAchievement in sentAchievements) {
            if([[localAchievement valueForKey:@"userID"] isEqualToString:[sentAchievement valueForKey:@"userID"]] &&
               [[localAchievement valueForKey:@"code"] isEqualToString:[sentAchievement valueForKey:@"code"]] &&
               [[localAchievement valueForKey:@"category"] isEqualToString:[sentAchievement valueForKey:@"category"]]){
                int newCountInc = [[localAchievement valueForKey:@"countInc"] intValue] - [[sentAchievement valueForKey:@"countInc"] intValue];
                if(newCountInc < 0){
                    newCountInc = 0;
                }
                [localAchievement setValue:[NSString stringWithFormat:@"%d",newCountInc] forKey:@"countInc"];  
                if(newCountInc == 0){
                    [discardedItems addObject:localAchievement];
                }
            }
        }
    }
    [localAcievements removeObjectsInArray:discardedItems];
    isSendingAchievements = NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:localAcievements forKey:[NSString stringWithFormat:@"LOCAL_ACHIEVEMENTS_%@",myUserID]];
    [self loadPlayerProfile:[playerProfile valueForKey:@"userID"]];
}

-(int)numOfLocalAchievements{
    int counter = 0;
    for (NSMutableDictionary *localAchievement in localAcievements) {
        counter = counter + [[localAchievement valueForKey:@"countInc"] intValue];
    }
    return counter;
}

-(int)getCountForUserAchievement:(NSMutableDictionary *)gameAchievement{
    return [self getCountForUserAchievement:[gameAchievement valueForKey:@"code"] category:[gameAchievement valueForKey:@"category"]];
}

-(BOOL)shouldIncrementPrimaryAchievement:(NSString *)category{
    NSMutableArray *gamesAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:category];
    int primaryAchievementCount = 0;
    NSMutableDictionary *primaryAchievement = [gamesAchievements objectAtIndex:0];
    primaryAchievementCount = [self getCountForUserAchievement:[primaryAchievement valueForKey:@"code"] category:[primaryAchievement valueForKey:@"category"]];
    
   
    int minValue = 9999999999;
    for (int i = 1; i < [gamesAchievements count]; i++) {
        NSMutableDictionary *gameAchievement = [gamesAchievements objectAtIndex:i];
        if([self getCountForUserAchievement:[gameAchievement valueForKey:@"code"] category:[gameAchievement valueForKey:@"category"]] < minValue){
            
            minValue = [self getCountForUserAchievement:[gameAchievement valueForKey:@"code"] category:[gameAchievement valueForKey:@"category"]];
            
            
            
        }
    }
    if(minValue > primaryAchievementCount){
        return YES;
    }
    return NO;
}


-(void)setProfileToMe{
    self.playerProfile = myProfile;
}



-(int)getCountForUserAchievement:(NSString *)code category:(NSString *)category{
    int localCount = 0;
    if(!playerProfile){
        [self setProfileToMe];
    }
    //NSLog(@"localAchievements:%@",localAcievements);
    //NSLog(@"profile.Achievements:%@",[self.playerProfile valueForKey:@"achievements"]);
    //NSLog(@"profile.userID:%@",[self.playerProfile valueForKey:@"userID"]);
    for (NSMutableDictionary *localAchievement in localAcievements) {
        //NSLog(@"localAchievement.code:%@ localAchievement.category:%@ localAchievement.userID:%@",[localAchievement valueForKey:@"code"],[localAchievement valueForKey:@"category"],[localAchievement valueForKey:@"userID"]);
        //NSLog(@"code:%@ category:%@ userID:%@",code,category,[self.playerProfile objectForKey:@"userID"]);

        if([[localAchievement valueForKey:@"userID"] isEqualToString:[self.playerProfile objectForKey:@"userID"]] &&
           [[localAchievement valueForKey:@"code"] isEqualToString:code] &&
           [[localAchievement valueForKey:@"category"] isEqualToString:category]){
            localCount = [[localAchievement valueForKey:@"countInc"] intValue];
        }
    }
    
    //NSLog(@"playerProfile:%@",playerProfile);
    int profileCount = 0;
    for (NSMutableDictionary *achievementTmp in [self.playerProfile objectForKey:@"achievements"]) {
        //NSLog(@"achievementTmp:%@ %@",[gameAchievement valueForKey:@"code"],[gameAchievement valueForKey:@"category"]);
        //NSLog(@"gameAchievement:%@ %@",[achievementTmp valueForKey:@"code"],[achievementTmp valueForKey:@"category"]);
        if([code isEqualToString:[achievementTmp valueForKey:@"code"]] && [category isEqualToString:[achievementTmp valueForKey:@"category"]]){
            
            profileCount = [[achievementTmp valueForKey:@"count"] intValue];
            
        }
    }
    return localCount + profileCount;
}


-(void)logAchievements{
    NSLog(@"Logging Achievements!!");
    for (NSMutableDictionary *localAchievement in localAcievements) {
        NSLog(@"localAchievement.code:%@ localAchievement.category:%@ localAchievement.userID:%@",[localAchievement valueForKey:@"code"],[localAchievement valueForKey:@"category"],[localAchievement valueForKey:@"userID"]);
       
    }
    NSLog(@"playerProfile:%@",playerProfile);
}


-(BOOL)currentUserHasAchievement:(NSMutableDictionary *)achievement{
    if([self getCountForUserAchievement:achievement] > 0){
        return YES;
    }
    return NO;
    
}


-(double)getValueForUserAchievement:(NSString *)code{
    for (NSMutableDictionary *achievementTmp in [self.playerProfile objectForKey:@"achievements"]) {
        //NSLog(@"achievementTmp:%@ %@",[gameAchievement valueForKey:@"code"],[gameAchievement valueForKey:@"category"]);
        //NSLog(@"gameAchievement:%@ %@",[achievementTmp valueForKey:@"code"],[achievementTmp valueForKey:@"category"]);
        if([code isEqualToString:[achievementTmp valueForKey:@"code"]]){
            return [[achievementTmp valueForKey:@"value"] doubleValue];
        }
    }
    return  0.0;
}


-(NSMutableArray *)getProfileAchievements:(NSString *)category{
    return nil;
}

-(NSMutableDictionary *)getGameAchievementForCode:(NSString *)code category:(NSString *)category{
    NSMutableArray *categoryAchievements = [self.gameAchievements valueForKey:category];
    for (NSMutableDictionary *achievementTmp in categoryAchievements) {
        if([[achievementTmp valueForKey:@"code"] isEqualToString:code]){
            return achievementTmp;
        }
    }
    return nil;
}


-(NSMutableDictionary *)getPlayerAchievementForCode:(NSString *)code category:(NSString *)category{
    
    for (NSMutableDictionary *achievementTmp in [playerProfile valueForKey:@"achievements"]) {
        if([[achievementTmp valueForKey:@"code"] isEqualToString:code] && [[achievementTmp valueForKey:@"category"] isEqualToString:category]){
            return achievementTmp;
        }
    }
    return nil;
}



-(void)checkAchievements:(NSMutableDictionary *)winningHand{
    //NSLog(@"winning hand:%@",winningHand);
    NSMutableDictionary *myRound;
    
    for (NSMutableDictionary *round in [winningHand valueForKey:@"rounds"]) {
        if([[round valueForKey:@"userID"] isEqualToString:myUserID]){
            myRound = round;
        }
    }
    NSString *cardOne = [myRound valueForKey:@"cardOne"];
    NSString *cardTwo = [myRound valueForKey:@"cardTwo"];
    //NSLog(@"myRound:%@",myRound);
    
    NSMutableDictionary *myWinner;
    for (NSMutableDictionary *winner in [winningHand valueForKey:@"winners"]) {
        if([[winner valueForKey:@"userID"] isEqualToString:myUserID]){
            myWinner = winner;
        }   
    }
    //NSLog(@"myWinner:%@",myWinner);
    
    NSMutableArray *handArray = [winningHand valueForKey:@"communityCards"];
    [handArray addObject:[myRound valueForKey:@"cardOne"]];
    [handArray addObject:[myRound valueForKey:@"cardTwo"]];
    
    Hand *myHand = [[Hand alloc] initWithCards:handArray];
    //[myHand logHand];
    
    if([cardOne hasPrefix:@"A"] && [cardTwo hasPrefix:@"A"]){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"PAIR_ACES" category:@"SILVER"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }
    
    if([cardOne hasPrefix:@"K"] && [cardTwo hasPrefix:@"K"]){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"PAIR_KINGS" category:@"BRONZE"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }
    
    if(([cardOne hasPrefix:@"A"] && [cardTwo hasPrefix:@"K"]) || ([cardOne hasPrefix:@"K"] && [cardTwo hasPrefix:@"A"])){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"ACE_KING" category:@"BRONZE"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }
    
    if([cardOne hasPrefix:@"Q"] && [cardTwo hasPrefix:@"Q"]){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"PAIR_QUEENS" category:@"BRONZE"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }
    
    if([[cardOne substringToIndex:1] isEqualToString:[cardTwo substringToIndex:1]]){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"POCKETS" category:@"BLACK"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
    }
    
    NSMutableDictionary *winner;
    if([[winningHand valueForKey:@"winners"] count] > 0){
        winner = [[winningHand valueForKey:@"winners"] objectAtIndex:0];
    }
    if(![[winner valueForKey:@"type"] isEqualToString:@"USER_FOLD"]){
        if([myHand isTwoPairs]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"TWO_PAIR" category:@"SILVER"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }else if([myHand isThreeOfAKind]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"TRIPS" category:@"SILVER"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }else if([myHand isThreeOfAKind]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"TRIPS" category:@"SILVER"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }else if([myHand isStraight]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"STRAIGHT" category:@"GOLD"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }else if([myHand isFlush]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"FLUSH" category:@"GOLD"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }else if([myHand isFullHouse]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"FULL_HOUSE" category:@"GOLD"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }else if([myHand isStraightFlush]){
            if([myHand.type isEqualToString:@"ROYAL_FLUSH"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"ROYAL_FLUSH" category:@"PLATINUM"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
            }else if([myHand.type isEqualToString:@"STRAIGHT_FLUSH"]){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"STRAIGHT_FLUSH" category:@"PLATINUM"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
            }
        }else if([myHand isFourOfAKind]){
            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"FOUR_OF_A_KIND" category:@"PLATINUM"];
            [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
        }
    }
    
    //BIG POT
    NSMutableDictionary *gameSettings = [currentGame valueForKey:@"gameSettings"];
    if([[myWinner valueForKey:@"amount"] doubleValue] >= [[gameSettings valueForKey:@"maxBuy"] doubleValue]*4){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BIG_POT_4" category:@"PLATINUM"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }else if([[myWinner valueForKey:@"amount"] doubleValue] >= [[gameSettings valueForKey:@"maxBuy"] doubleValue]*3){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BIG_POT_3" category:@"GOLD"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }else if([[myWinner valueForKey:@"amount"] doubleValue] >= [[gameSettings valueForKey:@"maxBuy"] doubleValue]*2){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BIG_POT_2" category:@"SILVER"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }else if([[myWinner valueForKey:@"amount"] doubleValue] >= [[gameSettings valueForKey:@"maxBuy"] doubleValue]){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BIG_POT_1" category:@"BRONZE"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }
    
    int handWinStreak = 0;
    for (NSMutableDictionary *hand in [[currentGame valueForKey:@"gameState"] valueForKey:@"hands"]) {
        BOOL isMeWinner = NO;
        for (NSMutableDictionary *winner in [hand valueForKey:@"winners"]) {
            if([[winner valueForKey:@"userID"] isEqualToString:myUserID]){
                isMeWinner = YES;
            }
        }
        if(isMeWinner){
            handWinStreak++;
        }else {
            handWinStreak = 0;
            break;
        }
    }
    /*
    if(handWinStreak == 3){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_STREAK_3" category:@"BRONZE"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }else if(handWinStreak == 5){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_STREAK_5" category:@"SILVER"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }else if(handWinStreak == 7){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_STREAK_7" category:@"GOLD"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }else if(handWinStreak == 10){
        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_STREAK_10" category:@"PLATINUM"];
        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[myWinner valueForKey:@"userID"]];
    }*/

}

-(int)incrementClientTally:(NSString *)code gameID:(NSString *)gameID{
    
    NSMutableDictionary *tallyDict = [tally objectForKey:gameID];
    if(!tallyDict){
        tallyDict = [[NSMutableDictionary alloc] init]; 
    }
    
    int tallyValue = [[tallyDict valueForKey:code] intValue];
    tallyValue = tallyValue + 1;
    [tallyDict setValue:[NSString stringWithFormat:@"%d",tallyValue] forKey:code];
    [tally setObject:tallyDict forKey:gameID];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:tally forKey:[NSString stringWithFormat:@"LOCAL_TALLY_%@",myUserID]];
    [prefs synchronize];
    return tallyValue;
}

-(BOOL)isPlayerStatsLocked:(NSString *)userID{
    if([userID isEqualToString:myUserID]){
        return NO;
    }
    for (NSMutableDictionary *inventoryItem in myInventory) {
        //NSLog(@"inventoryItem:%@",inventoryItem);
        if([[inventoryItem valueForKey:@"category"] isEqualToString:@"PLAYER_STATS"] && [[inventoryItem valueForKey:@"value"] isEqualToString:userID]){
            return NO;
        }
    }
    return YES;
}

-(BOOL)isCurrentPlayerProfileStatsLocked{
    return [self isPlayerStatsLocked:[self.playerProfile valueForKey:@"userID"]];
}

-(BOOL)isGameStatsUnlocked{
    for (NSMutableDictionary *inventoryItem in myInventory) {
        //NSLog(@"inventoryItem:%@",inventoryItem);
        if([[inventoryItem valueForKey:@"category"] isEqualToString:@"GAME_STATS"] && [[inventoryItem valueForKey:@"value"] isEqualToString:currentGameID]){
            return YES;
        }
    }
    return NO;
    
}


-(void)loadPlayersAchievements:(NSMutableArray *)playersArray{
    dispatch_async(kBgQueue, ^{
        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *playerDict in playersArray) {
            [usersArray addObject:[playerDict valueForKey:@"userID"]];
        }
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:usersArray options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"loadPlayersAchievements Request:%@",jsonString);
        NSMutableDictionary *results = [[APIDataManager sharedInstance] getAchievements:jsonString]; 
        //NSLog(@"loadPlayersAchievements Response:%@",results);
        
        [self performSelectorOnMainThread:@selector(fetchedPlayersAchievements:) 
                               withObject:results waitUntilDone:YES];
    });
    
}



-(void)fetchedPlayersAchievements:(NSMutableDictionary *)inventory{
    self.multiPlayerAchievements = inventory;
    //NSLog(@"multiPlayerAchievements:%@",multiPlayerAchievements);
}


-(UIImage *)getAvatar:(NSString *)userID{
    if(avatars){
        return [avatars objectForKey:userID];
    }
    return nil;
}

-(void)setAvatar:(UIImage *)avatar userID:(NSString *)userID{
    if(!avatars){
        self.avatars = [[NSMutableDictionary alloc] init];
    }
    [avatars setObject:avatar forKey:userID];
}

-(int)getChipStackState:(NSString *)userID{
    
    return [self getUserChipStackStateForPlayers:userID players:[[DataManager sharedInstance] getPlayersForCurrentGame]];
}

-(int)getUserChipStackStateForPlayers:(NSString *)userID  players:(NSMutableArray *)players{
    double bigStack = 0.00;
    double lowStack = -1.0;
    double thisUserStack = 0.0;
    for (NSMutableDictionary *player in players) {
        double userStack = [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
        if([[player valueForKey:@"status"] isEqualToString:@"playing"]){
            if([[player valueForKey:@"userID"] isEqualToString:userID]){
                thisUserStack = userStack;
            }
            if(lowStack == -1.0){
                lowStack = userStack;
            }
            if(userStack > bigStack){
                bigStack = userStack;
                
            }
            if(userStack < lowStack){
                lowStack = userStack;
            }
        }
    }
    
    
    
    int chipState;
    if(thisUserStack == bigStack){
        chipState = 1;
    }else if(thisUserStack == lowStack){
        chipState = 3;
    }else{
        chipState = 2;
    }
    return chipState;

    
}


-(BOOL)hasCurrentUserPurchasedGameStatsForCurrentGame{
    return YES;
    
}

-(int)currentHandInt{
    return [(NSMutableArray *)[[currentGame objectForKey:@"gameState"] objectForKey:@"hands"] count];
}

-(void)buyGift:(NSMutableDictionary *)gift forUser:(NSString *)userID{
    
        
        NSMutableArray *buyGifts = [[NSMutableArray alloc] init];
        int playerCount = 0;
        if([@"-1" isEqualToString:userID]){
            for (NSMutableDictionary *player in [self getPlayersForCurrentGame]) {
                if(![[player valueForKey:@"status"] isEqualToString:@"leave"]){
                    NSMutableDictionary *giftDict = [[NSMutableDictionary alloc] init];
                    [giftDict setValue:[player valueForKey:@"userID"] forKey:@"userID"];
                    [giftDict setValue:currentGameID forKey:@"gameID"];
                    [gift setValue:[NSString stringWithFormat:@"%d",[self currentHandInt]] forKey:@"handNumber"];
                    [giftDict setValue:gift forKey:@"gift"];
                    [buyGifts addObject:giftDict];
                    playerCount++;
                }
            }
        }else{
            NSMutableDictionary *giftDict = [[NSMutableDictionary alloc] init];
            playerCount++;
            [giftDict setValue:userID forKey:@"userID"];
            [giftDict setValue:currentGameID forKey:@"gameID"];
            [gift setValue:[NSString stringWithFormat:@"%d",[(NSMutableArray *)[[currentGame objectForKey:@"gameState"] objectForKey:@"hands"] count]] forKey:@"handNumber"];
            [giftDict setValue:gift forKey:@"gift"];
            [buyGifts addObject:giftDict];

        }
        
        int purchaseValue = playerCount * [[gift valueForKey:@"purchaseValue"] intValue];
        if([[StoreFront sharedStore] decrementUserCurrency:purchaseValue]){
            dispatch_async(kBgQueue, ^{
            
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:buyGifts options:NSJSONWritingPrettyPrinted error:&error];
                
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //NSLog(@"jsonString:%@",jsonString);
                NSMutableDictionary *results = [[APIDataManager sharedInstance] postGiftForUser:jsonString];
                //NSLog(@"results:%@",results);
                if([@"1" isEqualToString:[results objectForKey:@"success"]]){
                    [self performSelectorOnMainThread:@selector(giftPurchased:) 
                                           withObject:gift waitUntilDone:YES];
                    NSString *titleKey = [NSString stringWithFormat:@"gift.%@.title",[gift valueForKey:@"code"]];
                    if([@"-1" isEqualToString:userID]){
                        [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"%@ bought a '%@' for %@",myUserName,NSLocalizedString(titleKey,nil),@"the table"]];
                    }else{
                        if(![userID isEqualToString:myUserID]){
                            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"%@ bought a '%@' for %@",myUserName,NSLocalizedString(titleKey,nil),[DataManager sharedInstance].giftUserName]];
                        }else{
                            [self postSystemMessageForCurrentGame:[NSString stringWithFormat:@"%@ bought themselves a '%@'",myUserName,NSLocalizedString(titleKey,nil)]];
                        }
                    }
                }
            });
        }
        
    
    
    
}

-(void)giftPurchased:(NSMutableDictionary *)gift{
    self.buyGift = gift;
    
}

-(int)getNumberOfUnPaidActiveGames{
    int numOfGames = 0;
    for (NSMutableDictionary *game in yourTurnGames) {
        BOOL isGamePaidFor = NO;
        for (NSMutableDictionary *inventoryItem in myInventory) {
            if([[inventoryItem valueForKey:@"category"] isEqualToString:@"GAME"]){
                if([[game valueForKey:@"gameID"] isEqualToString:[inventoryItem valueForKey:@"value"]]){
                    isGamePaidFor = YES;
                    
                }
            }
        }
        if(!isGamePaidFor){
            numOfGames++;
        }
        
        
    }
    for (NSMutableDictionary *game in theirTurnGames) {
        BOOL isGamePaidFor = NO;
        for (NSMutableDictionary *inventoryItem in myInventory) {
            if([[inventoryItem valueForKey:@"category"] isEqualToString:@"GAME"]){
                if([[game valueForKey:@"gameID"] isEqualToString:[inventoryItem valueForKey:@"value"]]){
                    isGamePaidFor = YES;
                    
                }
            }
        }
        if(!isGamePaidFor){
            numOfGames++;
        }
        
        
    }
    
    return numOfGames;
    
}

-(BOOL)needsToBuyGame{
    for (NSMutableDictionary *inventoryItem in myInventory) {
        if([[inventoryItem valueForKey:@"category"] isEqualToString:@"GAME"]){
            if([currentGameID isEqualToString:[inventoryItem valueForKey:@"value"]]){
                return NO;
                
            }
        }
    }
    
    if([self getNumberOfUnPaidActiveGames] > 3){
        return YES;
    }
    return NO;
}

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
       bottomPadding = window.safeAreaInsets.bottom;
    }
    return bottomPadding;
}

-(CGFloat)getTopPadding{
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
       UIWindow *window = UIApplication.sharedApplication.keyWindow;
       topPadding = window.safeAreaInsets.top;
    }
    return topPadding;
}



- (BOOL)hasNotchedDisplay{
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        if(topPadding>20) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

-(BOOL)isIphoneXOrPlus{
    return [UIScreen mainScreen].bounds.size.height >=736;
}

-(BOOL)isIphonePlus{
    return [UIScreen mainScreen].bounds.size.height ==736;
}

-(BOOL)isIPhone11Pro{
    return [[UIScreen mainScreen] nativeBounds].size.height==2436;
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
