 //
//  GamesViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamesViewController.h"
#import "DataManager.h"
#import "TurnsViewController.h"
#import "NewGameSelectionViewController.h"
#import "GameDetailsViewController.h"
#import "GameTableViewCell.h"
#import "AppDelegate.h"
#import "CellHeaderGeneral.h"
#import "CellFooterGeneral.h"
#import "SVPullToRefresh.h"
#import "UpdatingPopUp.h"

@implementation GamesViewController

@synthesize activityIndicatorView;
@synthesize updatingMessage;
@synthesize turnsViewController;
@synthesize theNewGameSelectionViewController;
@synthesize navController;
@synthesize gameDetailsViewController;
@synthesize refreshTimer;
@synthesize _tableView;
@synthesize deleteGame;
@synthesize deleteGameAlert;
@synthesize joinGameAlert;
@synthesize headerActivityIndicatorView1;
@synthesize headerActivityIndicatorView2;
@synthesize headerActivityIndicatorView3;
@synthesize header1;
@synthesize header2;
@synthesize header3;
@synthesize autoLoadGame;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"gamesUpdated" options:NSKeyValueObservingOptionOld context:nil];
    
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"joinGameID" options:NSKeyValueObservingOptionOld context:nil];
    
    
    self.turnsViewController = [[TurnsViewController alloc] initWithNibName:nil bundle:nil];
    self.theNewGameSelectionViewController = [[NewGameSelectionViewController alloc] initWithNibName:nil bundle:nil];
    self.gameDetailsViewController = [[GameDetailsViewController alloc] initWithNibName:nil bundle:nil];
    return self;
}

-(void)loadView{
    [super loadView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks_background.png"]];
    background.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:background];
    
    
    
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    [_tableView addPullToRefreshWithActionHandler:^{
        [self loadGames];
        // call [tableView.pullToRefreshView stopAnimating] when done
    }];
    _tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    _tableView.pullToRefreshView.textColor = [UIColor whiteColor];
    _tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview:_tableView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake(270, 3, 40, 40);
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    //[self.view addSubview:activityIndicatorView];
    
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingIndicator.frame = CGRectMake(150, 170, 20, 20);
	loadingIndicator.hidesWhenStopped = YES;
	[loadingIndicator startAnimating];
	[self.view addSubview:loadingIndicator];
    
    
    
    
    self.updatingMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 305, 20)];
    //updatingMessage.text = @"Updating";
    updatingMessage.backgroundColor = [UIColor clearColor];
    updatingMessage.textColor = [UIColor whiteColor];
    updatingMessage.font = [UIFont boldSystemFontOfSize:14];
    updatingMessage.textAlignment = UITextAlignmentRight;
    [self.view addSubview:updatingMessage];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(newGame)];
    //self.navigationItem.rightBarButtonItem = barButton;
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:theNewGameSelectionViewController];
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGames) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [[DataManager sharedInstance] setProfileToMe];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"My Games"];
    /*
    if(refreshTimer){
        [refreshTimer invalidate];
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadGames) userInfo:nil repeats:YES];
    [refreshTimer fire];*/
    [self loadGames];
    _tableView.alpha = 0;
    [activityIndicatorView startAnimating];
    [loadingIndicator startAnimating];
}



