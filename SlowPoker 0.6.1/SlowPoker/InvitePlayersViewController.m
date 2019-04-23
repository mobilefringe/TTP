//
//  InvitePlayersViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvitePlayersViewController.h"
#import "DataManager.h"

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
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    searchBar.placeholder = @"Search by username or email";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.frame = CGRectMake(0, 50, 320, 416-50);
    [self.view addSubview:_tableView];
    
    self.barButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Game"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(createGame)];
    

}

-(void)viewWillAppear:(BOOL)animated{
    if(isEditPlayers){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = barButton;
    }
    self.searchResult = nil;
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }  
    
    NSMutableDictionary *playerData;
    if(indexPath.section == 0){
        playerData = searchResult;
    }else if(indexPath.section == 1){
        NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
        NSMutableArray *players = [turnState objectForKey:@"players"];
        playerData = [players objectAtIndex:indexPath.row];
    }else if(indexPath.section == 2){
        playerData = [[DataManager sharedInstance].favPlayers objectAtIndex:indexPath.row];
    }else if(indexPath.section == 3){
        playerData = [[DataManager sharedInstance].recentPlayers objectAtIndex:indexPath.row];
    }
	
    if([self hasPlayerBeenInvited:playerData]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //NSLog(@"playerData:%@",playerData);
    //NSLog(@"[DataManager sharedInstance].myUserID:%@",[DataManager sharedInstance].myUserID);
    if([[playerData objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        cell.textLabel.text = @"You";
    }else{
        cell.textLabel.text = [playerData objectForKey:@"userName"];
    }
    
    
    
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
        playerData = [[DataManager sharedInstance].favPlayers objectAtIndex:indexPath.row];
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
        [[DataManager sharedInstance] createNewGame:game];
        [self dismissModalViewControllerAnimated:YES];
        [self.navigationController.parentViewController viewWillAppear:YES];
    }else{
        UIAlertView *notEnoughPlayersAlert = [[UIAlertView alloc] initWithTitle:@"More Players Needed" message:@"At least 2 players are needed to create a game. Please invite more players to begin the game" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [notEnoughPlayersAlert show];
        
    }
}


-(void)addPlayerToGame:(NSMutableDictionary *)addPlayer{
    
    
    NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
    NSMutableArray *players = [turnState objectForKey:@"players"];
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
    return 4;
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
        if([[DataManager sharedInstance].favPlayers count] > 0){
            return @"My Friends";
        }else{
            return @"";
        }
    }else if(section == 3){
        if([[DataManager sharedInstance].recentPlayers count] > 0){
            return @"Recent Players";
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 && searchResult){
        return 1;
    }else if(section == 1){
        NSMutableDictionary *turnState = [game objectForKey:@"turnState"];
        NSMutableArray *players = [turnState objectForKey:@"players"];
        return [players count];
    }else if(section == 2){
        return [[DataManager sharedInstance].favPlayers count];
    }else if(section == 3){
        return [[DataManager sharedInstance].recentPlayers count];
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
