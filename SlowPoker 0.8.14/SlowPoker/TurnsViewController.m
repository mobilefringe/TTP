//
//  TurnsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TurnsViewController.h"
#import "DataManager.h"
#import "TurnTableViewCell.h"
#import "TurnSectionHeader.h"
#import "BetViewController.h"
#import "MessageBubblesViewController.h"
#import "AppDelegate.h"
#import "ChatButton.h"
#import "Button.h"
#import "NudgeButton.h"
#import "PokerTableView.h"
#import "HandSummaryPopUp.h"
#import "GameStatsViewController.h"
#import "BetTableViewButton.h"
#import "GameStatsButton.h"
#import "BuyGamePopUp.h"
#import "SVPullToRefresh.h"

@implementation TurnsViewController
@synthesize _tableView;
@synthesize activityIndicatorView;
@synthesize updatingMessage;
@synthesize betOptions;
@synthesize sectionHeader;
@synthesize betViewController;
@synthesize buyInAlert;
@synthesize buyInAmountLabel;
@synthesize buyIn;
@synthesize buyInRange;
@synthesize leaveGameAlert;
@synthesize cashGameStartAlert;
@synthesize notEnoughPlayersAlert;
@synthesize refreshTimer;
@synthesize winnerLoserAlert;
@synthesize gameOverAlert;
@synthesize recurranceIndex;
@synthesize chatField;
@synthesize chatFieldBackground;
@synthesize messageBubblesViewController;
@synthesize chatButton;
@synthesize closeChatButton;
@synthesize bugButton;
@synthesize waitNextHandAlert;
@synthesize winnerLoserAlertWithBuyin;
@synthesize nudgeAlert;
@synthesize joinTournamentAlert;
@synthesize waitingForGameOwner;
@synthesize listTableButton;
@synthesize pokerTableView;
@synthesize background;
@synthesize flipView;
@synthesize navHeader;
@synthesize navLabel1;
@synthesize navLabel2;
@synthesize viewOrNudge;
@synthesize pressedPlayer;
@synthesize handSummaryPopUp;
@synthesize gameStatsViewController;
@synthesize betOrTableViewButton;
@synthesize gameStatsButton;
@synthesize woodBackground;
@synthesize gameOverAlertWithRematch;
@synthesize buyGameAlert;
@synthesize userWantsToDelete;
@synthesize noOneLeftAlert;
@synthesize cantDeleletGame;

