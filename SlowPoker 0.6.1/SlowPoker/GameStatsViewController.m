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

@implementation GameStatsViewController

@synthesize _tableView;
@synthesize activePlayers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"multiPlayerAchievements" options:NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.frame = CGRectMake(0, 0, 320, 416-40);
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    self.activePlayers = [[NSMutableArray alloc] init];
}


-(void)loadGameStats{
    _tableView.alpha = 0;
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
        
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.4];
        _tableView.alpha = 1;
        [UIView commitAnimations];
        
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
                        if(amount > 0 && [[round valueForKey:@"action"] isEqualToString:@"raise"] && [[round valueForKey:@"handState"] intValue] == 1){
                            [self incrementPlayerStat:playerStats code:@"PFR_THIS_GAME" value:1.0];
                        }
                        
                        //pfa
                        if([[round valueForKey:@"handState"] intValue] > 1){
                            if([[round valueForKey:@"action"] isEqualToString:@"raise"]){
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
            
                NSLog(@"foldedPlayers:%@",foldedPlayers);
                NSLog(@"playerHandStates:%@",playerHandStates);
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
                    if([[winner valueForKey:@"userID"] isEqualToString:[playerStats valueForKey:@"userID"]]){
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

        
        
        
        
        
    
        NSLog(@"playerStats:%@",playerStats);
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
        
    }else if(indexPath.section == 1){
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
    }else if(indexPath.section == 2){
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
    }else if(indexPath.section == 3){
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
    }else if(indexPath.section == 4){
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
    }else if(indexPath.section == 5){
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
    }else if(indexPath.section == 6){
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
    }else if(indexPath.section == 7){
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
    }else if(indexPath.section == 8){
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
    }else if(indexPath.section == 9){
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
    }else if(indexPath.section == 10){
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
    }else if(indexPath.section == 11){
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Chip Leaders";
    }else if(section == 1){
        return @"Hands Won";
    }else if(section == 2){
        return @"VPIP";
    }else if(section == 3){
        return @"PFR";
    }else if(section == 4){
        return @"PFA";
    }else if(section == 5){
        return @"WTSD";
    }else if(section == 6){
        return @"W$SD";
    }else if(section == 7){
        return @"WWSD";
    }else if(section == 8){
        return @"Fold %";
    }else if(section == 9){
        return @"See Flop %";
    }else if(section == 10){
        return @"See Turn %";
    }else if(section == 11){
        return @"See River %";
    }
    return @"";
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 25;
    }else if(indexPath.section == 1){
        return 68;
    }
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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
    return 12;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *userID;
    if(indexPath.section == 0){
        GameStatCell1 *cell = (GameStatCell1 *)[tableView cellForRowAtIndexPath:indexPath];
        userID = cell.userID;
    }else if(indexPath.section > 0){
        GameStatCell2 *cell = (GameStatCell2 *)[tableView cellForRowAtIndexPath:indexPath];
        userID = cell.userID;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate pushToPlayersProfile:userID];

    return nil;
}

-(void)scrollToTop{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
