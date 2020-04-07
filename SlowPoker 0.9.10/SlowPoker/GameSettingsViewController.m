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
#import "CellFooterGeneral.h"
#import "CellHeaderGeneral.h"
#import "Settings.h"
#import "Avatar.h"
#import "AppDelegate.h"
#import "UpdatingPopUp.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation GameSettingsViewController

@synthesize gameType;
@synthesize _tableView;
@synthesize game;
@synthesize invitePlayersViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
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
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0));

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks_background.png"]];
    background.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:background];
    
    
    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 70;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.frame = CGRectMake(0, topbarHeight, self.view.bounds.size.width, self.view.bounds.size.height-64);
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
    /*
    if([@"cash" isEqualToString:gameType]){
        self.title = @"Cash Game";
    }else if([@"tournament" isEqualToString:gameType]){
        self.title = @"Torunament";
    }else{
        self.title = @"Arcade Game";
    }*/
}

-(void)viewWillDisappear:(BOOL)animated{
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
    Avatar *avatar;
    UILabel *userName;
    UILabel *inviteLabel;
    
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, self.view.bounds.size.width, 70);
        [cell.contentView addSubview:background];
      
        UIImageView *backgroundSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general_2_selected.png"]];
        backgroundSelected.frame = CGRectMake(0, 0, self.view.bounds.size.width, 70);
        
        cell.selectedBackgroundView = backgroundSelected;
        
        
        settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 120, 20)];
        settingLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        settingLabel.font = [UIFont boldSystemFontOfSize:17];
        settingLabel.tag = 2;
        settingLabel.adjustsFontSizeToFitWidth = YES;
        settingLabel.minimumFontSize = 10;
        settingLabel.backgroundColor = [UIColor clearColor];
        settingLabel.textAlignment = UITextAlignmentCenter;
        [cell addSubview:settingLabel];
        
        settingValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 50)];
        settingValue.textColor = [UIColor whiteColor];
        settingValue.font = [UIFont boldSystemFontOfSize:22];
        settingValue.tag = 3;
        settingValue.adjustsFontSizeToFitWidth = YES;
        settingValue.minimumFontSize = 10;
        settingValue.backgroundColor = [UIColor clearColor];
        settingValue.textAlignment = UITextAlignmentCenter;
        [cell addSubview:settingValue];
        
        decreaseSmallBling = [UIButton buttonWithType:UIButtonTypeCustom];
        [decreaseSmallBling setImage:[UIImage imageNamed:@"blue_minus.png"] forState:UIControlStateNormal];
        decreaseSmallBling.frame = CGRectMake(20, 5, 70, 60);
        [decreaseSmallBling setTitle:@"-" forState:UIControlStateNormal];
        decreaseSmallBling.tag = 1;
        [decreaseSmallBling addTarget:self action:@selector(decreaseSmallBlind) forControlEvents:UIControlEventTouchUpInside];
        decreaseSmallBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:decreaseSmallBling];
        
        increaseSmallBling = [UIButton buttonWithType:UIButtonTypeCustom];
        increaseSmallBling.frame = CGRectMake(230, 5, 70, 60);
        [increaseSmallBling setImage:[UIImage imageNamed:@"blue_plus.png"] forState:UIControlStateNormal];
        [increaseSmallBling setTitle:@"+" forState:UIControlStateNormal];
        increaseSmallBling.tag = 4;
        [increaseSmallBling addTarget:self action:@selector(increaseSmallBlind) forControlEvents:UIControlEventTouchUpInside];
        increaseSmallBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:increaseSmallBling];
        
        //big blind
        decreaseBigBling = [UIButton buttonWithType:UIButtonTypeCustom];
        [decreaseBigBling setImage:[UIImage imageNamed:@"blue_minus.png"] forState:UIControlStateNormal];
        decreaseBigBling.frame = CGRectMake(20, 5, 70, 60);
        [decreaseBigBling setTitle:@"-" forState:UIControlStateNormal];
        decreaseBigBling.tag = 5;
        [decreaseBigBling addTarget:self action:@selector(decreaseBigBlind) forControlEvents:UIControlEventTouchUpInside];
        decreaseBigBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:decreaseBigBling];
        
        increaseBigBling = [UIButton buttonWithType:UIButtonTypeCustom];
        increaseBigBling.frame = CGRectMake(230, 5, 70, 60);
        [increaseBigBling setImage:[UIImage imageNamed:@"blue_plus.png"] forState:UIControlStateNormal];
        [increaseBigBling setTitle:@"+" forState:UIControlStateNormal];
        increaseBigBling.tag = 6;
        [increaseBigBling addTarget:self action:@selector(increaseBigBlind) forControlEvents:UIControlEventTouchUpInside];
        increaseBigBling.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:increaseBigBling];
        
        //number of hands
        //big blind
        decreaseNumOfHands = [UIButton buttonWithType:UIButtonTypeCustom];
        [decreaseNumOfHands setImage:[UIImage imageNamed:@"blue_minus.png"] forState:UIControlStateNormal];
        decreaseNumOfHands.frame = CGRectMake(20, 5, 70, 60);
        [decreaseNumOfHands setTitle:@"-" forState:UIControlStateNormal];
        decreaseNumOfHands.tag = 7;
        [decreaseNumOfHands addTarget:self action:@selector(decreaseNumOfHands) forControlEvents:UIControlEventTouchUpInside];
        decreaseNumOfHands.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:decreaseNumOfHands];
        
        increaseNumOfHands = [UIButton buttonWithType:UIButtonTypeCustom];
        increaseNumOfHands.frame = CGRectMake(230, 5, 70, 60);
        [increaseNumOfHands setImage:[UIImage imageNamed:@"blue_plus.png"] forState:UIControlStateNormal];
        [increaseNumOfHands setTitle:@"+" forState:UIControlStateNormal];
        increaseNumOfHands.tag = 8;
        [increaseNumOfHands addTarget:self action:@selector(increaseNumOfHands) forControlEvents:UIControlEventTouchUpInside];
        increaseNumOfHands.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [cell addSubview:increaseNumOfHands];
        
        avatar = [[Avatar alloc] initWithFrame:CGRectMake(17, 5, 60, 60 )];
        avatar.radius = 70;
        avatar.tag = 9;
        [cell addSubview:avatar];
        
        userName = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 200, 25)];
        userName.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        userName.font = [UIFont boldSystemFontOfSize:22];
        userName.tag = 10;
        userName.adjustsFontSizeToFitWidth = YES;
        userName.minimumFontSize = 10;
        userName.backgroundColor = [UIColor clearColor];
        userName.textAlignment = UITextAlignmentLeft;
        [cell addSubview:userName];
        
        inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 200, 20)];
        inviteLabel.textColor = [UIColor whiteColor];
        inviteLabel.font = [UIFont systemFontOfSize:17];
        inviteLabel.tag = 11;
        inviteLabel.adjustsFontSizeToFitWidth = YES;
        inviteLabel.minimumFontSize = 10;
        inviteLabel.backgroundColor = [UIColor clearColor];
        inviteLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:inviteLabel];
        
        
	}else {
        decreaseSmallBling = (MFButton *) [cell viewWithTag:1];
        settingLabel = (UILabel *) [cell viewWithTag:2];
        settingValue = (UILabel *) [cell viewWithTag:3];
        increaseSmallBling = (MFButton *) [cell viewWithTag:4];
        decreaseBigBling = (MFButton *) [cell viewWithTag:5];
        increaseBigBling = (MFButton *) [cell viewWithTag:6];
        decreaseNumOfHands = (MFButton *) [cell viewWithTag:7];
        increaseNumOfHands = (MFButton *) [cell viewWithTag:8];
        avatar = (Avatar *) [cell viewWithTag:9];
        userName = (UILabel *) [cell viewWithTag:10];
        inviteLabel = (UILabel *) [cell viewWithTag:11];
    }

	
    decreaseSmallBling.hidden = YES;
    increaseSmallBling.hidden = YES;
    settingLabel.hidden = YES;
    settingValue.hidden = YES;
    decreaseBigBling.hidden = YES;
    increaseBigBling.hidden = YES;
    decreaseNumOfHands.hidden = YES;
    increaseNumOfHands.hidden = YES;
    avatar.hidden = YES;
    cell.detailTextLabel.text = @"";
    userName.hidden = YES;
    inviteLabel.hidden = YES;
    
    if(indexPath.section == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
        settingLabel.hidden = NO;
        settingValue.hidden = NO;
        if(indexPath.row == 0){
            decreaseSmallBling.hidden = NO;
            increaseSmallBling.hidden = NO;
            settingLabel.text = @"Blinds Small/Big";
            settingValue.text = [NSString stringWithFormat:@"$%.2f / $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"bigBlind"] floatValue]];
        }else if(indexPath.row == 1){
            decreaseBigBling.hidden = NO;
            increaseBigBling.hidden = NO;
            if([@"cash" isEqualToString:gameType]){
                settingLabel.text = @"Buyin Min/Max";
                settingValue.text = [NSString stringWithFormat:@"$%.2f / $%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"minBuy"] floatValue],[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
            }else{
                settingLabel.text = @"Buyin";
                settingValue.text = [NSString stringWithFormat:@"$%.2f",[[[game objectForKey:@"gameSettings"] objectForKey:@"maxBuy"] floatValue]];
            }
        }else if(indexPath.row == 2){
            decreaseNumOfHands.hidden = NO;
            increaseNumOfHands.hidden = NO;
            if([@"cash" isEqualToString:gameType]){
                settingLabel.text = @"# of Hands";
                settingValue.text = [NSString stringWithFormat:@"%d",[[[game objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue]];
            }else{
                settingLabel.text = @"Blinds Double";
                settingValue.text = [NSString stringWithFormat:@"Every %d Hands",[[[game objectForKey:@"gameSettings"] objectForKey:@"numOfHands"] intValue]];
            }
            
        }
    
    }else if(indexPath.section == 1){
        NSMutableDictionary *player = [[[game objectForKey:@"turnState"] objectForKey:@"players"] objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        cell.textLabel.frame = CGRectMake(70, 15, 200, 30);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.frame = CGRectMake(70, 45, 200, 30);
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        avatar.hidden = NO;
        
        userName.hidden = NO;
        inviteLabel.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        inviteLabel.text = @"Press to invite players";
        [avatar loadAvatar:[player objectForKey:@"userID"]];
        if([[player objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
            userName.text = @"You";
        }else{
            userName.text = [player objectForKey:@"userName"];
        }
    }
    
    
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        invitePlayersViewController.game = game;
        invitePlayersViewController.isEditPlayers = NO;
        [self.navigationController pushViewController:invitePlayersViewController animated:YES];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) title:[NSString stringWithFormat:@"7 Players Maximum",[[DataManager sharedInstance].yourTurnGames count]]];
        return header;
    }else if(section == 0){
        if([@"cash" isEqualToString:gameType]){
            CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 40) title:[NSString stringWithFormat:@"%d Hands Maximum",[Settings maxHandsCash]]];
            return header;

            
        }else if([@"tournament" isEqualToString:gameType]){
            CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 40) title:[NSString stringWithFormat:@"%d Hands Maximum",[Settings maxHandsTournament]]];
            return header;

        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
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
        if([[[game objectForKey:@"gameSettings"] objectForKey:@"type"] isEqualToString:@"cash"]){
            maxBuy = 3*minBuy;
        }else{
            maxBuy = minBuy;
        }
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
    if([[[game objectForKey:@"gameSettings"] objectForKey:@"type"] isEqualToString:@"cash"]){
        maxBuy = 3*minBuy;
    }else{
        maxBuy = minBuy;
    }
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
    if([[[game objectForKey:@"gameSettings"] objectForKey:@"type"] isEqualToString:@"cash"]){
        maxBuy = 3*minBuy;
    }else{
        maxBuy = minBuy;
    }
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
    int maxHands;
    if([@"cash" isEqualToString:gameType]){
        maxHands = [Settings maxHandsCash];
    }else if([@"tournament" isEqualToString:gameType]){
        maxHands = [Settings maxHandsTournament];
    }
    if(numOfHands > maxHands){
        numOfHands = maxHands;
    }
    [[game objectForKey:@"gameSettings"] setValue:[NSString stringWithFormat:@"%d",numOfHands] forKey:@"numOfHands"];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        int numOfPlayers = [[[game valueForKey:@"turnState"] valueForKey:@"players"] count];
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:[NSString stringWithFormat:@"%d Players",numOfPlayers]];
        return header;
    }else if(section == 0){
        if([@"cash" isEqualToString:gameType]){
            CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"Cash Game Settings"];
            return header;
            
        }else if([@"tournament" isEqualToString:gameType]){
            CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"Tournament Game Settings"];
            return header;
        }
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30) title:@"Their Turn"];
        return header;
    }
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
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