static int refreshSeconds = 60;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"gameDetailsUpdates" options:NSKeyValueObservingOptionOld context:nil];
        
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"newMessagesCount" options:NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.title = @"Game";
    self.view.backgroundColor = [UIColor whiteColor];
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_black.png"]];
    background.frame = CGRectMake(0, -40, 320, 480);
    [self.view addSubview:background];
    /*
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"felt_full.png"]];
    backgroundImage.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:backgroundImage];*/
    
    
    
    self.flipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 440)];
    flipView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:flipView];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 72;
    _tableView.scrollsToTop = YES;
    _tableView.frame = CGRectMake(0, 0, 320, 416-40);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor blackColor];
    [_tableView addPullToRefreshWithActionHandler:^{
        [self loadGame];
        // call [tableView.pullToRefreshView stopAnimating] when done
    }];
    _tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    _tableView.pullToRefreshView.textColor = [UIColor whiteColor];
    _tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingIndicator.frame = CGRectMake(150, 170, 20, 20);
	loadingIndicator.hidesWhenStopped = YES;
	[loadingIndicator startAnimating];
	[self.view addSubview:loadingIndicator];
    
    UIImage *woodFloor = [UIImage imageNamed:@"wood_floor_background.png"];
    self.woodBackground = [[UIImageView alloc] initWithImage:woodFloor];
    woodBackground.userInteractionEnabled = YES;
    woodBackground.frame = CGRectMake(0, 0, woodFloor.size.width/2, woodFloor.size.height/2);
    [woodBackground addSubview:_tableView];
    [flipView addSubview:woodBackground];
    
    self.updatingMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
    updatingMessage.text = @"No betting data yet";
    updatingMessage.backgroundColor = [UIColor clearColor];
    updatingMessage.textColor = [UIColor whiteColor];
    updatingMessage.font = [UIFont boldSystemFontOfSize:20];
    updatingMessage.textAlignment = UITextAlignmentCenter;
    [woodBackground addSubview:updatingMessage];

    
    self.pokerTableView = [[PokerTableView alloc] initWithFrame:CGRectMake(0, -45, 320, 416)];
    pokerTableView.handSummaryDelegate = self;
    pokerTableView.delegate = self;
    
    self.gameStatsViewController = [[GameStatsViewController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:gameStatsViewController.view];
    [self resetGameStats];
    
    
    
    self.messageBubblesViewController = [[MessageBubblesViewController alloc] initWithNibName:nil bundle:nil];
    messageBubblesViewController.view.frame = CGRectMake(0, 416-40, 320, 416-40);
    [self.view addSubview:messageBubblesViewController.view];
    
    
    self.chatFieldBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416-40, 320, 40)];
    chatFieldBackground.userInteractionEnabled = YES;
    chatFieldBackground.image = [UIImage imageNamed:@"tool_bar_background.png"];
    [self.view addSubview:chatFieldBackground];
    
    self.betOrTableViewButton = [[BetTableViewButton alloc] initWithFrame:CGRectMake(3, 5, 130,30)];
    [betOrTableViewButton.button addTarget:self action:@selector(flipTable) forControlEvents:UIControlEventTouchUpInside];
    [chatFieldBackground addSubview:betOrTableViewButton];
    
    self.gameStatsButton = [[GameStatsButton alloc] initWithFrame:CGRectMake(138, 5, 130,30)];
    [gameStatsButton.button addTarget:self action:@selector(pressGameStats) forControlEvents:UIControlEventTouchUpInside];
    [chatFieldBackground addSubview:gameStatsButton];
    
    self.chatField = [[UITextField alloc] initWithFrame:CGRectMake(268, 3, 0,32)];
    chatField.delegate = self;
    chatField.borderStyle = UITextBorderStyleRoundedRect;
    chatField.clearButtonMode = UITextFieldViewModeWhileEditing;
    chatField.returnKeyType = UIReturnKeyDone;
    chatField.placeholder = @"Game Chat";
    [chatFieldBackground addSubview:chatField];
    
    self.chatButton = [[ChatButton alloc] initWithFrame:CGRectMake(273, 5, 42, 30)];
    //[chatButton setTitle:@"Send" forState:UIControlStateNormal];
    [chatButton.button addTarget:self action:@selector(pressChat) forControlEvents:UIControlEventTouchUpInside];
    [chatFieldBackground addSubview:chatButton];
    
    
    
    
    betOptions = [[UIActionSheet alloc] initWithTitle:[[DataManager sharedInstance] getLastUpdatedGamesMessage] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Fold" otherButtonTitles:@"Check",@"Raise 10",@"Raise 20",@"Raise 30", nil];
    
    self.buyInAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"                                                          " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy In & Join",@"Leave Game", nil];
    
    self.leaveGameAlert = [[UIAlertView alloc] initWithTitle:@"Leave Game?" message:@"Are you sure you want to leave this game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    self.cashGameStartAlert = [[UIAlertView alloc] initWithTitle:@"Start Game?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start game", nil];
    
    self.waitNextHandAlert = [[UIAlertView alloc] initWithTitle:@"Please Wait" message:@"You will be incuded in the game when this current hand is over" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Change Buyin",@"OK", nil];
    
    
    
    self.buyInRange = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 250, 23)];
    buyInRange.textColor = [UIColor whiteColor];
    buyInRange.font = [UIFont systemFontOfSize:17];
    buyInRange.tag = 2;
    buyInRange.adjustsFontSizeToFitWidth = YES;
    buyInRange.minimumFontSize = 10;
    buyInRange.backgroundColor = [UIColor clearColor];
    buyInRange.textAlignment = UITextAlignmentCenter;
    [buyInAlert addSubview:buyInRange];
    
    
    self.buyInAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 73, 100, 50)];
    buyInAmountLabel.textColor = [UIColor whiteColor];
    buyInAmountLabel.font = [UIFont boldSystemFontOfSize:22];
    buyInAmountLabel.tag = 3;
    buyInAmountLabel.adjustsFontSizeToFitWidth = YES;
    buyInAmountLabel.minimumFontSize = 10;
    buyInAmountLabel.backgroundColor = [UIColor clearColor];
    buyInAmountLabel.textAlignment = UITextAlignmentCenter;
    [buyInAlert addSubview:buyInAmountLabel];
    
    
    
    UIButton *decreaseBuyIn;
    decreaseBuyIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    decreaseBuyIn.frame = CGRectMake(15, 73, 70, 47);
    [decreaseBuyIn setTitle:@"-" forState:UIControlStateNormal];
    decreaseBuyIn.tag = 1;
    [decreaseBuyIn addTarget:self action:@selector(decreaseBuyIn) forControlEvents:UIControlEventTouchUpInside];
    decreaseBuyIn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [buyInAlert addSubview:decreaseBuyIn];
    
    
    UIButton *increaseBuyIn;
    increaseBuyIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    increaseBuyIn.frame = CGRectMake(195, 73, 70, 47);
    [increaseBuyIn setTitle:@"+" forState:UIControlStateNormal];
    increaseBuyIn.tag = 4;
    [increaseBuyIn addTarget:self action:@selector(increaseBuyIn) forControlEvents:UIControlEventTouchUpInside];
    increaseBuyIn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [buyInAlert addSubview:increaseBuyIn];
    
    closeChatButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(hideChat)];
    
    bugButton = [[UIBarButtonItem alloc] initWithTitle:@"Report Bug"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(reportBug)];
    
    
    betViewButton = [[UIBarButtonItem alloc] initWithTitle:@"Bet View"
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(flipTable)];
    
    tableViewButton = [[UIBarButtonItem alloc] initWithTitle:@"Table View"
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(flipTable)];
    
    //self.navigationItem.rightBarButtonItem = bugButton;
    
    self.navHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    navHeader.backgroundColor = [UIColor clearColor];
   // self.navigationItem.titleView = navHeader;
    
    self.navLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 23)];
    [navHeader addSubview:navLabel1];
    navLabel1.textColor = [UIColor whiteColor];
    navLabel1.adjustsFontSizeToFitWidth = YES;
    navLabel1.minimumFontSize = 12;
    navLabel1.backgroundColor = [UIColor clearColor];
    navLabel1.textAlignment = UITextAlignmentCenter;
    navLabel1.font = [UIFont boldSystemFontOfSize:18];
    
    self.navLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 130, 17)];
    [navHeader addSubview:navLabel2];
    navLabel2.textColor = [UIColor whiteColor];
    navLabel2.adjustsFontSizeToFitWidth = YES;
    navLabel2.minimumFontSize = 12;
    navLabel2.backgroundColor = [UIColor clearColor];
    navLabel2.textAlignment = UITextAlignmentCenter;
    navLabel2.font = [UIFont boldSystemFontOfSize:15];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake(300, 7, 10, 10);
    //[self.view addSubview:activityIndicatorView];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [flipView addSubview:activityIndicatorView];
    
    self.handSummaryPopUp = [[HandSummaryPopUp alloc] initWithFrame:CGRectMake(5, 5, 310, 350) delegate:self];
    [self.view addSubview:handSummaryPopUp];
    
    
    self.buyGameAlert = [[UIAlertView alloc] initWithTitle:@"Activate Game?" message:@"You already have 3 active free games. Would you like to activate this game for 20 Pro Chips?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, activate game",@"No, leave game", nil];
    
    self.noOneLeftAlert = [[UIAlertView alloc] initWithTitle:@"No Players" message:@"No one is left in the game, would you like to leave this game as well?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Leave game", nil];
    
    self.cantDeleletGame = [[UIAlertView alloc] initWithTitle:@"Cannot Leave Game" message:@"You are the game owner. The game owner cannot leave the game." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGame) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];
    /*
    if(refreshTimer){
        [refreshTimer invalidate];
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshSeconds target:self selector:@selector(loadGame) userInfo:nil repeats:YES];
    [refreshTimer fire];*/
    [self loadGame];
}


