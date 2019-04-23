//
//  GameStatsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatsViewController.h"
#import "GameStatCell2.h"
#import "DataManager.h"
#import "GameStatCell1.h"
#import "AppDelegate.h"
#import "CellFooterGeneral.h"
#import "GameStatCellHeader.h"
#import "BuyNowCell.h"
#import "StoreFront.h"

@implementation GameStatsViewController

@synthesize _tableView;
@synthesize activePlayers;
@synthesize confirmBuy;
@synthesize buyCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    UIImage *woodFloor = [UIImage imageNamed:@"wood_floor_background.png"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_black.png"]];
    backgroundView.frame = CGRectMake(0, -40, 320, 480);
    backgroundView.image = woodFloor;
    backgroundView.alpha = 0.80;
    [self.view addSubview:backgroundView];
    
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.frame = CGRectMake(0, 0, 320, 420-40);
    _tableView.scrollsToTop = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingIndicator.frame = CGRectMake(150, 170, 20, 20);
	loadingIndicator.hidesWhenStopped = YES;
	[loadingIndicator startAnimating];
	[self.view addSubview:loadingIndicator];

    
    self.activePlayers = [[NSMutableArray alloc] init];
    
    
    
    
}



-(void)loadGameStats{
    _tableView.alpha = 0;
    [loadingIndicator startAnimating];
    NSMutableDictionary *game = [DataManager sharedInstance].currentGame;
    [activePlayers removeAllObjects];
    for (NSMutableDictionary *player in [[game objectForKey:@"turnState"] objectForKey:@"players"]) {
        if([[player valueForKey:@"status"] isEqualToString:@"playing"] || [[player valueForKey:@"status"] isEqualToString:@"buyin"] || [[player valueForKey:@"status"] isEqualToString:@"out"]){
            NSMutableDictionary *playerStats = [[NSMutableDictionary alloc] init];
            [playerStats setValue:[player valueForKey:@"userID"] forKey:@"userID"];
            [playerStats setValue:[player valueForKey:@"userName"] forKey:@"userName"];
            [playerStats setValue:[player valueForKey:@"status"] forKey:@"status"];
            NSMutableDictionary *gameSummary = [[game valueForKey:@"gameState"] valueForKey:@"gameSummary"];
            double playerTotal = 0;
            if([[DataManager sharedInstance] isGameTypeCash:game]){
                playerTotal = [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] - [[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue];
            }else{
                playerTotal = [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];            
            }
            [playerStats setValue:[NSNumber numberWithDouble:[[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue]] forKey:@"userStack"];
            [playerStats setValue:[NSNumber numberWithDouble:playerTotal] forKey:@"net"];
            
            
            
            
            
            for (NSMutableDictionary *hand in [[game valueForKey:@"gameState"] valueForKey:@"hands"]) {
                for (NSMutableDictionary *round in [hand valueForKey:@"rounds"]) {
                    if([[playerStats valueForKey:@"hand"] intValue] == 0 && [[round valueForKey:@"userID"] isEqualToString:[player valueForKey:@"userID"]]){
                        [playerStats setValue:[hand valueForKey:@"number"] forKey:@"hand"];
                    }
                }
            }
            if([[player valueForKey:@"status"] isEqualToString:@"out"]){
                double outSortValue = -999999999+[[playerStats valueForKey:@"hand"] doubleValue];
                [playerStats setValue:[NSNumber numberWithDouble:outSortValue] forKey:@"net"];
            }
            
            [activePlayers addObject:playerStats];
        }
    }
    [[DataManager sharedInstance] loadPlayersAchievements:activePlayers];
    //[_tableView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"multiPlayerAchievements"]){
        [self loadProGameStats];
        [_tableView reloadData];
        [self scrollToTop];
        [loadingIndicator stopAnimating];
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.4];
        _tableView.alpha = 1;
        [UIView commitAnimations];
        
    }else if([keyPath isEqualToString:@"myInventory"]){
        [self loadProGameStats];
        [_tableView reloadData];
        buyCell.isPurchasedBOOL = YES;
        [buyCell updateData:YES];
        
        
    }
    
}