-(void)loadGames{
    [[DataManager sharedInstance] loadUserGames];
    [activityIndicatorView startAnimating];
    [headerActivityIndicatorView1 startAnimating];
    [headerActivityIndicatorView2 startAnimating];
    [headerActivityIndicatorView3 startAnimating];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"gamesUpdated"]){
        [_tableView.pullToRefreshView stopAnimating];
        [activityIndicatorView stopAnimating];
        [headerActivityIndicatorView1 stopAnimating];
        [headerActivityIndicatorView2 stopAnimating];
        [headerActivityIndicatorView3 stopAnimating];
        [loadingIndicator stopAnimating];
        [_tableView reloadData];
        if(_tableView.alpha == 0){
            [UIView beginAnimations:@"" context:NULL];
            [UIView setAnimationDuration:0.3];
            _tableView.alpha = 1;
            [UIView commitAnimations];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.title = @"My Games";
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int friendsCount = [[prefs valueForKey:@"FRIENDS_COUNT"] intValue];
        /*
        if(friendsCount != [[DataManager sharedInstance].myFriends count]){
            if([[DataManager sharedInstance].myFriends count] == 3){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BUDDIES_3" category:@"BRONZE"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
            }else if([[DataManager sharedInstance].myFriends count] == 5){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BUDDIES_5" category:@"SILVER"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
            }else if([[DataManager sharedInstance].myFriends count] == 10){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BUDDIES_10" category:@"GOLD"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
            }if([[DataManager sharedInstance].myFriends count] == 15){
                NSMutableDictionary *gameAchievement = [[DataManager sharedInstance] getGameAchievementForCode:@"BUDDIES_15" category:@"PLATINUM"];
                [[DataManager sharedInstance] incrementAchievement:gameAchievement forUser:[DataManager sharedInstance].myUserID];
            }    
            
            
            [prefs setValue:[NSNumber numberWithInt:[[DataManager sharedInstance].myFriends count]] forKey:@"FRIENDS_COUNT"];
            [prefs synchronize];
        }*/
    }else if([keyPath isEqualToString:@"joinGameID"]){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.updatingPopUp hide];
        [DataManager sharedInstance].currentGameID = [DataManager sharedInstance].joinGameID;
        [self.navigationController pushViewController:turnsViewController animated:YES];
    }

    
    
    
    
   // self.title = [DataManager sharedInstance].myUserName;
}

-(void)viewWillDisappear:(BOOL)animated{
    [refreshTimer invalidate];
}