-(void)viewWillAppear:(BOOL)animated{
    updatingMessage.hidden = YES;
    [FlurryAnalytics logEvent:@"PAGE_VIEW_IN_GAME" timed:YES];
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buyGamePopUp.delegate = self;
    
    [[DataManager sharedInstance] setProfileToMe];
    [handSummaryPopUp hide];
    showGameOver = YES;
    showhandOver = YES;
    isGameComplete = NO;
    showAlerts = YES;
    chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
    chatField.frame = CGRectMake(268, 3, 0,32);
    messageBubblesViewController.view.frame = CGRectMake(0, 416-40, 320, 416-40);
    [gameStatsButton unselectButton:YES];    
    _tableView.alpha = 0;
    [loadingIndicator startAnimating];
    [pokerTableView clearGame];
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isTableView"] isEqualToString:@"YES"]){
        [woodBackground removeFromSuperview];
        [flipView  addSubview:pokerTableView];
        [betOrTableViewButton setAsBetView:NO];
        //self.navigationItem.rightBarButtonItem = betViewButton;
        navLabel1.text = @"Table View";
    }else {
        [pokerTableView removeFromSuperview];
        [flipView  addSubview:woodBackground];
        [betOrTableViewButton setAsTableView:NO];
        navLabel1.text = @"Bet View";
        //self.navigationItem.rightBarButtonItem = tableViewButton;
    }
    
    
    
    
}

-(void)resetGameStats{
    gameStatsViewController.view.frame = CGRectMake(0, 416, 320, 416);
}

-(void)loadGame{
    if(!isGameComplete){
        [sectionHeader.activityIndicatorView startAnimating];
        [[DataManager sharedInstance] loadGameDetails:[DataManager sharedInstance].currentGameID];
        [[DataManager sharedInstance] loadNewMessages];
        [activityIndicatorView startAnimating];
    }else{
        [_tableView.pullToRefreshView stopAnimating];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"gameDetailsUpdates"]){
        [_tableView.pullToRefreshView stopAnimating];
        [sectionHeader.activityIndicatorView stopAnimating];
        //updatingMessage.text = [[DataManager sharedInstance] getLastUpdatedGamesMessage];
        [activityIndicatorView stopAnimating];
        //updatingMessage.text = @" Updated";
        [self updateGameData];
        [loadingIndicator stopAnimating];
        if([[[DataManager sharedInstance] getHandsForCurrentGame] count] > 0){
            if(_tableView.alpha == 0){
                [UIView beginAnimations:@"" context:NULL];
                [UIView setAnimationDuration:0.3];
                _tableView.alpha = 1;
                [UIView commitAnimations];
            }
        }
        if([[DataManager sharedInstance] isCurrentGamePending]){
            [woodBackground removeFromSuperview];
            [flipView  addSubview:pokerTableView];
            [betOrTableViewButton setAsBetView:NO];
            //self.navigationItem.rightBarButtonItem = betViewButton;
            navLabel1.text = @"Table View";
        }
        
        updatingMessage.hidden = YES;
        if(_tableView.alpha == 0){
            updatingMessage.hidden = NO;
        }
        
        if(![[DataManager sharedInstance] hasMoreThanOnePlayerForCurrentGame]){
            [noOneLeftAlert show];
        }
    isGameComplete = [[DataManager sharedInstance] isCurrentGameComplete];
    if(isGameComplete){
        navLabel2.text = @"Game Over";
    }
    }else if([keyPath isEqualToString:@"newMessagesCount"]){
        [messageBubblesViewController reloadMessage];
        if([DataManager sharedInstance].newMessagesCount > 0){
            if([DataManager sharedInstance].newMessagesCount == 1){
                chatField.placeholder = [NSString stringWithFormat:@"%d new message",[DataManager sharedInstance].newMessagesCount];
            }else{
                chatField.placeholder = [NSString stringWithFormat:@"%d new messages",[DataManager sharedInstance].newMessagesCount];
            }
        }else{
            chatField.placeholder = @"Game Chat";
        }
        [chatButton setChatState:[DataManager sharedInstance].newMessagesCount];
    }
}


-(void)showDeleteGameIfNeeded{
    if(userWantsToDelete){
        if([[DataManager sharedInstance] isCurrentGamePending] && [[DataManager sharedInstance] isCurrentGameOwnerMe]){
            [cantDeleletGame show];
        }else{
            [leaveGameAlert show];
        }
    }
    userWantsToDelete = NO;
    
}

-(void)updateGameData{
    
    
    //determine recurrance Index
    
    NSMutableArray *rounds = [[DataManager sharedInstance].currentHand valueForKey:@"rounds"];
    if([rounds count] > 0){
        NSMutableDictionary *currentRound = [rounds objectAtIndex:0];
        for (int i = 1; i < [rounds count]; i++) {
            NSMutableDictionary *nextRound = [rounds objectAtIndex:i];
            //NSLog(@"currentRound:%@",currentRound);
            //NSLog(@"nextRound:%@",nextRound);
            if(![[currentRound valueForKey:@"handState"] isEqualToString:[nextRound valueForKey:@"handState"]]){
                recurranceIndex = i;
                break;
            }
        }
    }
    
    [[DataManager sharedInstance] addBettingRoundIfNeeded];
    

    
    
    [_tableView reloadData];
    [self showDeleteGameIfNeeded];
    if(![winnerLoserAlert isVisible]){
        [pokerTableView loadGame:YES];
    }
    
    navLabel2.text = [NSString stringWithFormat:@"Hand #%@",[pokerTableView.showHand valueForKey:@"number"]];
    [self showWinnerLoserIfNeeded];
    
    if(showAlerts){
        [self showBuyInAlertIfNeeded];
        [self showStartGameAlertIfNeeded];
        showAlerts = NO;
    }
    [self showGameOverIfNeeded];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:[NSString stringWithFormat:@"Game %@",[DataManager sharedInstance].currentGameID]];
    
    //self.title = [NSString stringWithFormat:@"%@ Turn",[[DataManager sharedInstance] getCurrentPlayersTurn]];
}


-(void)viewWillDisappear:(BOOL)animated{
    [FlurryAnalytics endTimedEvent:@"PAGE_VIEW_IN_GAME" withParameters:nil];
    [refreshTimer invalidate];
}







-(void)decreaseBuyIn{
    if(buyIn > 0.25){
        buyIn = buyIn - 0.25;
    }else if(buyIn > 0.05){
        buyIn = buyIn - 0.05;
    }else if(buyIn > 0.01){
        buyIn = buyIn - 0.01;
    }else{
        buyIn = 0.01;
    }
    
    double minBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
    
    if(buyIn < minBuy){
        buyIn = minBuy;
    }
    buyInAmountLabel.text = [NSString stringWithFormat:@"$%.2f",buyIn];

}

