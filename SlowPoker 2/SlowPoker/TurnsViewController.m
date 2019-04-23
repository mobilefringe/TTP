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
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_black.png"]];
    [self.view addSubview:background];
    /*
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"felt_full.png"]];
    backgroundImage.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:backgroundImage];*/
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake(140, 70, 40, 40);
    //[self.view addSubview:activityIndicatorView];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self.view addSubview:activityIndicatorView];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70;
    _tableView.frame = CGRectMake(0, 0, 320, 416-40);
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    self.messageBubblesViewController = [[MessageBubblesViewController alloc] initWithNibName:nil bundle:nil];
    messageBubblesViewController.view.frame = CGRectMake(0, 416-40, 320, 416-40);
    [self.view addSubview:messageBubblesViewController.view];
    
    
    self.chatFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 416-40, 320, 36)];
    chatFieldBackground.backgroundColor = [UIColor blackColor];
    [self.view addSubview:chatFieldBackground];
    
    self.chatField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 320-70,30)];
    chatField.delegate = self;
    chatField.borderStyle = UITextBorderStyleRoundedRect;
    chatField.returnKeyType = UIReturnKeySend;
    chatField.placeholder = @"Game Chat";
    [chatFieldBackground addSubview:chatField];
    
    self.chatButton = [[ChatButton alloc] initWithFrame:CGRectMake(258, 5, 60, 34)];
    //[chatButton setTitle:@"Send" forState:UIControlStateNormal];
    [chatButton.button addTarget:self action:@selector(pressChat) forControlEvents:UIControlEventTouchUpInside];
    [chatFieldBackground addSubview:chatButton];
    
    self.updatingMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 305, 22)];
    updatingMessage.text = @"Updating";
    updatingMessage.backgroundColor = [UIColor clearColor];
    updatingMessage.textColor = [UIColor blackColor];
    updatingMessage.font = [UIFont boldSystemFontOfSize:14];
    updatingMessage.textAlignment = UITextAlignmentRight;
    //[self.view addSubview:updatingMessage];
    
    
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
    
    self.navigationItem.rightBarButtonItem = bugButton;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    if(refreshTimer){
        [refreshTimer invalidate];
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadGame) userInfo:nil repeats:YES];
    [refreshTimer fire];

}


-(void)viewWillAppear:(BOOL)animated{
    
    isGameComplete = NO;
    showAlerts = YES;
    chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
    messageBubblesViewController.view.frame = CGRectMake(0, 416-40, 320, 416-40);
        
    _tableView.alpha = 0;
    [activityIndicatorView startAnimating];
    
}

