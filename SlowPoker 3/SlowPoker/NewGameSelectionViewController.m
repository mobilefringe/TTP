//
//  NewGameSelectionViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewGameSelectionViewController.h"
#import "GameSettingsViewController.h"
#import "DataManager.h"

@implementation NewGameSelectionViewController

@synthesize navController;
@synthesize gameSettingsViewController;
@synthesize _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Game Types";
        self.gameSettingsViewController = [[GameSettingsViewController alloc] initWithNibName:nil bundle:nil];
        
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
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 130;
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = barButton;
    
}

-(void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
	}
	
	
    if(indexPath.row == 0){
        cell.textLabel.text = @"Cash";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"Tournament";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"Arcade";
    }

    cell.detailTextLabel.text = @"Some marketing about each game";
    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *newGame = [[NSMutableDictionary alloc] init];
    [newGame setValue:@"pending" forKey:@"status"];
    [newGame setValue:[DataManager sharedInstance].myUserID forKey:@"nextActionForUserID"];
    [newGame setValue:[DataManager sharedInstance].myUserID forKey:@"gameOwnerID"];
    
    //temp until api raedy
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *dateString = [dateFormat stringFromDate:today];
    [dateFormat setDateFormat:@"yyyy-MM-ddTHH:mm:ss.SSSz"];
    [newGame setValue:dateString forKey:@"gameID"];
    NSMutableDictionary *gameSettings = [[NSMutableDictionary alloc] init];
    if(indexPath.row == 0){
        gameSettingsViewController.gameType = @"cash";
        [gameSettings setValue:gameSettingsViewController.gameType forKey:@"type"];
        [gameSettings setValue:@"0.25" forKey:@"smallBlind"];
        [gameSettings setValue:@"0.50" forKey:@"bigBlind"];
        [gameSettings setValue:@"20" forKey:@"numOfHands"];
        [gameSettings setValue:@"20" forKey:@"minBuy"];
        [gameSettings setValue:@"60" forKey:@"maxBuy"];
    }else if(indexPath.row == 1){
        gameSettingsViewController.gameType = @"tournament";
        [gameSettings setValue:gameSettingsViewController.gameType forKey:@"type"];
        [gameSettings setValue:@"10" forKey:@"smallBlind"];
        [gameSettings setValue:@"20" forKey:@"bigBlind"];
        [gameSettings setValue:@"20" forKey:@"numOfHands"];
    }else if(indexPath.row == 2){
        gameSettingsViewController.gameType = @"arcade";
        [gameSettings setValue:gameSettingsViewController.gameType forKey:@"type"];
        [gameSettings setValue:@"0.25" forKey:@"smallBlind"];
        [gameSettings setValue:@"0.50" forKey:@"bigBlind"];
        [gameSettings setValue:@"20" forKey:@"numOfHands"];
    }
    [newGame setValue:gameSettings forKey:@"gameSettings"];
    
    
    NSMutableDictionary *turnState = [[NSMutableDictionary alloc] init];
    NSMutableArray *players = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *playerMe = [[NSMutableDictionary alloc] init];
    [playerMe setValue:[DataManager sharedInstance].myUserID forKey:@"userID"];
    [playerMe setValue:[DataManager sharedInstance].myUserName forKey:@"userName"];
    [playerMe setValue:@"1" forKey:@"order"];
    [playerMe setValue:@"pending" forKey:@"status"];
    [players addObject:playerMe];
    
    [turnState setValue:players forKey:@"players"];
    [newGame setValue:turnState forKey:@"turnState"];
    
    gameSettingsViewController.game = newGame;
    [self.navigationController pushViewController:gameSettingsViewController animated:YES];
    
    return nil;
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