-(void)increaseBuyIn{
   
    if(buyIn >= 0.25){
        buyIn = buyIn + 0.25;
    }else if(buyIn >= 0.05){
        buyIn = buyIn + 0.05;
    }else if(buyIn >= 0.01){
        buyIn = buyIn + 0.01;
    }    
    double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
    
    if(buyIn > maxBuy){
        buyIn = maxBuy;
    }
    
     buyInAmountLabel.text = [NSString stringWithFormat:@"$%.2f",buyIn];

}

-(void)joinCashGame{
    if([[DataManager sharedInstance] needsToBuyGame]){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.buyGamePopUp show];
        return;
    }
    NSMutableDictionary *playerState = [[NSMutableDictionary alloc] init];
    [playerState setValue:[NSString stringWithFormat:@"%.2f",buyIn] forKey:@"userStack"];
    [[DataManager sharedInstance] buyInToCurrentGame:playerState];
    [self updateGameData];
    if([@"active" isEqualToString:[[DataManager sharedInstance].currentGame objectForKey:@"status"]]){
        NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
        if([@"buyin" isEqualToString:[currentPlayer objectForKey:@"status"]]){
            [waitNextHandAlert show];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}


-(void)joinTournament{
    if([[DataManager sharedInstance] needsToBuyGame]){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.buyGamePopUp show];
        return;
    }
    double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
    NSMutableDictionary *playerState = [[NSMutableDictionary alloc] init];
    [playerState setValue:[NSString stringWithFormat:@"%.2f",maxBuy] forKey:@"userStack"];
    [[DataManager sharedInstance] buyInToCurrentGame:playerState];
    
    [self updateGameData];
    [self showStartGameAlertIfNeeded];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
    if(alertView == buyInAlert){
        if(buttonIndex == 1){
            //join game
            [self joinCashGame];            
        }else if(buttonIndex == 2){
            //leave game
            [leaveGameAlert show];
        }
    }else if(alertView == joinTournamentAlert){
        if(buttonIndex == 1){
            //join game
            [self joinTournament];
            
        }else if(buttonIndex == 2){
            //leave game
            [leaveGameAlert show];
        }
        
    }else if(alertView == leaveGameAlert){
        if(buttonIndex == 0){
            //cancel
            [self showBuyInAlertIfNeeded];
        }else if(buttonIndex == 1){
            if([[DataManager sharedInstance] isCurrentGamePending] && [[DataManager sharedInstance] isCurrentGameOwnerMe]){
                [cantDeleletGame show];
            }else{
                [[DataManager sharedInstance] leaveCurrentGame];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }else if(alertView == cashGameStartAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] startCurrentGame];
            /*
            if(refreshTimer){
                [refreshTimer invalidate];
            }
            self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshSeconds target:self selector:@selector(loadGame) userInfo:nil repeats:YES];
            [refreshTimer fire];*/

            [[DataManager sharedInstance] addBettingRoundIfNeeded];
            [self updateGameData];
        }
    }else if(alertView == notEnoughPlayersAlert){
        //[self.navigationController popViewControllerAnimated:YES];
    }else if(alertView == waitNextHandAlert){
        if(buttonIndex == 0){
            
            if([@"buyin" isEqualToString:[currentPlayer objectForKey:@"status"]] && [[DataManager sharedInstance] isCurrentGameTypeCash] && ![[DataManager sharedInstance] isCurrentGameOwnerMe]){
                double minBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
                double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
                buyInAlert.title = @"Change Buy In?";//[NSString stringWithFormat:@"Change Buy In?",[[DataManager sharedInstance] getCurrentGameOwnerUserName]];
                buyInRange.text = [NSString stringWithFormat:@"Min $%.2f / Max $%.2f",minBuy,maxBuy];
                buyInAlert.message = @"\n\n\n\n";
                // buyInAlert.message = [NSString stringWithFormat:@"\n\n\n\n",[currentPlayer valueForKey:@"userStack"]];
                buyIn = [[[currentPlayer valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
                buyInAmountLabel.text = [NSString stringWithFormat:@"$%.2f",buyIn];
                [buyInAlert show];
            }
        }
    }else if(alertView == winnerLoserAlertWithBuyin){
        if(buttonIndex == 1){
            double minBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
            double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
            buyInAlert.title = @"Buy In?";
            buyInRange.text = [NSString stringWithFormat:@"Min $%.2f / Max $%.2f",minBuy,maxBuy];
            buyInAlert.message = @"\n\n\n\n";
            buyIn = minBuy;
            buyInAmountLabel.text = [NSString stringWithFormat:@"$%.2f",buyIn];
            [buyInAlert show];
        }else if(buttonIndex == 2){
            [leaveGameAlert show];
        }
    }else if(alertView == winnerLoserAlert){
        
        if(buttonIndex == 0){
            [self pressNewHand];
            
        }else if(buttonIndex == 1){
            [self pressViewHand];
            
        }
        [self showStartGameAlertIfNeeded];
    }else if(alertView == nudgeAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] postNudgeToCurrentPlayer];
        }
    }else if(alertView == waitingForGameOwner){
        //[self.navigationController popViewControllerAnimated:YES];
    }else if(alertView == viewOrNudge){
        if (buttonIndex == 1) {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] pushToPlayersProfile:[pressedPlayer valueForKey:@"userID"]];
        }else if(buttonIndex == 2){
            [self pressNudge];
        }
    }else if(alertView == gameOverAlert){
        if (buttonIndex == 1) {
            [self pressGameStats];
        }
    }else if(alertView == gameOverAlertWithRematch){
        if (buttonIndex == 1) {
            
            
            NSString *handKey = [NSString stringWithFormat:@"OFFER_REMATCH_FOR_GAME_%@",[DataManager sharedInstance].currentGameID];
            
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            if(([prefs valueForKey:handKey] && [@"YES" isEqualToString:[prefs valueForKey:handKey]])){
                UIAlertView *alreadyRematch = [[UIAlertView alloc] initWithTitle:@"Rematch Exists" message:@"You have already created a rematch for this game. Please check the games list to find your game." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alreadyRematch show];
            }else{
                [prefs setValue:@"YES" forKey:handKey];
                [prefs synchronize];
                [[DataManager sharedInstance] offerRematch:[DataManager sharedInstance].currentGame];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
            
            
            
        }else if(buttonIndex == 2){
            [self pressGameStats];
        }
    }else if(alertView == noOneLeftAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] leaveCurrentGame];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}
    
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet == betOptions){
        NSMutableDictionary *betRound = [[NSMutableDictionary alloc] init];
        [betRound setValue:@"34" forKey:@"potSize"];
        [betRound setValue:@"1" forKey:@"actionBy"];
        [betRound setValue:@"raise" forKey:@"action"];
        [betRound setValue:@"10" forKey:@"amount"];
        
        [[DataManager sharedInstance] postRound:betRound];
        [self updateGameData];
       
    }
}