-(void)loadGame{
    if(!isGameComplete){
        [sectionHeader.activityIndicatorView startAnimating];
        [[DataManager sharedInstance] loadGameDetails:[DataManager sharedInstance].currentGameID];
        [[DataManager sharedInstance] loadNewMessages];
       // self.title = @"Updating";
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"gameDetailsUpdates"]){
        [sectionHeader.activityIndicatorView stopAnimating];
        updatingMessage.text = [[DataManager sharedInstance] getLastUpdatedGamesMessage];
        [activityIndicatorView stopAnimating];
        updatingMessage.text = @" Updated";
        [self updateGameData];
        if([[[DataManager sharedInstance] getHandsForCurrentGame] count] > 0){
            if(_tableView.alpha == 0){
                [UIView beginAnimations:@"" context:NULL];
                [UIView setAnimationDuration:0.3];
                _tableView.alpha = 1;
                [UIView commitAnimations];
            }
        }
    isGameComplete = [[DataManager sharedInstance] isCurrentGameComplete];
    if(isGameComplete){
        self.title = @"Game Over";
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
    [self showWinnerLoserIfNeeded];
    
    if(showAlerts){
        [self showBuyInAlertIfNeeded];
        [self showStartGameAlertIfNeeded];
        showAlerts = NO;
    }
    [self showGameOverIfNeeded];
    
    self.title = [NSString stringWithFormat:@"%@ Turn",[[DataManager sharedInstance] getCurrentPlayersTurn]];
}


-(void)viewWillDisappear:(BOOL)animated{
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableDictionary *currentPlayer = [[DataManager sharedInstance] getPlayerMeForCurrentGame];
    if(alertView == buyInAlert){
        if(buttonIndex == 1){
            //join game
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
            
        }else if(buttonIndex == 2){
            //leave game
            [leaveGameAlert show];
        }
    }else if(alertView == joinTournamentAlert){
        if(buttonIndex == 1){
            //join game
            double maxBuy = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
            NSMutableDictionary *playerState = [[NSMutableDictionary alloc] init];
            [playerState setValue:[NSString stringWithFormat:@"%.2f",maxBuy] forKey:@"userStack"];
            [[DataManager sharedInstance] buyInToCurrentGame:playerState];
            
            [self updateGameData];
            [self showStartGameAlertIfNeeded];
            
        }else if(buttonIndex == 2){
            //leave game
            [leaveGameAlert show];
        }
        
    }else if(alertView == leaveGameAlert){
        if(buttonIndex == 0){
            //cancel
            [self showBuyInAlertIfNeeded];
        }else if(buttonIndex == 1){
            [[DataManager sharedInstance] leaveCurrentGame];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else if(alertView == cashGameStartAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] startCurrentGame];
            self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadGame) userInfo:nil repeats:YES];
            [refreshTimer fire];

            [[DataManager sharedInstance] addBettingRoundIfNeeded];
            [self updateGameData];
        }
    }else if(alertView == notEnoughPlayersAlert){
        [self.navigationController popViewControllerAnimated:YES];
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self showStartGameAlertIfNeeded];
    }else if(alertView == nudgeAlert){
        if(buttonIndex == 1){
            [[DataManager sharedInstance] postNudgeToCurrentPlayer];
        }
    }else if(alertView == waitingForGameOwner){
        [self.navigationController popViewControllerAnimated:YES];
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
    if([joinTournamentAlert isVisible] || [buyInAlert isVisible]){
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
    if([notEnoughPlayersAlert isVisible] || [waitingForGameOwner isVisible] || [waitingForGameOwner isVisible]){
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
                        self.notEnoughPlayersAlert = [[UIAlertView alloc] initWithTitle:@"Waitig for Players" message:[NSString stringWithFormat:@"%d/%d players are ready. Please wait for all players to join the tournament or edit the player list to proceed",numOfReadyPlayers,players.count] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Edit players",@"OK", nil];
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
    if([winnerLoserAlert isVisible] || [winnerLoserAlertWithBuyin isVisible]){
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
        if([prefs valueForKey:handKey] && [@"YES" isEqualToString:[prefs valueForKey:handKey]]){
            //do nothing
        }else{
            //must show the user who won the last hand
            if(!winnerLoserAlert){
                self.winnerLoserAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"New Hand", nil];
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
                        [winnerLoserAlert show];
                    }
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            }
            
            [prefs setValue:@"YES" forKey:handKey];
            [prefs synchronize];
        }
    }
}

-(void)showGameOverIfNeeded{
    if([gameOverAlert isVisible]){
        return;
    }
    if([[DataManager sharedInstance] isCurrentGameComplete] || [[[[DataManager sharedInstance] getPlayerMeForCurrentGame] valueForKey:@"status"] isEqualToString:@"out"]){
        if(!gameOverAlert){
            self.gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Somebody won but I haven't bothered figuring out who yet. Need some input on what to show here for a cash game etc. Tournament is easy " delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        }
        NSMutableArray *playersComplete = [[NSMutableArray alloc] init];
        NSMutableDictionary *gameSummary = [[[DataManager sharedInstance].currentGame valueForKey:@"gameState"] valueForKey:@"gameSummary"];
        for (NSMutableDictionary *player in [[DataManager sharedInstance] getPlayersForCurrentGame]) {
            
            double playerTotal = 0;
            if([@"buyin" isEqualToString:[player objectForKey:@"status"]]){
                playerTotal =  (-1.0)*[[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue] - [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue];
            }else{
                if([[DataManager sharedInstance] isCurrentGameTypeCash]){
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
        
        NSMutableDictionary *winner = [sortedArray objectAtIndex:0];
        if([[winner valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            gameOverAlert.title = @"You Won!";
        }else{
            if([[DataManager sharedInstance] isCurrentGameComplete]){
                gameOverAlert.title = [NSString stringWithFormat:@"%@ Won",[winner valueForKey:@"userName"]];
            }else{
                gameOverAlert.title = [NSString stringWithFormat:@"Chip Leader: %@",[winner valueForKey:@"userName"]];
            }
        }
        
        gameOverAlert.message = @"";
        int i = 1;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:kCFNumberFormatterCurrencyStyle];
        for (NSMutableDictionary *playerSummary in sortedArray) {
            
            gameOverAlert.message = [gameOverAlert.message stringByAppendingFormat:@"#%d    %@    %@\n",i,[playerSummary valueForKey:@"userName"],[formatter stringFromNumber:[playerSummary valueForKey:@"playerTotal"]]];
            i++;
        }
        [gameOverAlert show];
    }
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
    [cell setCellData:round];    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.betButton.button addTarget:self action:@selector(pressBet) forControlEvents:UIControlEventTouchUpInside];
    [cell.nudgeButton.button addTarget:self action:@selector(pressNudge) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    NSMutableArray *hands = [[DataManager sharedInstance] getHandsForCurrentGame];
    return [hands count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TurnSectionHeader *sectionHeader2 = [[TurnSectionHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
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
    return 90;
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
        return 95;
    }
    
	return 70;
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
    
    if([round objectForKey:@"MY_BET_ROUND"] && [@"YES" isEqualToString:[round objectForKey:@"MY_BET_ROUND"]] && [[DataManager sharedInstance] isCurrentGameMyTurn]){
        [self.navigationController pushViewController:betViewController animated:YES];
    }
    
    return nil;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text && textField.text.length > 0){
        [self pressChat];
    }else{
        [self hideChat];
    }
    
    return YES;
}

-(void)hideChat{
    self.navigationItem.rightBarButtonItem = bugButton;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
    messageBubblesViewController.view.frame = CGRectMake(0, 416-40, 320, 416-40);
    [UIView commitAnimations];
    [chatField resignFirstResponder];
}

-(void)showChatFull{
    [[DataManager sharedInstance] updateNewMessageCount:0];
    self.navigationItem.rightBarButtonItem = closeChatButton;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    chatFieldBackground.frame = CGRectMake(0, 416-40, 320, 40);
    messageBubblesViewController.view.frame = CGRectMake(0, 0, 320, 416-40);
    [UIView commitAnimations];
    [messageBubblesViewController scrollToBottom];
}

-(void)showChatWithKeyboard{
    [[DataManager sharedInstance] updateNewMessageCount:0];
    self.navigationItem.rightBarButtonItem = closeChatButton;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    chatFieldBackground.frame = CGRectMake(0, 416-255, 320, 40);
    messageBubblesViewController.view.frame = CGRectMake(0, 0, 320, 416-255);
    [UIView commitAnimations];
    [messageBubblesViewController scrollToBottom];
}

-(void)pressChat{
    [[DataManager sharedInstance] updateNewMessageCount:0];
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