-(void)updateGames{
    [activityIndicatorView startAnimating];
    
    updatingMessage.text = @"Updating";
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	GameTableViewCell *cell = (GameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[GameTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
	}
	
	
    
    
    NSMutableDictionary *game;
    cell.isPlayNow = NO;
    cell.isCreateGame = NO;
    cell.isFreeGames = NO;
    cell.isDeleteGameBlurb = NO;
    cell.isFeedback = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton;
    if(indexPath.section == 0){
        //your turn games
        
        if(indexPath.row == [[DataManager sharedInstance].yourTurnGames count]){
            cell.isCreateGame = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //return cell;
        }else if(indexPath.row -1 == [[DataManager sharedInstance].yourTurnGames count]){
            
            cell.isPlayNow = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //return cell;
        }else if(indexPath.row -2 == [[DataManager sharedInstance].yourTurnGames count]){
            
            cell.isFeedback = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //return cell;
        }else{
            if([[DataManager sharedInstance].yourTurnGames count] > 0){
                game = [[DataManager sharedInstance].yourTurnGames objectAtIndex:indexPath.row];
            }
        }
    }else if(indexPath.section == 1){
        //your turn games
        if(indexPath.row == [[DataManager sharedInstance].theirTurnGames count]){
            cell.isFreeGames = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            if([[DataManager sharedInstance].theirTurnGames count] > 0){
                game = [[DataManager sharedInstance].theirTurnGames objectAtIndex:indexPath.row];
            }
        }
        
    }else if(indexPath.section == 2){
        //completed games
        if(indexPath.row == [[DataManager sharedInstance].completedGames count]){
            cell.isDeleteGameBlurb = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            if([[DataManager sharedInstance].completedGames count] > 0){
                game = [[DataManager sharedInstance].completedGames objectAtIndex:indexPath.row];
            }
        }
    }
    
    [cell setCellData:game];
    
    
    
   
    
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Your Turn";
    }else if(section == 1){
        return @"Their Turn";
    }else if(section == 2){
        return @"Completed Games";
    }
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if(!header1){
            self.header1 = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 35) title:@"Your Turn"];
            if(!headerActivityIndicatorView1){
                self.headerActivityIndicatorView1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                headerActivityIndicatorView1.frame = CGRectMake(281, 12, 20, 20);
                headerActivityIndicatorView1.hidesWhenStopped = YES;
                [headerActivityIndicatorView1 stopAnimating];
                
            }
            [header1 addSubview:headerActivityIndicatorView1];
        }
        return header1;
    }else if(section == 1){
        if(!header2){
            self.header2 = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 35) title:@"Their Turn"];
            if(!headerActivityIndicatorView2){
                self.headerActivityIndicatorView2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                headerActivityIndicatorView2.frame = CGRectMake(281, 12, 20, 20);
                headerActivityIndicatorView2.hidesWhenStopped = YES;
                [headerActivityIndicatorView2 stopAnimating];
                
            }
            [header2 addSubview:headerActivityIndicatorView2];
        }
        return header2;
    }else if(section == 2){
        if(!header3){
            self.header3 = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 35) title:@"Completed Games"];
            if(!headerActivityIndicatorView3){
                self.headerActivityIndicatorView3 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                headerActivityIndicatorView3.frame = CGRectMake(281, 12, 20, 20);
                headerActivityIndicatorView3.hidesWhenStopped = YES;
                [headerActivityIndicatorView3 stopAnimating];
                
            }
            [header3 addSubview:headerActivityIndicatorView3];
        }
        return header3;    
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 40) title:[NSString stringWithFormat:@"%d games waiting for you",[[DataManager sharedInstance].yourTurnGames count]]];
        return header;
    }else if(section == 1){
        CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, 320, 40) title:[NSString stringWithFormat:@"%d games waiting for opponent ",[[DataManager sharedInstance].theirTurnGames count]]];
        return header;
    }else if(section == 2){
        CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, 320, 40) title:[NSString stringWithFormat:@"%d completed games",[[DataManager sharedInstance].completedGames count]]];
        return header;
    }
    return nil;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [[DataManager sharedInstance].yourTurnGames count]+3;
    }if(section == 1){
        return [[DataManager sharedInstance].theirTurnGames count]+1;
    }else if(section == 2){
        return [[DataManager sharedInstance].completedGames count]+1;
    }
    return 0;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *game;
    if(indexPath.section == 0){
        if(indexPath.row == [[DataManager sharedInstance].yourTurnGames count]){
            [self newGame];
            return nil;
        }else if(indexPath.row -1 == [[DataManager sharedInstance].yourTurnGames count]){
            /*
            if(!joinGameAlert){
                self.joinGameAlert = [[UIAlertView alloc] initWithTitle:@"Game Type" message:@"Please select the type of game you would like to play" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Cash Game",@"Tournament Game",@"Either one", nil];
            }
            [joinGameAlert show];
             */
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.updatingPopUp showWithMessage:@"Joining Game"];
            [[DataManager sharedInstance] joinGame:@"cash"];

            return nil;        
        }else if(indexPath.row -2 == [[DataManager sharedInstance].yourTurnGames count]){
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] emailBug:self];
            return nil;        
        }
        game = [[DataManager sharedInstance].yourTurnGames objectAtIndex:indexPath.row];
        [DataManager sharedInstance].currentTurnUserID = [DataManager sharedInstance].myUserID;
        [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[DataManager sharedInstance].myUserID game:game] objectForKey:@"userName"];
    }else if(indexPath.section == 1){
        if(indexPath.row == [[DataManager sharedInstance].theirTurnGames count]){
            return nil;
            
        }
        //your turn games
        game = [[DataManager sharedInstance].theirTurnGames objectAtIndex:indexPath.row];
        [DataManager sharedInstance].currentTurnUserID = [game objectForKey:@"nextActionForUserID"];
        [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[game objectForKey:@"nextActionForUserID"] game:game] objectForKey:@"userName"];
    }else if(indexPath.section == 2){
        //completed games
        if(indexPath.row == [[DataManager sharedInstance].completedGames count]){
            return nil;
            
        }
        game = [[DataManager sharedInstance].completedGames objectAtIndex:indexPath.row];
        [DataManager sharedInstance].currentTurnUserID = [game objectForKey:@"nextActionForUserID"];
        [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[game objectForKey:@"nextActionForUserID"] game:game] objectForKey:@"userName"];
    }
    
    [DataManager sharedInstance].currentTurnUserID = [DataManager sharedInstance].myUserID;
    [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[DataManager sharedInstance].myUserID game:game] objectForKey:@"userName"];
    
    [DataManager sharedInstance].currentGameID = [game objectForKey:@"gameID"];
    [turnsViewController resetGameStats];
    [self.navigationController pushViewController:turnsViewController animated:YES];

    return nil;
}