-(void)showBuyInAlertIfNeeded{
    if([joinTournamentAlert isVisible] || [buyInAlert isVisible] || ![[DataManager sharedInstance] hasMoreThanOnePlayerForCurrentGame] || [leaveGameAlert isVisible] || [cantDeleletGame isVisible]){
        return;
    }
    NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
    if([[DataManager sharedInstance] isCurrentGameTypeCash]){
        if([@"pending" isEqualToString:[currentPlayer objectForKey:@"status"]]){
            double minBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
            double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
            buyInAlert.title = @"Buy In?";
            buyInRange.text = [NSString stringWithFormat:@"Min $%.2f / Max $%.2f",minBuy,maxBuy];
            buyInAlert.message = @"\n\n\n\n";
            buyIn = minBuy;
            buyInAmountLabel.text = [NSString stringWithFormat:@"$%.2f",buyIn];
            [buyInAlert show];
        }else if([@"active" isEqualToString:[[DataManager sharedInstance].currentGame objectForKey:@"status"]]){
            if([@"buyin" isEqualToString:[currentPlayer objectForKey:@"status"]]){
                [waitNextHandAlert show];
            }
        }else if([@"buyin" isEqualToString:[currentPlayer objectForKey:@"status"]] && [[DataManager sharedInstance] isCurrentGameTypeCash] && ![[DataManager sharedInstance] isCurrentGameOwnerMe]){
            double minBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
            double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
            buyInAlert.title = @"Change Buy In?";//[NSString stringWithFormat:@"Change Buy In?",[[DataManager sharedInstance] getCurrentGameOwnerUserName]];
            buyInRange.text = [NSString stringWithFormat:@"Min $%.2f / Max $%.2f",minBuy,maxBuy];
            buyInAlert.message = @"\n\n\n\n";
           // buyInAlert.message = [NSString stringWithFormat:@"\n\n\n\n",[currentPlayer valueForKey:@"userStack"]];
            buyIn = [[[currentPlayer valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
            buyInAmountLabel.text = [NSString stringWithFormat:@"$%.2f",buyIn];
            [buyInAlert show];

        }
    }else if([[DataManager sharedInstance] isCurrentGameTypeTournament]){
        NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
        if([@"pending" isEqualToString:[currentPlayer objectForKey:@"status"]]){
            if(!joinTournamentAlert){
                self.joinTournamentAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Join Game",@"Leave Game", nil];
            }
            joinTournamentAlert.title = @"Join Tournament?";
            double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
            joinTournamentAlert.message = [NSString stringWithFormat:@"$%.2f Buy In\nWould you like to buy in to this tournament for $%.2f?",maxBuy,maxBuy];
            [joinTournamentAlert show];
        }
    }
    
}

-(void)showStartGameAlertIfNeeded{
    if([notEnoughPlayersAlert isVisible] || [waitingForGameOwner isVisible] || [waitingForGameOwner isVisible] || ![[DataManager sharedInstance] hasMoreThanOnePlayerForCurrentGame]  || [leaveGameAlert isVisible]  || [cantDeleletGame isVisible]){
        return;
    }
    if([@"pending" isEqualToString:[[DataManager sharedInstance].currentGame objectForKey:@"status"]]){
        NSMutableArray *players = [[DataManager sharedInstance] getPlayersForCurrentGame];
        int numOfReadyPlayers = 0;
        for (NSMutableDictionary *player in players) {
            if([@"buyin" isEqualToString:[player objectForKey:@"status"]] || [@"playing" isEqualToString:[player objectForKey:@"status"]]){
                numOfReadyPlayers++;
            }
        }
        
        NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
        if(![@"pending" isEqualToString:[currentPlayer objectForKey:@"status"]] && ![[DataManager sharedInstance] isGameWaitingForOtherPlayers:[DataManager sharedInstance].currentGame]){
            
            if([[DataManager sharedInstance] isCurrentGameOwnerMe]){
                cashGameStartAlert.message = [NSString stringWithFormat:@"%d/%d players are ready. Would you like to start the game?",numOfReadyPlayers,players.count];
                [cashGameStartAlert show];
            }else{
                self.waitingForGameOwner = [[UIAlertView alloc] initWithTitle:@"Waiting for Game Owner" message:@"Please wait for the game owner to start the game" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [waitingForGameOwner show];
            }
            
        }else{
            if(![@"pending" isEqualToString:[currentPlayer objectForKey:@"status"]]){
                if([[DataManager sharedInstance] isCurrentGameTypeCash]){
                    self.notEnoughPlayersAlert = [[UIAlertView alloc] initWithTitle:@"Waitig for Players" message:[NSString stringWithFormat:@"%d/%d players are ready. A cash game requires at least 2 players to start a game",numOfReadyPlayers,players.count] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                }else{
                    if([[DataManager sharedInstance] isCurrentGameOwnerMe]){
                        self.notEnoughPlayersAlert = [[UIAlertView alloc] initWithTitle:@"Waitig for Players" message:[NSString stringWithFormat:@"%d/%d players are ready. Please wait for all players to join the tournament",numOfReadyPlayers,players.count] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    }else{
                        self.notEnoughPlayersAlert = [[UIAlertView alloc] initWithTitle:@"Waitig for Players" message:[NSString stringWithFormat:@"%d/%d players are ready. Waiting for all players to join.",numOfReadyPlayers,players.count] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    }
                }
                [notEnoughPlayersAlert show];
            }
        }
    }
}

-(void)showWaitNextHandIfNeeded{
    if([@"active" isEqualToString:[[DataManager sharedInstance].currentGame objectForKey:@"status"]]){
        NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
        if([@"buyin" isEqualToString:[currentPlayer objectForKey:@"status"]]){
            [waitNextHandAlert show];
        }
    }
}

-(void)showWinnerLoserIfNeeded{
    if(([winnerLoserAlert isVisible] || [winnerLoserAlertWithBuyin isVisible]) && !showhandOver || ![[DataManager sharedInstance] hasMoreThanOnePlayerForCurrentGame]  || [leaveGameAlert isVisible]  || [cantDeleletGame isVisible]){
        return;
    }
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    if([hands count] > 0){
        NSMutableDictionary *winningHand;
        int i = 0;
        for (NSMutableDictionary *hand in hands) {
            if([hand valueForKey:@"winners"] && [[hand valueForKey:@"winners"] count] > 0){
                winningHand = hand;
                break;
            }
            i++;
        }
            
        NSString *handKey = [NSString stringWithFormat:@"SHOW_WINNER_%@_%@_%@",[[DataManager sharedInstance].currentGame valueForKey:@"gameID"],  [winningHand valueForKey:@"number"],[DataManager sharedInstance].myUserID];
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if(([prefs valueForKey:handKey] && [@"YES" isEqualToString:[prefs valueForKey:handKey]]) || [[[DataManager sharedInstance] getHandsForCurrentGame] count] < 2){
            //do nothing
        }else{
            [pokerTableView loadGame:NO];
            navLabel2.text = [NSString stringWithFormat:@"Hand #%@",[pokerTableView.showHand valueForKey:@"number"]];
            
            if(!winnerLoserAlert){
                self.winnerLoserAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"New Hand",@"View Hand",nil];
            }
            if(!winnerLoserAlertWithBuyin){
                self.winnerLoserAlertWithBuyin = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Re-Buy",@"Leave Game", nil];
            }
            NSMutableArray *winners = [winningHand valueForKey:@"winners"];
            //NSLog(@"Winners for Hand#%@ :%@",[data objectForKey:@"number"],winners);
            if(winners && [winners count] > 0){
                for (NSMutableDictionary *winnerPlayerData in winners) {
                    double winAmount = [[winnerPlayerData objectForKey:@"amount"] doubleValue] - [[DataManager sharedInstance] getPotEntryForUser:[winnerPlayerData objectForKey:@"userID"] hand:winningHand];
                    if([[winnerPlayerData valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
                        winnerLoserAlert.title = [NSString stringWithFormat:@"You won $%.2f!",winAmount];
                        [[DataManager sharedInstance] checkAchievements:winningHand];
                        int handsWon = [[DataManager sharedInstance] getCountForUserAchievement:@"HANDS_WON" category:@"PROFILE"];
                        if(handsWon == 1){
                            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"FIRST_HAND_WIN" category:@"BLACK"];
                            if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                            }
                        }
                        if(handsWon == 5){
                            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_WIN_TOTAL_5" category:@"BRONZE"];
                            if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                            }
                        }
                        if(handsWon == 25){
                            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_WIN_TOTAL_25" category:@"SILVER"];
                            if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                            }
                            
                        }
                        if(handsWon == 100){
                            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_WIN_TOTAL_100" category:@"GOLD"];
                            if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                            }
                            
                        }
                        if(handsWon == 500){
                            NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"HAND_WIN_TOTAL_500" category:@"PLATINUM"];
                            if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                            }
                        }
                        NSMutableArray *rounds = [[DataManager sharedInstance] getRoundsForCurrentHand];
                        for (NSMutableDictionary *round in rounds) {
                            if([[round valueForKey:@"userStack"] doubleValue] == 0){
                                BOOL isWinner;
                                for (NSMutableDictionary *winnerPlayerData in winners) {
                                    if([[winnerPlayerData valueForKey:@"userID"] isEqualToString:[round valueForKey:@"userID"]]){
                                        isWinner = YES;
                                    }
                                }
                                /*
                                if(!isWinner){
                                    int knockOuts = [[DataManager sharedInstance] incrementClientTally:@"KNOCK_OUTS" gameID:[DataManager sharedInstance].currentGameID];
                                    if(knockOuts == 1){
                                        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"KO_1" category:@"BRONZE"];
                                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                                    }else if(knockOuts == 2){
                                        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"KO_2" category:@"SILVER"];
                                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                                    }else if(knockOuts == 3){
                                        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"KO_3" category:@"GOLD"];
                                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                                    }else if(knockOuts >= 4){
                                        NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"KO_4" category:@"PLATINUM"];
                                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                                    }
                                }*/
                            }
                        }
                        
                        
                        
                    }else{
                        winnerLoserAlert.title = [NSString stringWithFormat:@"%@ won $%.2f",[winnerPlayerData objectForKey:@"userName"],winAmount];
                    }
                    winnerLoserAlert.message = NSLocalizedString([winnerPlayerData objectForKey:@"type"], nil);
                    winnerLoserAlertWithBuyin.title = winnerLoserAlert.title;
                    winnerLoserAlertWithBuyin.message = winnerLoserAlert.message;
                }
                NSMutableDictionary *myTurnState = [[DataManager sharedInstance] getPlayerStateMeForCurrentGame];
                if([[DataManager sharedInstance] isCurrentGameActive]){
                    if([[myTurnState valueForKey:@"userStack"] doubleValue] == 0 && [[DataManager sharedInstance] isCurrentGameTypeCash]){
                        [winnerLoserAlertWithBuyin show];
                    }else{
                        [handSummaryPopUp showHandSummary:winningHand showNewHand:YES];
                        //[winnerLoserAlert show];
                        if(refreshTimer){
                            [refreshTimer invalidate];
                        }
                    }
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            }
            
            [prefs setValue:@"YES" forKey:handKey];
            [prefs synchronize];
        }
    }
    showhandOver = NO;
}

-(void)showGameOverIfNeeded{
    BOOL youWon = NO;
    if([gameOverAlert isVisible] || !showGameOver  || [leaveGameAlert isVisible]  || [cantDeleletGame isVisible]){
        return;
    }
    if([[DataManager sharedInstance] isCurrentGameComplete] || [[[[DataManager sharedInstance] getPlayerMeForCurrentGame] valueForKey:@"status"] isEqualToString:@"out"]){
        if(!gameOverAlert){
            self.gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Game Stats", nil];
        }
        
        if(!gameOverAlertWithRematch){
            self.gameOverAlertWithRematch = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rematch",@"Game Stats", nil];
        }
        
        NSArray *gameWinners = [[DataManager sharedInstance] determinGameWinnerForCurrentGame];
        NSMutableDictionary *winner = [gameWinners objectAtIndex:0];
        if([[winner valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            youWon = YES;
            gameOverAlert.title = @"You Won!";
            gameOverAlert.message = @"Nice work, you won the game!";

            NSString *gameKey = [NSString stringWithFormat:@"GAME_WON_%@_%@",[[DataManager sharedInstance].currentGame valueForKey:@"gameID"],[DataManager sharedInstance].myUserID];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            if([prefs valueForKey:gameKey] && [@"YES" isEqualToString:[prefs valueForKey:gameKey]]){
                //do nothing
            }else{
                int gamesWon = [[DataManager sharedInstance] getCountForUserAchievement:@"GAMES_WON" category:@"PROFILE"];
                if(gamesWon == 1){
                    NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"FIRST_GAME_WIN" category:@"BLACK"];
                    if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                    }
                    
                }
                if(gamesWon == 5){
                    NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"GAME_WIN_TOTAL_5" category:@"BRONZE"];
                    if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                    }
                    
                }
                if(gamesWon==25){
                    NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"GAME_WIN_TOTAL_25" category:@"SILVER"];
                    if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                    }
                    
                }
                if(gamesWon == 50){
                    NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"GAME_WIN_TOTAL_50" category:@"GOLD"];
                    if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                    }
                    
                }
                if(gamesWon == 100){
                    NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"GAME_WIN_TOTAL_100" category:@"PLATINUM"];
                    if(![[DataManager sharedInstance] currentUserHasAchievement:gameAchievement]){
                        [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
                    }
                    
                }
                
            }
            [prefs setValue:@"YES" forKey:gameKey];
            [prefs synchronize];
        }else{
            gameOverAlert.title = @"You Are Out";
            
            if([[DataManager sharedInstance] isCurrentGameComplete]){
                gameOverAlert.message = [NSString stringWithFormat:@"The game has ended. %@ won the game",[winner valueForKey:@"userName"]];
                
            }else{
                gameOverAlert.message = [NSString stringWithFormat:@"The game is still in progress. The current chip leader is %@",[winner valueForKey:@"userName"]];
            }
        }
        
        gameOverAlertWithRematch.title = gameOverAlert.title;
        gameOverAlertWithRematch.message = gameOverAlert.message;
        
        if(youWon){
            [gameOverAlertWithRematch show];
        }else{
            [gameOverAlert show];
        }
        
    }
    showGameOver = NO;
}










- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	TurnTableViewCell *cell = (TurnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	UIButton *betButton;
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[TurnTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        betButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        betButton.frame = CGRectMake(250, 5, 60, 50);
        [betButton setTitle:@"Bet" forState:UIControlStateNormal];
        betButton.tag = 1;
        [betButton addTarget:self action:@selector(pressBet) forControlEvents:UIControlEventTouchUpInside];
        //[cell addSubview:betButton];
	}else {
        betButton = (UIButton *) [cell viewWithTag:1];
    }
	
	NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    NSMutableDictionary *hand = [hands objectAtIndex:indexPath.section];
    NSMutableArray *rounds = [[DataManager sharedInstance] getRoundsForHand:hand];
    NSMutableDictionary *round = [rounds objectAtIndex:indexPath.row];
    
    
    
    cell.guiState = 2;
    if((indexPath.row < recurranceIndex && indexPath.section == 0) || recurranceIndex == 0){
        cell.guiState = 1;
    }
    
    int chipState = [[DataManager sharedInstance] getChipStackState:[round valueForKey:@"userID"]];
    
    [cell setCellData:round chipStackState:chipState];    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.betButton addTarget:self action:@selector(pressBet) forControlEvents:UIControlEventTouchUpInside];
    [cell.nudgeButton addTarget:self action:@selector(pressNudge) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    return [hands count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TurnSectionHeader *sectionHeader2 = [[TurnSectionHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    sectionHeader2.delegate = self;
    if(section == 0){
        sectionHeader2.guiState = 1;
        sectionHeader = sectionHeader2;
    }else{
        sectionHeader2.guiState = 2;
    }
    
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    NSMutableDictionary *hand = [hands objectAtIndex:section];
    [sectionHeader2 setHeaderData:hand];
    return sectionHeader2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 125;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    NSMutableDictionary *hand = [hands objectAtIndex:indexPath.section];
    NSMutableArray *rounds = [[DataManager sharedInstance] getRoundsForHand:hand];
    NSMutableDictionary *round = [rounds objectAtIndex:indexPath.row];
    /*
    if(indexPath.row == 0){
        [round setValue:@"" forKey:@"HAND_STATE"];
    }*/

	if([round valueForKey:@"HAND_STATE"] && [[round valueForKey:@"HAND_STATE"] length] > 0 ){
        return 97;
    }
    
	return 72;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    NSMutableDictionary *hand = [hands objectAtIndex:section];
    //NSLog(@"hand:%@",hand);
    NSMutableArray *rounds = [[DataManager sharedInstance] getRoundsForHand:hand];
    return [rounds count]; 
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!betViewController){
        self.betViewController = [[BetViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    NSMutableDictionary *hand = [hands objectAtIndex:indexPath.section];
    NSMutableArray *rounds = [[DataManager sharedInstance] getRoundsForHand:hand];
    NSMutableDictionary *round = [rounds objectAtIndex:indexPath.row];
    betViewController.hand = hand;
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] pushToPlayersProfile:[round valueForKey:@"userID"]];    
    return nil;
}


-(void)showHandSummaryForHand:(NSMutableDictionary *)hand{
    [handSummaryPopUp showHandSummary:hand showNewHand:NO];
    
}


-(void)pressNewHand{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [pokerTableView newHand];
    [pokerTableView loadGame:YES];
    navLabel2.text = [NSString stringWithFormat:@"Hand #%@",[pokerTableView.showHand valueForKey:@"number"]];
    /*
    if(refreshTimer){
        [refreshTimer invalidate]; 
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshSeconds target:self selector:@selector(loadGame) userInfo:nil repeats:YES];
    [refreshTimer fire];*/
    [handSummaryPopUp hide];
}

-(void)pressViewHand{
    [pokerTableView viewHand];
    [handSummaryPopUp hide];
}

-(void)pressBet{
    if(!betViewController){
        self.betViewController = [[BetViewController alloc] initWithNibName:nil bundle:nil];
    }
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    betViewController.hand = [hands objectAtIndex:0];
    [self.navigationController pushViewController:betViewController animated:YES];
}

-(void)pressNudge{
    if(!nudgeAlert){
        self.nudgeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Nudge", nil];
    }
    NSString *userName = [[[[[[DataManager sharedInstance] getHandsForCurrentGame] objectAtIndex:0] valueForKey:@"rounds"] objectAtIndex:0] valueForKey:@"userName"];
    nudgeAlert.title = [NSString stringWithFormat:@"Nudge %@?",userName];
    nudgeAlert.message = [NSString stringWithFormat:@"Send a nudge message to %@?",userName];
    [nudgeAlert show];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showChatWithKeyboard];
    [messageBubblesViewController reloadMessage];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text && textField.text.length > 0){
        chatButton.buttonLabel.text = @"Send";
        
    }else{
        chatButton.buttonLabel.text = @"";
    }
    return YES;
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideChat];
    textField.text = @"";
    chatButton.buttonLabel.text = @"";
    /*
    if(textField.text && textField.text.length > 0){
        [self pressChat];
    }else{
        [self hideChat];
    }*/
    
    return YES;
}

