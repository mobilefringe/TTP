//
//  InvitePlayersViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvitePlayersViewController.h"
#import "DataManager.h"
#import "InvitePlayerCell.h"
#import "CellHeaderGeneral.h"
#import "CellFooterGeneral.h"
#import "AppDelegate.h"
#import "UpdatingPopUp.h"
#import "GamesViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation InvitePlayersViewController

@synthesize _tableView;
@synthesize searchBar;
@synthesize searchResult;
@synthesize game;
@synthesize isEditPlayers;
@synthesize barButton;
@synthesize removeAlert;
@synthesize tmpPlayerData;
@synthesize addAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Invite Players";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks_background.png"]];
    background.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:background];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    searchBar.placeholder = @"Search by email";
    searchBar.tintColor = [UIColor blackColor];
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    [self.view addSubview:searchBar];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 50;
    _tableView.frame = CGRectMake(0, 50, 320, 416-50);
    [self.view addSubview:_tableView];
    
    self.barButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Game"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(createGame)];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [FlurryAnalytics logEvent:@"PAGE_VIEW_INVITE_FRIENDS" timed:YES];
    if(isEditPlayers){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = barButton;
    }
    self.searchResult = nil;
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [FlurryAnalytics endTimedEvent:@"PAGE_VIEW_INVITE_FRIENDS" withParameters:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	InvitePlayerCell *cell = (InvitePlayerCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[InvitePlayerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }  
    
    NSMutableDictionary *playerData;
    if(indexPath.section == 0){
        playerData = searchResult;
    }else if(indexPath.section == 1){
        NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
        NSMutableArray *players = [turnState objectForKey:@"players"];
        playerData = [players objectAtIndex:indexPath.row];
    }else if(indexPath.section == 2){
        playerData = [[DataManager sharedInstance].myFriends objectAtIndex:indexPath.row];
    }
	
    [cell loadPlayerData:playerData showCheckMark:[self hasPlayerBeenInvited:playerData]];
    
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *playerData;
    NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
    NSMutableArray *players = [turnState objectForKey:@"players"];
    
    if(indexPath.section == 0){
        playerData = searchResult;
    }else if(indexPath.section == 1){
        playerData = [players objectAtIndex:indexPath.row];
    }else if(indexPath.section == 2){
        playerData = [[DataManager sharedInstance].myFriends objectAtIndex:indexPath.row];
    }else if(indexPath.section == 3){
        playerData = [[DataManager sharedInstance].recentPlayers objectAtIndex:indexPath.row];
    }
    self.tmpPlayerData = playerData;
        
    if([self hasPlayerBeenInvited:playerData]){
        if(!isEditPlayers){
            if(![[playerData objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
                [self removePlayerFromGame:playerData];
            }else{
                UIAlertView *cantRemoveAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Remove Player" message:@"You are the game owner and cannot be removed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [cantRemoveAlert show];
            }
        }else{
            if(![[game valueForKey:@"gameOwnerID"] isEqualToString:[DataManager sharedInstance].myUserID]){
                UIAlertView *cantRemoveAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Remove Player" message:@"Only the owner of the game can remove players" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [cantRemoveAlert show];
            }else{
                if([[playerData objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
                    UIAlertView *cantRemoveAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Remove Player" message:@"You are the game owner and cannot be removed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [cantRemoveAlert show];
                }else{
                    if(!removeAlert){
                       self.removeAlert = [[UIAlertView alloc] initWithTitle:@"Remove Player?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                    }
                    removeAlert.message = [NSString stringWithFormat:@"Are you sure you want to remove %@ from the game?",[playerData valueForKey:@"userName"]];
                    [removeAlert show];
                    
                }
            }
        }
    }else{
        if(isEditPlayers){
            if(!addAlert){
                self.addAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Canel" otherButtonTitles:@"Invite", nil]; 
            }
            addAlert.title = [NSString stringWithFormat:@"Invite %@?",[playerData valueForKey:@"userName"]];
            addAlert.message = [NSString stringWithFormat:@"Would you like to invite %@ to this game?",[playerData valueForKey:@"userName"]];
            [addAlert show];
        }else{
            [self addPlayerToGame:tmpPlayerData];
            [_tableView reloadData];
        }
    }
    
    [_tableView reloadData];
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == removeAlert && buttonIndex == 1){
        
    }else if(alertView == addAlert && buttonIndex == 1){
        [self addPlayerToGame:tmpPlayerData];
    }
    
}


-(void)createGame{
    int playerCount = [[[game objectForKey:@"turnState"] objectForKey:@"players"] count];
    if(playerCount > 1){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.updatingPopUp showWithMessage:@"Creating Game"];
        dispatch_async(kBgQueue, ^{
            [[DataManager sharedInstance] createNewGame:game];
            [self performSelectorOnMainThread:@selector(doneCreatingGame) 
                                   withObject:nil waitUntilDone:YES];
        });

    }else{
        UIAlertView *notEnoughPlayersAlert = [[UIAlertView alloc] initWithTitle:@"More Players Needed" message:@"At least 2 players are needed to create a game. Please invite more players to begin the game" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [notEnoughPlayersAlert show];
        
    }
}

-(void)doneCreatingGame{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.updatingPopUp hide];
    [appDelegate.gamesViewController loadGame:[DataManager sharedInstance].createGameID];
    [self dismissModalViewControllerAnimated:YES];
}


-(void)addPlayerToGame:(NSMutableDictionary *)addPlayer{
    
    
    NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
    NSMutableArray *players = [turnState objectForKey:@"players"];
    if([players count] == 7){
        UIAlertView *cantAddAlert = [[UIAlertView alloc] initWithTitle:@"7 Player Max" message:@"You have reached the maxium number of players. Please remove a player before adding a new one" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [cantAddAlert show];
        return;
    }
    for (NSMutableDictionary *player in players) {
        if([[player objectForKey:@"userID"] isEqualToString:[addPlayer objectForKey:@"userID"]]){
            UIAlertView *cantAddAlert = [[UIAlertView alloc] initWithTitle:@"Player Added" message:@"This player has already been added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [cantAddAlert show];
        }
    }
    
    NSMutableDictionary *newPlayer = [[NSMutableDictionary alloc] init];
    [newPlayer setValue:[addPlayer valueForKey:@"userID"] forKey:@"userID"];
    [newPlayer setValue:[game valueForKey:@"gameID"] forKey:@"gameID"];
    [newPlayer setValue:[NSString stringWithFormat:@"%@",[addPlayer valueForKey:@"userName"]] forKey:@"userName"];
    [newPlayer setValue:[[DataManager sharedInstance] getNextPlayerOrderForGame:game] forKey:@"order"];
    [newPlayer setValue:@"pending" forKey:@"status"];
    [players addObject:newPlayer];
    
    if(isEditPlayers){
        [[DataManager sharedInstance] invitePlayer:newPlayer];
    }
    [_tableView reloadData];
}

-(void)removePlayerFromGame:(NSMutableDictionary *)removePlayer{
    NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
    NSMutableArray *players = [turnState objectForKey:@"players"];
    NSMutableDictionary *removerTmp = nil;
    for (NSMutableDictionary *player in players) {
        if([[player valueForKey:@"userName"] isEqualToString:[removePlayer objectForKey:@"userName"]]){
            removerTmp = player;
        }
    }
    [players removeObject:removerTmp];
}

-(BOOL)hasPlayerBeenInvited:(NSMutableDictionary *)invitePlayer{
    NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
    NSMutableArray *players = [turnState objectForKey:@"players"];
    //NSLog(@"players:%@",players);
    for (NSMutableDictionary *player in players) {
        if([[player valueForKey:@"userName"] isEqualToString:[invitePlayer objectForKey:@"userName"]]){
            return YES;
        }
    }
    return NO;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if(searchResult){
            return @"Search Results (Tap to include)";
        }else{
            return @"";
        }
    }else if(section == 1){
        return @"This Game";
    }else if(section == 2){
        if([[DataManager sharedInstance].myFriends count] > 0){
            return @"My Friends";
        }else{
            return @"";
        }
    }
    return @"";
    /*
    if(self.searchResult){
        if(section == 0){
            return @"Search Results (Tap to include)";
        }else if(section == 1){
            return @"Recent Players";
        }
        
    }
    
    return @"Recent Players";*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if(!searchResult){
            
            return 0;
            
        }
    }
    if(section == 2){
        if([[DataManager sharedInstance].myFriends count] == 0){
            return 0;
        }
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        if(searchResult){
            CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 30) title:@"Search Results (Tap to include)"];
            return header;
            
        }else{
            return nil;
        }
    }else if(section == 1){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 30) title:@"This Game"];
        return header;
    }else if(section == 2){
        if([[DataManager sharedInstance].myFriends count] > 0){
            CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 30) title:@"My Friends"];
            return header;
        }else{
            return nil;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        if(!searchResult){
            
            return nil;
            
        }
    }
    if(section == 2){
        if([[DataManager sharedInstance].myFriends count] == 0){
            return nil;
        }
    }
    CellFooterGeneral *footer = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, 320, 40) title:@""];
    return footer;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        if(!searchResult){
            
            return 0;
            
        }
    }
    if(section == 2){
        if([[DataManager sharedInstance].myFriends count] == 0){
            return 0;
        }
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(indexPath.section == 2){
        if([[DataManager sharedInstance].myFriends count] == 0){
            return 0;
        }
    }
    return 50;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 && searchResult){
        return 1;
    }else if(section == 1){
        NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
        NSMutableArray *players = [turnState objectForKey:@"players"];
        return [players count];
    }else if(section == 2){
        return [[DataManager sharedInstance].myFriends count];
    }
    return 0;
    
    /*if(self.searchResult){
        if(section == 0){
            return 1;
        }else if(section == 1){
            return 1;
        }
    }
    
    return 2;*/
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    NSMutableDictionary *results = [[DataManager sharedInstance] searhForUser:_searchBar.text];
    if([@"1" isEqualToString:[results objectForKey:@"success"]]){
        self.searchResult = results;
    }else{
        self.searchResult = nil;
    }
    [_tableView reloadData];
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
}



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
