//
//  GameDetailsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameDetailsViewController.h"
#import "MFButton.h"
#import "DataManager.h"
#import "InvitePlayersViewController.h"

@implementation GameDetailsViewController

@synthesize game;
@synthesize _tableView;
@synthesize invitePlayersViewController;
@synthesize activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Details";
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"gameDetailsUpdates" options:NSKeyValueObservingOptionOld context:nil];
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
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(140, 70, 40, 40);
    //[self.view addSubview:activityIndicatorView];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self.view addSubview:activityIndicatorView];    

    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - [[DataManager sharedInstance] getBottomPadding]);
    [self.view addSubview:_tableView];
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Players"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(editPlayers)];
    self.navigationItem.rightBarButtonItem = barButton;
     
    self.invitePlayersViewController = [[InvitePlayersViewController alloc] initWithNibName:nil bundle:nil];
}

-(void)editPlayers{
    invitePlayersViewController.game = game;
    invitePlayersViewController.isEditPlayers = YES;
    [self.navigationController pushViewController:invitePlayersViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    _tableView.alpha = 0;
    [[DataManager sharedInstance] loadGameDetails:[game valueForKey:@"gameID"]];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    game = [DataManager sharedInstance].currentGame;
    self.title = [NSString stringWithFormat:@"Game# %@",[game valueForKey:@"gameID"]];
    if([keyPath isEqualToString:@"gameDetailsUpdates"]){
        [activityIndicatorView stopAnimating];
        [_tableView reloadData];
        if(_tableView.alpha == 0){
            [UIView beginAnimations:@"" context:NULL];
            [UIView setAnimationDuration:0.3];
            _tableView.alpha = 1;
            [UIView commitAnimations];
        }
    }
}

-(void)createGame{
    [[DataManager sharedInstance] createNewGame:game];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController.parentViewController viewWillAppear:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
    
	// If no cell is available, create a new one using the given identifier
    if(indexPath.section == 0){
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        }  
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if(indexPath.section == 0 && indexPath.row == 0){
            cell.textLabel.text = @"Blinds";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f / $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] floatValue]];
        }else if(indexPath.section == 0 && indexPath.row == 1){
            cell.textLabel.text = @"Buy In";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f / $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
        }else if(indexPath.section == 0 && indexPath.row == 2){
            cell.textLabel.text = @"Hand";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d of %d",[[[game valueForKey:@"gameState"] valueForKey:@"hands"] count],[[[game objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue]];
        }
    }else if(indexPath.section == 1){
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        } 
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSMutableDictionary *gameSummary = [[game valueForKey:@"gameState"] valueForKey:@"gameSummary"];
        NSLog(@"game:%@",game);
        NSMutableDictionary *player = [[[game objectForKey:@"turnState"] objectForKey:@"players"] objectAtIndex:indexPath.row];
        double playerTotal = 0;
        if([@"buyin" isEqualToString:[player objectForKey:@"status"]]){
            playerTotal =  (-1.0)*[[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue];
        }else{
            playerTotal = [[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue] - [[gameSummary valueForKey:[player valueForKey:@"userID"]] doubleValue];
        }
        
        cell.textLabel.text = @"";
        if([[player objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            cell.textLabel.text = @"You";
        }else{
            cell.textLabel.text = [player objectForKey:@"userName"];
        }
        if([[game valueForKey:@"gameOwnerID"] isEqualToString:[player objectForKey:@"userID"]]){
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" (owner)"];
        }
        
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ $%.2f", NSLocalizedString([player objectForKey:@"status"],nil),playerTotal,nil];
        if([@"pending" isEqualToString:[player objectForKey:@"status"]] || [@"sitout" isEqualToString:[player objectForKey:@"status"]]){
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.7 green:.5 blue:0 alpha:1];
            if(playerTotal != 0){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ $%.2f", NSLocalizedString([player objectForKey:@"status"],nil),playerTotal,nil];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString([player objectForKey:@"status"],nil),nil];
            }
        }else if([@"buyin" isEqualToString:[player objectForKey:@"status"]]){
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.2 green:.2 blue:1 alpha:1];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (for $%.2f) $%.2f", NSLocalizedString([player objectForKey:@"status"],nil),[[[player valueForKey:@"playerState"] valueForKey:@"userStack"] doubleValue],playerTotal,nil];
            
        }else if([@"pending" isEqualToString:[player objectForKey:@"status"]]){
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.7 green:.5 blue:0 alpha:1];
            
        }else{
            if(playerTotal > 0){
                cell.detailTextLabel.textColor = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
            }else if(playerTotal < 0){
                cell.detailTextLabel.textColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
            }
        }
        
        
    }
    
    
    return cell;
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if([@"cash" isEqualToString:[[game objectForKey:@"gameSettings"] objectForKey:@"gameType"]]){
            return [NSString stringWithFormat:@"Cash Game (%@)",NSLocalizedString([game objectForKey:@"status"],nil)]; 
        }else if([@"tournament" isEqualToString:[[game objectForKey:@"gameSettings"] objectForKey:@"gameType"]]){
            return [NSString stringWithFormat:@"Cash Game (%@)",NSLocalizedString([game objectForKey:@"status"],nil)];
        }else{
            return [NSString stringWithFormat:@"Cash Game (%@)",NSLocalizedString([game objectForKey:@"status"],nil)];
        }
        
    }else{
        int numOfPlayers = [[[game valueForKey:@"turnState"] valueForKey:@"players"] count];
        return [NSString stringWithFormat:@"%d Players",numOfPlayers];
    }
    return nil;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3;
    }else if(section == 1){
        return [(NSMutableArray *)[[game objectForKey:@"turnState"] objectForKey:@"players"] count];
    }
    return 0;
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
