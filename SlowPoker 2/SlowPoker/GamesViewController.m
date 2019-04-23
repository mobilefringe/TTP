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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    [[DataManager sharedInstance] addObserver:self forKeyPath:@"gamesUpdated" options:NSKeyValueObservingOptionOld context:nil];
    
    
    self.turnsViewController = [[TurnsViewController alloc] initWithNibName:nil bundle:nil];
    self.theNewGameSelectionViewController = [[NewGameSelectionViewController alloc] initWithNibName:nil bundle:nil];
    self.gameDetailsViewController = [[GameDetailsViewController alloc] initWithNibName:nil bundle:nil];
    return self;
}

-(void)loadView{
    [super loadView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_black.png"]];
    [self.view addSubview:background];
    
    
    
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 85;
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    [self.view addSubview:_tableView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake(270, 3, 40, 40);
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self.view addSubview:activityIndicatorView];
    
    
    
    
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
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:theNewGameSelectionViewController];
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = @"My Games";//[DataManager sharedInstance].myUserName;
    if(refreshTimer){
        [refreshTimer invalidate];
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadGames) userInfo:nil repeats:YES];
    [refreshTimer fire];
    
    _tableView.alpha = 0;
    [activityIndicatorView startAnimating];
}


-(void)loadGames{
    [[DataManager sharedInstance] loadUserGames];
    [activityIndicatorView startAnimating];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [activityIndicatorView stopAnimating];
    [_tableView reloadData];
    if(_tableView.alpha == 0){
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        _tableView.alpha = 1;
        [UIView commitAnimations];
    }
    self.title = @"My Games";
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
    
    [cell setCellData:game];
    
    
    
   
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [[DataManager sharedInstance].yourTurnGames count];
    }if(section == 1){
        return [[DataManager sharedInstance].theirTurnGames count];
    }else if(section == 2){
        return [[DataManager sharedInstance].completedGames count];
    }
    return 0;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *game;
    if(indexPath.section == 0){
        //your turn games
        game = [[DataManager sharedInstance].yourTurnGames objectAtIndex:indexPath.row];
        [DataManager sharedInstance].currentTurnUserID = [DataManager sharedInstance].myUserID;
        [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[DataManager sharedInstance].myUserID game:game] objectForKey:@"userName"];
    }else if(indexPath.section == 1){
        //your turn games
        game = [[DataManager sharedInstance].theirTurnGames objectAtIndex:indexPath.row];
        [DataManager sharedInstance].currentTurnUserID = [game objectForKey:@"nextActionForUserID"];
        [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[game objectForKey:@"nextActionForUserID"] game:game] objectForKey:@"userName"];
    }else if(indexPath.section == 2){
        //completed games
        game = [[DataManager sharedInstance].completedGames objectAtIndex:indexPath.row];
        [DataManager sharedInstance].currentTurnUserID = [game objectForKey:@"nextActionForUserID"];
        [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[game objectForKey:@"nextActionForUserID"] game:game] objectForKey:@"userName"];
    }
    
    [DataManager sharedInstance].currentTurnUserID = [DataManager sharedInstance].myUserID;
    [DataManager sharedInstance].currentTurnUserName = [[[DataManager sharedInstance] getPlayerForID:[DataManager sharedInstance].myUserID game:game] objectForKey:@"userName"];
    
    [DataManager sharedInstance].currentGameID = [game objectForKey:@"gameID"];
    
    [self.navigationController pushViewController:turnsViewController animated:YES];

    return nil;
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
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        if(indexPath.section == 0){
            //your turn games
            self.deleteGame = [[DataManager sharedInstance].yourTurnGames objectAtIndex:indexPath.row];
            
        }else if(indexPath.section == 1){
            //your turn games
            self.deleteGame = [[DataManager sharedInstance].theirTurnGames objectAtIndex:indexPath.row];
           
        }else if(indexPath.section == 2){
            //completed games
            self.deleteGame = [[DataManager sharedInstance].completedGames objectAtIndex:indexPath.row];
        }
        if(!deleteGameAlert){
            self.deleteGameAlert = [[UIAlertView alloc] initWithTitle:@"Delete Game?" message:@"Are you sure you want to delete this game? You hand will be folded and you will be removed from the game" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        }
        [deleteGameAlert show];
    }    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == deleteGameAlert){
        [[DataManager sharedInstance] deleteGame:deleteGame];
        [self loadGames];
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