-(void)loadGame:(NSString *)gameID{
    if(gameID){
        [DataManager sharedInstance].currentGameID = gameID;
        [turnsViewController resetGameStats];
        [self.navigationController pushViewController:turnsViewController animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *game;
    if(indexPath.section == 0){
        //your turn games
        game = [[DataManager sharedInstance].yourTurnGames objectAtIndex:indexPath.row];
    }else if(indexPath.section == 1){
        //your turn games
        game = [[DataManager sharedInstance].theirTurnGames objectAtIndex:indexPath.row];
    }else if(indexPath.section == 2){
        //completed games
        game = [[DataManager sharedInstance].completedGames objectAtIndex:indexPath.row];
    }
    
    gameDetailsViewController.game = game;
    [self.navigationController pushViewController:gameDetailsViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == [[DataManager sharedInstance].yourTurnGames count]){
            return NO;    
        }else if(indexPath.row -1 == [[DataManager sharedInstance].yourTurnGames count]){
            return NO;       
        }else if(indexPath.row -2 == [[DataManager sharedInstance].yourTurnGames count]){
            return NO;       
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == [[DataManager sharedInstance].theirTurnGames count]){
            return NO;    
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == [[DataManager sharedInstance].completedGames count]){
            return NO;    
        }
    }
    /*
    if(indexPath.section == 2){
        return YES;
    }*/
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    turnsViewController.userWantsToDelete = YES;
    [self tableView:tableView willSelectRowAtIndexPath:indexPath];
    return;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        if(indexPath.section == 0){
            turnsViewController.userWantsToDelete = YES;
            [self tableView:tableView willSelectRowAtIndexPath:indexPath];
            self.deleteGame = [[DataManager sharedInstance].yourTurnGames objectAtIndex:indexPath.row];
            return;
        }else if(indexPath.section == 1){
            //their turn games
            turnsViewController.userWantsToDelete = YES;
            [self tableView:tableView willSelectRowAtIndexPath:indexPath];
            self.deleteGame = [[DataManager sharedInstance].theirTurnGames objectAtIndex:indexPath.row];
           
        }else if(indexPath.section == 2){
            //completed games
            self.deleteGame = [[DataManager sharedInstance].completedGames objectAtIndex:indexPath.row];
        }
        if(!deleteGameAlert){
            self.deleteGameAlert = [[UIAlertView alloc] initWithTitle:@"Delete Game?" message:@"Are you sure you want to delete this game? Only completed games can be deleted" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        }
        [deleteGameAlert show];
    }    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == deleteGameAlert){
        [[DataManager sharedInstance] deleteGame:deleteGame];
        [self loadGames];
    }else if(alertView == joinGameAlert){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.updatingPopUp showWithMessage:@"Joining Game"];
        if(buttonIndex == 1){
            [[DataManager sharedInstance] joinGame:@"cash"];
        }else if(buttonIndex == 2){
            [[DataManager sharedInstance] joinGame:@"tournament"];
        }else if(buttonIndex == 3){
            [[DataManager sharedInstance] joinGame:@"either"];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.updatingPopUp hide];
        }
    }
}

-(void)newGame{
    
    [navController popToRootViewControllerAnimated:NO];
    [self presentModalViewController:self.navController animated:YES];
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
