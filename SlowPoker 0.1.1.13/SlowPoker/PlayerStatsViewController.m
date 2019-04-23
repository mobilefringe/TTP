//
//  PlayerStatsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerStatsViewController.h"
#import "PlayerStatTableViewCell1.h"
#import "DataManager.h"
#import "PlayerStatTableViewCell2.h"
#import "CellHeaderGeneral.h"
#import "CellFooterGeneral.h"
#import "BuyNowCell.h"
#import "StoreFront.h"

@interface PlayerStatsViewController ()

@end

@implementation PlayerStatsViewController

@synthesize _tableView;
@synthesize footerView;
@synthesize lockStatsButton;
@synthesize buyCell;
@synthesize confirmBuy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Stats";
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_bg2_ip5.png"]];
    background.frame = CGRectMake(0, -50, 320, [UIImage imageNamed:@"general_bg2_ip5.png"].size.height/2);
    [self.view addSubview:background];
    
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    [_tableView setBackgroundView:nil];
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        _tableView.frame = CGRectMake(0, 0, 320, 505);
    }
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    self.footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 15)];
    footerView.textAlignment = UITextAlignmentCenter;
    footerView.textColor = [UIColor darkGrayColor];
    footerView.font = [UIFont systemFontOfSize:12];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.text = @"Press each for description";
    
    self.lockStatsButton = [[UIBarButtonItem alloc] initWithTitle:@"Unlock"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(unlockPlayerStats)];

}

-(void)unlockPlayerStats{
    
    
    
    if(isStatsLocked){
        NSMutableDictionary *playerStats = [[DataManager sharedInstance] getGameAchievementForCode:@"PLAYER_STATS" category:@"INVENTORY"];
        
        UIAlertView *unlockAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy",nil];
        
        unlockAlert.title = [NSString stringWithFormat:@"Unlock %@'s Pro Stats?",[[DataManager sharedInstance].playerProfile valueForKey:@"userName"]];
        
        unlockAlert.message = [NSString stringWithFormat:@"Would you like to unlock %@'s Pro Stats for %@ Pro Chips? Once unlocked you can access these stats at anytime",[[DataManager sharedInstance].playerProfile valueForKey:@"userName"],[playerStats valueForKey:@"purchaseValue"]];
        [unlockAlert show];
        
        
        
    }else{
        UIAlertView *unlockAlert = [[UIAlertView alloc] initWithTitle:@"Already Unlocked" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        unlockAlert.message = [NSString stringWithFormat:@"You have already unlocked %@'s Pro Stats.",[[DataManager sharedInstance].playerProfile valueForKey:@"userName"]];
        [unlockAlert show];
    }
    

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"myInventory"]){
        [self viewWillAppear:YES];
        
    }
    
}