-(void)loadProGameStats{
    NSMutableDictionary *game = [DataManager sharedInstance].currentGame;
    for (NSMutableDictionary *playerStats in activePlayers) {
        //find local game stats
        int handIndex = 0;
        for (NSMutableDictionary *hand in [[game valueForKey:@"gameState"] valueForKey:@"hands"]) {
            if(handIndex > 0){
                int highestHandState = 0;
                NSMutableDictionary *playerHandStates = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *foldedPlayers = [[NSMutableDictionary alloc] init];
                for (NSMutableDictionary *round in [hand valueForKey:@"rounds"]) {
                    if([[round valueForKey:@"handState"] intValue] > highestHandState){
                        highestHandState = [[round valueForKey:@"handState"] intValue];
                    }
                    //NSLog(@"round:%@",round);
                    if([[round valueForKey:@"userID"] isEqualToString:[playerStats valueForKey:@"userID"]]){
                        if([[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] intValue] == 0){
                            [playerStats setValue:[hand valueForKey:@"number"] forKey:@"HANDS_PLAYED_THIS_GAME"];
                        }
                        
                        //vpip
                        double amount = [[round valueForKey:@"amount"] doubleValue];
                        if(amount > [[[game valueForKey:@"gameSettings"] valueForKey:@"bigBlind"] doubleValue] &&  [[round valueForKey:@"handState"] intValue] == 1){
                            [self incrementPlayerStat:playerStats code:@"VPIP_THIS_GAME" value:1.0];
                        }
                        
                        //pfr
                        if(amount > 0 && ([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]) && [[round valueForKey:@"handState"] intValue] == 1){
                            [self incrementPlayerStat:playerStats code:@"PFR_THIS_GAME" value:1.0];
                        }
                        
                        //pfa
                        if([[round valueForKey:@"handState"] intValue] > 1){
                            if([[round valueForKey:@"action"] isEqualToString:@"raise"] || [[round valueForKey:@"action"] isEqualToString:@"bet"] || [[round valueForKey:@"action"] isEqualToString:@"reraise"]){
                                [self incrementPlayerStat:playerStats code:@"POST_FLOP_RAISES_THIS_GAME" value:1.0];
                            }else if([[round valueForKey:@"action"] isEqualToString:@"call"]){
                                [self incrementPlayerStat:playerStats code:@"POST_FLOP_CALLS_THIS_GAME" value:1.0];
                            }
                            
                        }
                        
                        
                        
                        //flops seen & WTSD
                        if([[round valueForKey:@"handState"] intValue] > [[playerHandStates valueForKey:[playerStats valueForKey:@"userID"]] intValue]){
                            [playerHandStates setValue:[round valueForKey:@"handState"] forKey:[playerStats valueForKey:@"userID"]];
                        }
                        if([[round valueForKey:@"userStack"] doubleValue] == 0.00){
                            [playerHandStates setValue:@"5" forKey:[playerStats valueForKey:@"userID"]];
                        }
                        
                        if([[round valueForKey:@"action"] isEqualToString:@"fold"]){
                            [foldedPlayers setValue:@"1" forKey:[playerStats valueForKey:@"userID"]];
                        }
                        
                        
                        
                        
                    }
                }
            
                //NSLog(@"foldedPlayers:%@",foldedPlayers);
                //NSLog(@"playerHandStates:%@",playerHandStates);
                int didFold = [[foldedPlayers valueForKey:[playerStats valueForKey:@"userID"]] intValue];
                if(didFold !=1){
                    [self incrementPlayerStat:playerStats code:@"WTSD_THIS_GAME" value:1.0];
                }else{
                    [self incrementPlayerStat:playerStats code:@"FOLD_THIS_GAME" value:1.0];
                }
                
                int playersHighestHandState = [[playerHandStates valueForKey:[playerStats valueForKey:@"userID"]] intValue];
                
                if(playersHighestHandState >= 2){
                    [self incrementPlayerStat:playerStats code:@"SEE_FLOP_THIS_GAME" value:1.0];
                }
                if(playersHighestHandState >= 3){
                    [self incrementPlayerStat:playerStats code:@"SEE_TURN_THIS_GAME" value:1.0];
                }
                if(playersHighestHandState >= 4){
                    [self incrementPlayerStat:playerStats code:@"SEE_RIVER_THIS_GAME" value:1.0];
                }
                
                NSMutableArray *winners = [hand valueForKey:@"winners"];
                for (NSMutableDictionary *winner in winners) {
                    if([[winner valueForKey:@"userID"] isEqualToString:[playerStats valueForKey:@"userID"]] && [[winner valueForKey:@"amount"] doubleValue] > 0){
                        [self incrementPlayerStat:playerStats code:@"W$SD_THIS_GAME" value:1.0];
                        [self incrementPlayerStat:playerStats code:@"HANDS_WON_THIS_GAME" value:1.0];
                        if([[winner valueForKey:@"type"] isEqualToString:@"USER_FOLD"]){
                            [self incrementPlayerStat:playerStats code:@"WWSD_THIS_GAME" value:1.0];
                        }
                    }
                }
            }
            handIndex++;
            
        }
        
        //hands won------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_WON"] forKey:@"HANDS_WON_ALL_TIME"];
        //NSLog(@"Hands Won for player %@: %@",[playerStats valueForKey:@"userID"],[playerStats valueForKey:@"HANDS_WON_THIS_GAME"]);
        //NSLog(@"Hands Played for player %@: %@",[playerStats valueForKey:@"userID"],[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"]);
        double handsWonThisGamePercentage = ([[playerStats valueForKey:@"HANDS_WON_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:handsWonThisGamePercentage] forKey:@"HANDS_WON_PERCENTAGE_THIS_GAME"];
        
        double handsWonAllTimePercentage = ([[playerStats valueForKey:@"HANDS_WON_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:handsWonAllTimePercentage] forKey:@"HANDS_WON_PERCENTAGE_ALL_TIME"];
        
        //vpip------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"VPIP"] forKey:@"VPIP_ALL_TIME"];
        
        double vpipThisGamePercentage = ([[playerStats valueForKey:@"VPIP_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:vpipThisGamePercentage] forKey:@"VPIP_PERCENTAGE_THIS_GAME"];
        
        double vpipAllTimePercentage = ([[playerStats valueForKey:@"VPIP_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:vpipAllTimePercentage] forKey:@"VPIP_PERCENTAGE_ALL_TIME"];
        
        //pfr------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"PFR"] forKey:@"PFR_ALL_TIME"];
        
        double pfrThisGamePercentage = ([[playerStats valueForKey:@"PFR_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:pfrThisGamePercentage] forKey:@"PFR_PERCENTAGE_THIS_GAME"];
        
        double pfrAllTimePercentage = ([[playerStats valueForKey:@"PFR_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:pfrAllTimePercentage] forKey:@"PFR_PERCENTAGE_ALL_TIME"];
        
        //pfa------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"POST_FLOP_CALLS"] forKey:@"POST_FLOP_CALLS_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"POST_FLOP_RAISES"] forKey:@"POST_FLOP_RAISES_ALL_TIME"];
        
        double pfaThisGamePercentage = ([[playerStats valueForKey:@"POST_FLOP_RAISES_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"POST_FLOP_CALLS_THIS_GAME"] doubleValue]);
        
        if(pfaThisGamePercentage > maxPFA){
            maxPFA = pfaThisGamePercentage;
        }
        
        [playerStats setValue:[NSNumber numberWithDouble:pfaThisGamePercentage] forKey:@"PFA_PERCENTAGE_THIS_GAME"];
        
        double pfaAllTimePercentage = ([[playerStats valueForKey:@"POST_FLOP_RAISES_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"POST_FLOP_CALLS_ALL_TIME"] doubleValue]);
        
        
        if(pfaAllTimePercentage > maxPFA){
            maxPFA = pfaAllTimePercentage;
        }
        
        [playerStats setValue:[NSNumber numberWithDouble:pfaAllTimePercentage] forKey:@"PFA_PERCENTAGE_ALL_TIME"];
        
        
        //wtsd------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"SEE_FLOP"] forKey:@"SEE_FLOP_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"WTSD"] forKey:@"WTSD_ALL_TIME"];
        
        double wtsdAllTimePercentage = ([[playerStats valueForKey:@"WTSD_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"SEE_FLOP_ALL_TIME"] doubleValue]);
        
        
        [playerStats setValue:[NSNumber numberWithDouble:wtsdAllTimePercentage] forKey:@"WTSD_PERCENTAGE_ALL_TIME"];
        
        double wtsdThisGamePercentage = ([[playerStats valueForKey:@"WTSD_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"SEE_FLOP_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:wtsdThisGamePercentage] forKey:@"WTSD_PERCENTAGE_THIS_GAME"];
        
        
        //w$sd------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"W$SD"] forKey:@"W$SD_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"WTSD"] forKey:@"WTSD_ALL_TIME"];
        
        double w$sdAllTimePercentage = ([[playerStats valueForKey:@"W$SD_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"WTSD_ALL_TIME"] doubleValue]);
        
        
        [playerStats setValue:[NSNumber numberWithDouble:w$sdAllTimePercentage] forKey:@"W$SD_PERCENTAGE_ALL_TIME"];
        
        double w$sdThisGamePercentage = ([[playerStats valueForKey:@"W$SD_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"WTSD_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:w$sdThisGamePercentage] forKey:@"W$SD_PERCENTAGE_THIS_GAME"];
        
        //wwsd------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"WWSD"] forKey:@"WWSD_ALL_TIME"];
        
        double wwsdAllTimePercentage = ([[playerStats valueForKey:@"WWSD_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:wwsdAllTimePercentage] forKey:@"WWSD_PERCENTAGE_ALL_TIME"];
        
        double wwsdThisGamePercentage = ([[playerStats valueForKey:@"WWSD_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:wwsdThisGamePercentage] forKey:@"WWSD_PERCENTAGE_THIS_GAME"];
        
        //fold------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"FOLD"] forKey:@"FOLD_ALL_TIME"];
        
        double foldAllTimePercentage = ([[playerStats valueForKey:@"FOLD_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:foldAllTimePercentage] forKey:@"FOLD_PERCENTAGE_ALL_TIME"];
        
        double foldThisGamePercentage = ([[playerStats valueForKey:@"FOLD_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:foldThisGamePercentage] forKey:@"FOLD_PERCENTAGE_THIS_GAME"];
        
        //see flop------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"SEE_FLOP"] forKey:@"SEE_FLOP_ALL_TIME"];
        
        double seeFlopAllTimePercentage = ([[playerStats valueForKey:@"SEE_FLOP_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:seeFlopAllTimePercentage] forKey:@"SEE_FLOP_PERCENTAGE_ALL_TIME"];
        
        double seeFlopThisGamePercentage = ([[playerStats valueForKey:@"SEE_FLOP_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:seeFlopThisGamePercentage] forKey:@"SEE_FLOP_PERCENTAGE_THIS_GAME"];
        
        //see turn------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"SEE_TURN"] forKey:@"SEE_TURN_ALL_TIME"];
        
        double seeTurnAllTimePercentage = ([[playerStats valueForKey:@"SEE_TURN_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:seeTurnAllTimePercentage] forKey:@"SEE_TURN_PERCENTAGE_ALL_TIME"];
        
        double seeTurnThisGamePercentage = ([[playerStats valueForKey:@"SEE_TURN_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:seeTurnThisGamePercentage] forKey:@"SEE_TURN_PERCENTAGE_THIS_GAME"];
        
        //see river------------------------------
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"HANDS_PLAYED"] forKey:@"HANDS_PLAYED_ALL_TIME"];
        [playerStats setValue:[self getCountForPlayer:[playerStats valueForKey:@"userID"] code:@"SEE_RIVER"] forKey:@"SEE_RIVER_ALL_TIME"];
        
        double seeRiverAllTimePercentage = ([[playerStats valueForKey:@"SEE_RIVER_ALL_TIME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_ALL_TIME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:seeRiverAllTimePercentage] forKey:@"SEE_RIVER_PERCENTAGE_ALL_TIME"];
        
        double seeRiverThisGamePercentage = ([[playerStats valueForKey:@"SEE_RIVER_THIS_GAME"] doubleValue] / [[playerStats valueForKey:@"HANDS_PLAYED_THIS_GAME"] doubleValue]);
        
        [playerStats setValue:[NSNumber numberWithDouble:seeRiverThisGamePercentage] forKey:@"SEE_RIVER_PERCENTAGE_THIS_GAME"];

        //NSLog(@"playerStats:%@",playerStats);
    }
}

-(void)incrementPlayerStat:(NSMutableDictionary *)playerStats code:(NSString *)code value:(double)value{
    double statValue = [[playerStats valueForKey:code] doubleValue];
    statValue = statValue + value;
    [playerStats setValue:[NSNumber numberWithDouble:statValue] forKey:code];
}

-(NSNumber *)getCountForPlayer:(NSString *)userID code:(NSString *)code{
    int count = 0;
    NSMutableArray *playerAchievements = [[DataManager sharedInstance].multiPlayerAchievements valueForKey:userID];
    for (NSMutableDictionary *achievement in playerAchievements) {
        if([[achievement valueForKey:@"code"] isEqualToString:code]){
            count = [[achievement valueForKey:@"count"] intValue];
        }
    }
    
    return [NSNumber numberWithInt:count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int i = 0;
    if([[DataManager sharedInstance] hasCurrentUserPurchasedGameStatsForCurrentGame]){
        i = 1;
    }
    if(indexPath.section == 0){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell";
        GameStatCell1 *cell = (GameStatCell1 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell1 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"net" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setCellData:player rank:(indexPath.row+1) isTournament:[[DataManager sharedInstance] isCurrentGameTypeTournament]];
        return cell;
        
    }else if(indexPath.section == 1 && [[DataManager sharedInstance] hasCurrentUserPurchasedGameStatsForCurrentGame]){
        static NSString *MyIdentifier = @"BuyNowCell";
        self.buyCell = (BuyNowCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (buyCell == nil) {
            self.buyCell = [[BuyNowCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        
        NSMutableDictionary *buyNowData = [[NSMutableDictionary alloc] init];
        [buyNowData setValue:@"20" forKey:@"price"];
        [buyNowData setValue:@"Buy now for 20 pro chips and unlock the pro stats for this game below" forKey:@"description"];
        [buyNowData setValue:@"Press the ? to learn more about each pro stat and how to use them in a game" forKey:@"description2"];
        [buyCell setCellData:buyNowData isPurchased:[[DataManager sharedInstance] isGameStatsUnlocked]];
        
        
        
        
        return buyCell;
    }else if(indexPath.section == 1+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"HANDS_WON_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"HANDS_WON" subtext:@"won"];

        
        
        
        return cell;
    }else if(indexPath.section == 2+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"VPIP_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"VPIP" subtext:@""];
        
        
        
        
        return cell;
    }else if(indexPath.section == 3+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"PFR_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"PFR" subtext:@""];
        
        
        
        
        return cell;
    }else if(indexPath.section == 4+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"PFA_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStatWithMaxValue:player statCode:@"PFA" subtext:@"" maxValue:maxPFA];
        

        return cell;
    }else if(indexPath.section == 5+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"WTSD_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"WTSD" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section == 6+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"W$SD_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"W$SD" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section == 7+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"WWSD_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"WWSD" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section == 8+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"FOLD_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"FOLD" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section == 9+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"SEE_FLOP_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"SEE_FLOP" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section == 10+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"SEE_TURN_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"SEE_TURN" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section == 11+i){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"SEE_RIVER_PERCENTAGE_ALL_TIME" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"SEE_RIVER" subtext:@""];
        
        
        return cell;
    }else if(indexPath.section > 1){
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        GameStatCell2 *cell = (GameStatCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[GameStatCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"net" ascending:NO]; // 1
        NSArray * sortedArray = [activePlayers sortedArrayUsingDescriptors:
                                 [NSArray arrayWithObject:descriptor]];
        
        
        NSMutableDictionary *player = [sortedArray objectAtIndex:indexPath.row];
        [cell setPlayerStat:player statCode:@"HANDS_WON" subtext:@""];
        
        
        
        
        return cell;
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 30;
    }
    if(section == 1){
        return 0;
    }
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    int i = 1;
    
    if(section == 0){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 30) title:@"Chip Leaders"];
        UILabel *handLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 106, 40)];
        handLabel.backgroundColor = [UIColor clearColor];
        handLabel.font = [UIFont boldSystemFontOfSize:13];
        handLabel.textAlignment = UITextAlignmentRight;
        handLabel.adjustsFontSizeToFitWidth = YES;
        handLabel.numberOfLines = 2;
        handLabel.textColor = [UIColor darkGrayColor];
        if([[DataManager sharedInstance] isCurrentGameTypeCash]){
            int handNumber = [(NSMutableArray *)[[[DataManager sharedInstance].currentGame objectForKey:@"gameState"] objectForKey:@"hands"] count];
            int numOfHands = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue];
            handLabel.text = [NSString stringWithFormat:@"Hand %d of %d",handNumber,numOfHands];
        }else if([[DataManager sharedInstance] isCurrentGameTypeTournament]){
            int handNumber = [(NSMutableArray *)[[[DataManager sharedInstance].currentGame objectForKey:@"gameState"] objectForKey:@"hands"] count];
            handLabel.text = [NSString stringWithFormat:@"Hand %d",handNumber];
        }
        [header addSubview:handLabel];
        return header;
        
    }else if(section == 1 +i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"HANDS_WON"];
        [header setHeaderCode:@"HANDS_WON"];
        return header;
        
    }else if(section == 2+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"VPIP"];
        [header setHeaderCode:@"VPIP"];
        return header;
        
    }else if(section == 3+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"PFR"];
        [header setHeaderCode:@"PFR"];
        return header;
    }else if(section == 4+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"PFA"];
        [header setHeaderCode:@"PFA"];
        return header;
    }else if(section == 5+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"WTSD"];
        [header setHeaderCode:@"WTSD"];
        return header;
    }else if(section == 6+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"W$SD"];
        [header setHeaderCode:@"W$SD"];
        return header;
    }else if(section == 7+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"WWSD"];
        [header setHeaderCode:@"WWSD"];
        return header;
        
    }else if(section == 8+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"Fold %"];
        [header setHeaderCode:@"FOLD"];
        return header;
        
    }else if(section == 9+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"See Flop %"];
        [header setHeaderCode:@"SEE_FLOP"];
        return header;
        
    }else if(section == 10+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"See Turn %"];
        [header setHeaderCode:@"SEE_TURN"];
        return header;
        
    }else if(section == 11+i){
        GameStatCellHeader *header = [[GameStatCellHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 50) title:@"See River %"];
        [header setHeaderCode:@"SEE_RIVER"];
        return header;
    }
    
    
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        return nil;
    }
    
    CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, 320, 40) title:@""];
    if(section == 0){
        
        UIImage *greenChip = [UIImage imageNamed:@"green_chip.png"];
        UIImageView *greenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 2, 18, 18)];
        greenImageView.image = greenChip;
        [footer addSubview:greenImageView];
        
        UILabel *greenChipLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 13)];
        greenChipLabel.backgroundColor = [UIColor clearColor];
        greenChipLabel.textColor = [UIColor darkGrayColor];
        greenChipLabel.textAlignment = UITextAlignmentLeft;
        greenChipLabel.adjustsFontSizeToFitWidth = YES;
        greenChipLabel.minimumFontSize = 10;
        greenChipLabel.text = @"Big Stack";
        greenChipLabel.font = [UIFont boldSystemFontOfSize:11];
        [footer addSubview:greenChipLabel];
        
        UIImage *yellowChip = [UIImage imageNamed:@"yellow_chip.png"];
        UIImageView *yellowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 2, 18, 18)];
        yellowImageView.image = yellowChip;
        [footer addSubview:yellowImageView];
        
        UILabel *yellowChipLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 5, 100, 13)];
        yellowChipLabel.backgroundColor = [UIColor clearColor];
        yellowChipLabel.textColor = [UIColor darkGrayColor];
        yellowChipLabel.textAlignment = UITextAlignmentLeft;
        yellowChipLabel.adjustsFontSizeToFitWidth = YES;
        yellowChipLabel.minimumFontSize = 10;
        yellowChipLabel.text = @"Mid Stack";
        yellowChipLabel.font = [UIFont boldSystemFontOfSize:11];
        [footer addSubview:yellowChipLabel];
        
        UIImage *redChip = [UIImage imageNamed:@"red_chip.png"];
        UIImageView *redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 2, 18, 18)];
        redImageView.image = redChip;
        [footer addSubview:redImageView];
        
        
        UILabel *redChipLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 5, 100, 13)];
        redChipLabel.backgroundColor = [UIColor clearColor];
        redChipLabel.textColor = [UIColor darkGrayColor];
        redChipLabel.textAlignment = UITextAlignmentLeft;
        redChipLabel.adjustsFontSizeToFitWidth = YES;
        redChipLabel.minimumFontSize = 10;
        redChipLabel.text = @"Low Stack";
        redChipLabel.font = [UIFont boldSystemFontOfSize:11];
        [footer addSubview:redChipLabel];
        
    }else if(section > 1){
        UIImage *blueBar = [UIImage imageNamed:@"bar_graph.png"];
        UIImageView *blueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, 4, 120, 12)];
        blueImageView.image = blueBar;
        [footer addSubview:blueImageView];
        
        UILabel *blueBarLabel = [[UILabel alloc] initWithFrame:blueImageView.bounds];
        blueBarLabel.backgroundColor = [UIColor clearColor];
        blueBarLabel.textColor = [UIColor whiteColor];
        blueBarLabel.textAlignment = UITextAlignmentCenter;
        blueBarLabel.adjustsFontSizeToFitWidth = YES;
        blueBarLabel.minimumFontSize = 10;
        blueBarLabel.text = @"All-time";
        blueBarLabel.font = [UIFont boldSystemFontOfSize:11];
        [blueImageView addSubview:blueBarLabel];
        
        UIImage *purpleBar = [UIImage imageNamed:@"bar_graph2.png"];
        UIImageView *purpleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 4, 120, 12)];
        purpleImageView.image = purpleBar;
        [footer addSubview:purpleImageView];
        
        UILabel *purpleBarLabel = [[UILabel alloc] initWithFrame:purpleImageView.bounds];
        purpleBarLabel.backgroundColor = [UIColor clearColor];
        purpleBarLabel.textColor = [UIColor whiteColor];
        purpleBarLabel.textAlignment = UITextAlignmentCenter;
        purpleBarLabel.adjustsFontSizeToFitWidth = YES;
        purpleBarLabel.minimumFontSize = 10;
        purpleBarLabel.text = @"This Game";
        purpleBarLabel.font = [UIFont boldSystemFontOfSize:11];
        [purpleImageView addSubview:purpleBarLabel];

        
    }
    return footer;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 0;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 25;
    }else if(indexPath.section == 1){
        return 130;
    }
    return 68;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 1){
        return 1;
    }
    
    return [activePlayers count];
    /*
    if(section == 0){
        return [activePlayers count];
    }else if(section == 1){
        return 12;
    }
    return 0;*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 13;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *userID;
    if(!confirmBuy){
        self.confirmBuy = [[UIAlertView alloc] initWithTitle:@"Unlock Game Stats?" message:@"Would you like to unlock this games stats for 20 pro chips?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    }
    if(indexPath.section == 0){
        GameStatCell1 *cell = (GameStatCell1 *)[tableView cellForRowAtIndexPath:indexPath];
        userID = cell.userID;
    }else if(indexPath.section == 1){
        
        if(![[DataManager sharedInstance] isGameStatsUnlocked]){
            [confirmBuy show];
        }

        return nil;
    }else if(indexPath.section > 1){
        GameStatCell2 *cell = (GameStatCell2 *)[tableView cellForRowAtIndexPath:indexPath];
        userID = cell.userID;
    }
    
    
    
    
    if(![[DataManager sharedInstance] isGameStatsUnlocked]){
        [confirmBuy show];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pushToPlayersProfile:userID];
    }

    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == confirmBuy){
        if(buttonIndex == 1){
            if([[StoreFront sharedStore] decrementUserCurrency:20]){
                [[DataManager sharedInstance] addInventory:@"GAME_STATS" value:[DataManager sharedInstance].currentGameID];
            }
        }
    }
    
}



-(void)scrollToTop{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if ( [_tableView numberOfSections] > 0 &&  [_tableView numberOfRowsInSection:0] > 0 ){
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