-(void)hideChat{
    //self.navigationItem.rightBarButtonItem = bugButton;
    /*
    if ([_tableView superview]) {
        self.navigationItem.rightBarButtonItem = tableViewButton;
    }else{
        self.navigationItem.rightBarButtonItem = betViewButton;
    }*/
    [FlurryAnalytics endTimedEvent:@"SHOW_CHAT" withParameters:nil];
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
    listTableButton.alpha = 1;
    messageBubblesViewController.view.frame = CGRectMake(0, 416-40, 320, 416-40);
    chatField.frame = CGRectMake(268, 3, 0,32);
    [UIView commitAnimations];
    [chatField resignFirstResponder];
}

-(void)showChatFull{
    [FlurryAnalytics logEvent:@"SHOW_CHAT" timed:YES];
    [[DataManager sharedInstance] setMessagesAsReadForCurrentGame];
    //self.navigationItem.rightBarButtonItem = closeChatButton;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    chatField.frame = CGRectMake(2, 3, 320-54,32);
    listTableButton.alpha = 0;
    chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
    messageBubblesViewController.view.frame = CGRectMake(0, 0, 320, 416-40);
    [UIView commitAnimations];
    [messageBubblesViewController scrollToBottom];
}

-(void)showChatWithKeyboard{
    [FlurryAnalytics logEvent:@"SHOW_CHAT" timed:YES];
    [[DataManager sharedInstance] setMessagesAsReadForCurrentGame];
    //self.navigationItem.rightBarButtonItem = closeChatButton;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    
    listTableButton.alpha = 0;
    chatFieldBackground.frame = CGRectMake(0, 416-255, 320, 40);
    messageBubblesViewController.view.frame = CGRectMake(0, 0, 320, 416-255);
    [UIView commitAnimations];
    [messageBubblesViewController scrollToBottom];
}