-(void)viewWillAppear:(BOOL)animated{
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"myInventory" options:NSKeyValueObservingOptionOld context:nil];
    [FlurryAnalytics logEvent:@"PAGE_VIEW_PLAYER_STATS" timed:YES];
    isStatsLocked = [[DataManager sharedInstance] isCurrentPlayerProfileStatsLocked];
    //NSLog(@"playerProfile:%@",[DataManager sharedInstance].playerProfile);
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    
    if(isStatsLocked){
        self.navigationItem.rightBarButtonItem = lockStatsButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[DataManager sharedInstance] removeObserver:self forKeyPath:@"myInventory" context:nil];
    [FlurryAnalytics endTimedEvent:@"PAGE_VIEW_PLAYER_STATS" withParameters:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 2){
        // Try to retrieve from the table view a now-unused cell with the given identifier
        static NSString *MyIdentifier = @"PlayerStatTableViewCell1";
        PlayerStatTableViewCell1 *cell = (PlayerStatTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[PlayerStatTableViewCell1 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        [cell setPlayerStat:nil percentage:0];

        cell.isLocked = isStatsLocked;
        if(indexPath.row == 0){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double handsWon = [self statDouble:@"HANDS_WON"];
            [cell setPlayerStat:@"HANDS_PLAYED" percentage:handsWon/handsPlayed subtext:@"won"];
        }else if(indexPath.row == 1){
            double gamesPlayed = [self statDouble:@"GAMES_PLAYED"];
            double gamessWon = [self statDouble:@"GAMES_WON"];
            [cell setPlayerStat:@"GAMES_PLAYED" percentage:gamessWon/gamesPlayed subtext:@"won"];
        }else if(indexPath.row == 2){
            double cashGamesPlayed = [self statDouble:@"CASH_GAMES_PLAYED"];
            double cashGamesWon = [self statDouble:@"CASH_GAMES_WON"];
            [cell setPlayerStat:@"CASH_GAMES_PLAYED" percentage:cashGamesWon/cashGamesPlayed subtext:@"won"];
        }else if(indexPath.row == 3){
            double tournamentGamesPlayed = [self statDouble:@"TOURNAMENT_GAMES_PLAYED"];
            double tournamentGamesWon = [self statDouble:@"TOURNAMENT_GAMES_WON"];
            [cell setPlayerStat:@"TOURNAMENT_GAMES_PLAYED" percentage:tournamentGamesWon/tournamentGamesPlayed subtext:@"won"];
        }else if(indexPath.row == 0+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double vpip = [self statDouble:@"VPIP"];
            [cell setPlayerStat:@"VPIP" percentage:vpip/handsPlayed];
        }else if(indexPath.row == 1+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double pfr = [self statDouble:@"PFR"];
            [cell setPlayerStat:@"PFR" percentage:pfr/handsPlayed];
        }else if(indexPath.row == 2+4){
            double pfc = [self statDouble:@"POST_FLOP_CALLS"];
            double pfr = [self statDouble:@"POST_FLOP_RAISES"];
            [cell setPlayerStatValue:@"PFA" value:pfr/pfc subtext:@""];
        }else if(indexPath.row == 3+4){
            double flopsSeen = [self statDouble:@"SEE_FLOP"];
            double wtsd = [self statDouble:@"WTSD"];
            [cell setPlayerStat:@"WTSD" percentage:wtsd/flopsSeen];
        }else if(indexPath.row == 4+4){
            double wtsd = [self statDouble:@"WTSD"];
            double w$sd = [self statDouble:@"W$SD"];
            [cell setPlayerStat:@"W$SD" percentage:w$sd/wtsd];
        }else if(indexPath.row == 5+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double wwsd = [self statDouble:@"WWSD"];
            [cell setPlayerStat:@"WWSD" percentage:wwsd/handsPlayed];
        }else if(indexPath.row == 6+4){
            double blindStealOpportunity = [self statDouble:@"BLIND_STEAL_OPPORTUNITY"];
            double blindSteal = [self statDouble:@"BLIND_STEAL"];
            [cell setPlayerStat:@"BLIND_STEAL" percentage:blindSteal/blindStealOpportunity];
        }else if(indexPath.row == 7+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double fold = [self statDouble:@"FOLD"];
            [cell setPlayerStat:@"FOLD" percentage:fold/handsPlayed];
        }else if(indexPath.row == 8+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double seeFlop = [self statDouble:@"SEE_FLOP"];
            [cell setPlayerStat:@"SEE_FLOP" percentage:seeFlop/handsPlayed];
        }else if(indexPath.row == 9+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double seeTurn = [self statDouble:@"SEE_TURN"];
            [cell setPlayerStat:@"SEE_TURN" percentage:seeTurn/handsPlayed];
        }else if(indexPath.row == 10+4){
            double handsPlayed = [self statDouble:@"HANDS_PLAYED"];
            double seeRiver = [self statDouble:@"SEE_RIVER"];
            [cell setPlayerStat:@"SEE_RIVER" percentage:seeRiver/handsPlayed];
        }else if(indexPath.row == 11+4){
            double allIns = [self statDouble:@"ALL_IN"];
            double allInWins = [self statDouble:@"ALL_IN_WIN"];
            [cell setPlayerStat:@"ALL_IN" percentage:allInWins/allIns subtext:@"won"];
        }

        return cell;
    }else if(indexPath.section == 1){
        
        // Try to retrieve from the table view a now-unused cell with the given identifier
        static NSString *MyIdentifier = @"PlayerStatTableViewCell2";
        PlayerStatTableViewCell2 *cell = (PlayerStatTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (cell == nil) {
            cell = [[PlayerStatTableViewCell2 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        cell.isLocked = isStatsLocked;
        if(indexPath.row == 0){
            [cell setData:@"EARNINGS_ALL_GAMES" winAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_WON"] loseAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_LOST"] betAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_BET"]];
        }else if(indexPath.row == 1){
            [cell setData:@"EARNINGS_CASH_GAMES" winAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_WON_CASH_GAME"] loseAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_LOST_CASH_GAME"] betAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_BET_CASH_GAME"]];
        }else if(indexPath.row == 2){
            [cell setData:@"EARNINGS_TOURNAMENT_GAMES" winAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_WON_TOURNAMENT_GAME"] loseAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_LOST_TOURNAMENT_GAME"] betAmount:[[DataManager sharedInstance] getValueForUserAchievement:@"MONEY_BET_TOURNAMENT_GAME"]];
        }
        
        
        
        
        return cell;
        
    }else if(indexPath.section == 0){
        static NSString *MyIdentifier = @"MyIdentifier";
        self.buyCell = (BuyNowCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        // If no cell is available, create a new one using the given identifier
        if (buyCell == nil) {
            self.buyCell = [[BuyNowCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }
        
        
        NSMutableDictionary *buyNowData = [[NSMutableDictionary alloc] init];
        [buyNowData setValue:@"5" forKey:@"price"];
        [buyNowData setValue:@"Buy now for 5 pro chips and unlock this players pro stats" forKey:@"description"];
        [buyNowData setValue:@"Press each item to learn how to use each pro stat against your opponent" forKey:@"description2"];
        [buyCell setCellData:buyNowData isPurchased:![[DataManager sharedInstance] isCurrentPlayerProfileStatsLocked]];
        return  buyCell;
    }
   

    
    return nil;
}

-(double)statDouble:(NSString *)statCode{
    return [[DataManager sharedInstance] getCountForUserAchievement:statCode category:@"PROFILE"] * 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 130;
    }
    if(indexPath.section == 1){
        return 73;
    }else if(indexPath.section == 2){
        return 70;
    }
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 35) title:@"Win/Loss"];
        return header;
    }else if(section == 2){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 35) title:@"Pro Stats"];
        return header;
    }
    return nil;
    
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Base Stats";
    }else if(section == 1){
        return @"Pro Stats";
    }else if(section == 2){
        return @"Win/Loss";
    }
    return nil;
    
}*/

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 40) title:@""];
        return footer;
    }else if(section == 2){
        CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, 320, 40) title:@"Press each for description"];
        return footer;
    }
    return nil;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 40;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 3;
    }else if(section == 2){
        return 12 + 4;
    }else if(section == 0){
        return 1;
    }
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        if(!confirmBuy){
            self.confirmBuy = [[UIAlertView alloc] initWithTitle:@"Unlock Player Stats?" message:@"Would you like to unlock this players stats for 5 pro chips?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        }
        if([[DataManager sharedInstance] isCurrentPlayerProfileStatsLocked]){
            [confirmBuy show];
        }
        
        return nil;
    }
    if(indexPath.section ==2){
        PlayerStatTableViewCell1 *cell = (PlayerStatTableViewCell1 *)[tableView cellForRowAtIndexPath:indexPath];
        [DataManager sharedInstance].showStatCode = cell.statCodeTmp;
    }
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == confirmBuy){
        if(buttonIndex == 1){
            if([[StoreFront sharedStore] decrementUserCurrency:5]){
                [[DataManager sharedInstance] addInventory:@"PLAYER_STATS" value:[[DataManager sharedInstance].playerProfile valueForKey:@"userID"]];
            }
        }
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
