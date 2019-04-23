//
//  GameSettingsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "MFButton.h"
#import "DataManager.h"
#import "GamesViewController.h"
#import "InvitePlayersViewController.h"

@implementation GameSettingsViewController

@synthesize gameType;
@synthesize _tableView;
@synthesize game;
@synthesize invitePlayersViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Game Settings";
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
    _tableView.rowHeight = 70;
    _tableView.frame = CGRectMake(0, 0, 320, 416);
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Game"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(createGame)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.invitePlayersViewController = [[InvitePlayersViewController alloc] initWithNibName:nil bundle:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
    if([@"cash" isEqualToString:gameType]){
        self.title = @"Cash Game";
    }else if([@"tournament" isEqualToString:gameType]){
        self.title = @"Torunament";
    }else{
        self.title = @"Arcade Game";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    MFButton *decreaseSmallBling;
    UILabel *settingLabel;
    UILabel *settingValue;
    MFButton *increaseSmallBling;
    MFButton *decreaseBigBling;
    MFButton *increaseBigBling;
    MFButton *increaseNumOfHands;
    MFButton *decreaseNumOfHands;
    
    
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        
        settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 120, 20)];
        settingLabel.textColor = [UIColor grayColor];
        settingLabel.font = [UIFont systemFontOfSize:17];
        settingLabel.tag = 2;
        settingLabel.adjustsFontSizeToFitWidth = YES;
        settingLabel.minimumFontSize = 10;
        settingLabel.backgroundColor = [UIColor clearColor];
        settingLabel.textAlignment = UITextAlignmentCenter;
        [cell addSubview:settingLabel];
        
        settingValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 50)];
        settingValue.textColor = [UIColor blackColor];
        settingValue.font = [UIFont boldSystemFontOfSize:22];
        settingValue.tag = 3;
        settingValue.adjustsFontSizeToFitWidth = YES;
        settingValue.minimumFontSize = 10;
        settingValue.backgroundColor = [UIColor clearColor];
        settingValue.textAlignment = UITextAlignmentCenter;
        [cell addSubview:settingValue];
        
        decreaseSmallBling = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        decreaseSmallBling.frame = CGRectMake(20, 13, 75, 47);
        [decreaseSmallBling setTitle:@"-" forState:UIControlStateNormal];
        decreaseSmallBling.tag = 1;
        [decreaseSmallBling addTarget:self action:@selector(decreaseSmallBlind) forControlEvents:UIControlEventTouchUpInside];
        decreaseSmallBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:decreaseSmallBling];
        
        increaseSmallBling = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        increaseSmallBling.frame = CGRectMake(225, 13, 75, 47);
        [increaseSmallBling setTitle:@"+" forState:UIControlStateNormal];
        increaseSmallBling.tag = 4;
        [increaseSmallBling addTarget:self action:@selector(increaseSmallBlind) forControlEvents:UIControlEventTouchUpInside];
        increaseSmallBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:increaseSmallBling];
        
        //big blind
        decreaseBigBling = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        decreaseBigBling.frame = CGRectMake(20, 13, 75, 47);
        [decreaseBigBling setTitle:@"-" forState:UIControlStateNormal];
        decreaseBigBling.tag = 5;
        [decreaseBigBling addTarget:self action:@selector(decreaseBigBlind) forControlEvents:UIControlEventTouchUpInside];
        decreaseBigBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:decreaseBigBling];
        
        increaseBigBling = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        increaseBigBling.frame = CGRectMake(225, 13, 75, 47);
        [increaseBigBling setTitle:@"+" forState:UIControlStateNormal];
        increaseBigBling.tag = 6;
        [increaseBigBling addTarget:self action:@selector(increaseBigBlind) forControlEvents:UIControlEventTouchUpInside];
        increaseBigBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:increaseBigBling];
        
        //number of hands
        //big blind
        decreaseNumOfHands = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        decreaseNumOfHands.frame = CGRectMake(20, 13, 75, 47);
        [decreaseNumOfHands setTitle:@"-" forState:UIControlStateNormal];
        decreaseNumOfHands.tag = 7;
        [decreaseNumOfHands addTarget:self action:@selector(decreaseNumOfHands) forControlEvents:UIControlEventTouchUpInside];
        decreaseNumOfHands.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:decreaseNumOfHands];
        
        increaseNumOfHands = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        increaseNumOfHands.frame = CGRectMake(225, 13, 75, 47);
        [increaseNumOfHands setTitle:@"+" forState:UIControlStateNormal];
        increaseNumOfHands.tag = 8;
        [increaseNumOfHands addTarget:self action:@selector(increaseNumOfHands) forControlEvents:UIControlEventTouchUpInside];
        increaseNumOfHands.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:increaseNumOfHands];
        
        
	}else {
        decreaseSmallBling = (MFButton *) [cell viewWithTag:1];
        settingLabel = (UILabel *) [cell viewWithTag:2];
        settingValue = (UILabel *) [cell viewWithTag:3];
        increaseSmallBling = (MFButton *) [cell viewWithTag:4];
        decreaseBigBling = (MFButton *) [cell viewWithTag:5];
        increaseBigBling = (MFButton *) [cell viewWithTag:6];
        decreaseNumOfHands = (MFButton *) [cell viewWithTag:7];
        increaseNumOfHands = (MFButton *) [cell viewWithTag:8];
    }

	
    decreaseSmallBling.hidden = YES;
    increaseSmallBling.hidden = YES;
    settingLabel.hidden = YES;
    settingValue.hidden = YES;
    decreaseBigBling.hidden = YES;
    increaseBigBling.hidden = YES;
    decreaseNumOfHands.hidden = YES;
    increaseNumOfHands.hidden = YES;
    cell.detailTextLabel.text = @"";
    if(indexPath.section == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
        settingLabel.hidden = NO;
        settingValue.hidden = NO;
        if(indexPath.section == 0 && indexPath.row == 0){
            decreaseSmallBling.hidden = NO;
            increaseSmallBling.hidden = NO;
            settingLabel.text = @"Blinds Small/Big";
            settingValue.text = [NSString stringWithFormat:@"$%.2f / $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] floatValue]];
        }else if(indexPath.section == 0 && indexPath.row == 1){
            decreaseBigBling.hidden = NO;
            increaseBigBling.hidden = NO;
            settingLabel.text = @"Buyin Min/Max";
            settingValue.text = [NSString stringWithFormat:@"$%.2f / $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
        }else if(indexPath.section == 0 && indexPath.row == 2){
            decreaseNumOfHands.hidden = NO;
            increaseNumOfHands.hidden = NO;
            settingLabel.text = @"# of Hands";
            settingValue.text = [NSString stringWithFormat:@"%d",[[[game objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue]];
        }
    
    }else if(indexPath.section == 1){
        NSMutableDictionary *player = [[[game objectForKey:@"turnState"] objectForKey:@"players"] objectAtIndex:indexPath.row];
        if([[player objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            cell.textLabel.text = @"You";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"Press to invite other players";
        }else{
            cell.textLabel.text = [player objectForKey:@"userName"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        NSMutableDictionary *player = [[[game objectForKey:@"turnState"] objectForKey:@"players"] objectAtIndex:indexPath.row];
        if([[player objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            invitePlayersViewController.game = game;
            invitePlayersViewController.isEditPlayers = NO;
            [self.navigationController pushViewController:invitePlayersViewController animated:YES];
        }
    }
    return nil;
}



-(void)decreaseSmallBlind{
    double smallBlind = [[[game objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    
    
    if(smallBlind > 0.25){
        smallBlind = smallBlind - 0.25;
    }else if(smallBlind > 0.05){
        smallBlind = smallBlind - 0.05;
    }else if(smallBlind > 0.01){
        smallBlind = smallBlind - 0.01;
    }else{
        smallBlind = 0.01;
    }
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",smallBlind] forKey:@"smallBlind"];
    
    
    double bigBlind = [[[game objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] floatValue];
    bigBlind = 2*smallBlind;
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",bigBlind] forKey:@"bigBlind"];
    
    
    [_tableView reloadData];
}

-(void)increaseSmallBlind{
    double smallBlind = [[[game objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    
    
    if(smallBlind >= 0.25){
        smallBlind = smallBlind + 0.25;
    }else if(smallBlind >= 0.05){
        smallBlind = smallBlind + 0.05;
    }else if(smallBlind >= 0.01){
        smallBlind = smallBlind + 0.01;
    }
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",smallBlind] forKey:@"smallBlind"];
    
    
    double bigBlind = [[[game objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] floatValue];
    bigBlind = 2*smallBlind;
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",bigBlind] forKey:@"bigBlind"];
    
    double minBuy = [[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
    if(smallBlind > minBuy){
        minBuy = smallBlind;
        [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",minBuy] forKey:@"minBuy"];
        
        double maxBuy = [[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
        maxBuy = 3*minBuy;
        [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",maxBuy] forKey:@"maxBuy"];

    }
    
    
    [_tableView reloadData];
}

-(void)decreaseBigBlind{
    double minBuy = [[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
    
    double smallBlind = [[[game objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    
    if(minBuy > smallBlind){
        if(minBuy > 0.25){
            minBuy = minBuy - 0.25;
        }else if(minBuy > 0.05){
            minBuy = minBuy - 0.05;
        }else if(minBuy > 0.01){
            minBuy = minBuy - 0.01;
        }else{
            minBuy = 0.01;
        }
    }else{
        minBuy = smallBlind;
    }
    
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",minBuy] forKey:@"minBuy"];
    
    double maxBuy = [[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue];
    maxBuy = 3*minBuy;
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",maxBuy] forKey:@"maxBuy"];
    
    
    [_tableView reloadData];
}

-(void)increaseBigBlind{
    double minBuy = [[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] doubleValue];
    
    if(minBuy >= 0.25){
        minBuy = minBuy + 0.25;
    }else if(minBuy >= 0.05){
        minBuy = minBuy + 0.05;
    }else if(minBuy >= 0.01){
        minBuy = minBuy + 0.01;
    }    
    
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",minBuy] forKey:@"minBuy"];
    
    double maxBuy = [[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] doubleValue];
    maxBuy = 3*minBuy;
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%.2f",maxBuy] forKey:@"maxBuy"];
    [_tableView reloadData];
}

-(void)decreaseNumOfHands{
    int numOfHands = [[[game objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue];
    numOfHands = numOfHands - 1;
    if(numOfHands == 0){
        numOfHands = 1;
    }
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%d",numOfHands] forKey:@"numOfHands"];
    [_tableView reloadData];
}

-(void)increaseNumOfHands{
    int numOfHands = [[[game objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue];
    numOfHands = numOfHands + 1;
    if(numOfHands > 100){
        numOfHands = 100;
    }
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%d",numOfHands] forKey:@"numOfHands"];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if([@"cash" isEqualToString:gameType]){
            return @"Cash Game Setting";
        }else if([@"tournament" isEqualToString:gameType]){
            return @"Tournament Game Setting";
        }else{
            return @"Arcade Game Settings";
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