-(void)pressChat{
    chatButton.buttonLabel.text = @"";
    [[DataManager sharedInstance] setMessagesAsReadForCurrentGame];
    if(messageBubblesViewController.view.frame.origin.y == 416-40){
        [messageBubblesViewController reloadMessage];
        [self showChatFull];
    }else{
        if(chatField.text && chatField.text.length > 0){
            [[DataManager sharedInstance] postMessageForCurrentGame:chatField.text];
            [messageBubblesViewController reloadMessage];
            
            [UIView beginAnimations:@"" context:NULL];
            [UIView setAnimationDuration:0.2];
            chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
            messageBubblesViewController.view.frame = CGRectMake(0, 0, 320, 416-40);
            chatField.text = @"";
            [UIView commitAnimations];
            [messageBubblesViewController scrollToBottom];
        }else{
            [self hideChat];
        }
    }
    [chatField resignFirstResponder];
}

-(void)reportBug{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] emailBug:self];
}


-(void)flipTable{
    
    
    
    
    if ([woodBackground superview]) {
        [FlurryAnalytics logEvent:@"PRESS_BET_VIEW"];
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:.5];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipView
                                 cache:YES]; 
        [woodBackground removeFromSuperview];
        [flipView  insertSubview:pokerTableView belowSubview:activityIndicatorView];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
        navLabel1.text = @"Table View";
        [pokerTableView loadGame:YES];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isTableView"];
        [betOrTableViewButton setAsBetView:YES];
        
    }
    else {
        [FlurryAnalytics logEvent:@"PRESS_TABLE_VIEW"];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipView
                                 cache:YES]; 
        [pokerTableView removeFromSuperview];
        [flipView  insertSubview:woodBackground belowSubview:activityIndicatorView];
        navLabel1.text = @"Bet View";
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //[_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isTableView"];
        [betOrTableViewButton setAsTableView:YES];
        
    }
    
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    //[UIView commitAnimations];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)pressPlayer:(NSMutableDictionary *)player isPlayersTurn:(BOOL)isPlayersTurn{
    self.pressedPlayer = player;
    if(!isPlayersTurn){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] pushToPlayersProfile:[player valueForKey:@"userID"]];
        return;
    }
    if(!viewOrNudge){
        self.viewOrNudge = [[UIAlertView alloc] initWithTitle:@"View Or Nudge" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View Profile",@"Nudge Player", nil];
    }
    [viewOrNudge show];
}


-(void)pressGameStats{


    if(gameStatsViewController.view.frame.origin.y == 0){
        [FlurryAnalytics endTimedEvent:@"SHOW_GAME_STATS" withParameters:nil];
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.4];
        [gameStatsButton unselectButton:YES];
        gameStatsViewController.view.frame = CGRectMake(0, 416, 320, 416);
        [UIView commitAnimations];
    }else{
        [FlurryAnalytics logEvent:@"SHOW_GAME_STATS" timed:YES];
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.4];
        gameStatsViewController.view.frame = CGRectMake(0, 0, 320, 416);
        [gameStatsButton selectButton:YES];
        [UIView commitAnimations];
        [gameStatsViewController loadGameStats];
    }
    
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
