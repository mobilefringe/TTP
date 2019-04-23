//
//  MyFriendsViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "MyFriendsTableCellCell.h"
#import "CellFooterGeneral.h"
#import "CellHeaderGeneral.h"

@implementation MyFriendsViewController

@synthesize _tableView;
@synthesize needsReload;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Friends";
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"profileStatues" options:NSKeyValueObservingOptionOld context:nil];
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
    
    self._tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.rowHeight = 70;
    [self.view addSubview:_tableView];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicatorView.frame = CGRectMake(150, 170, 20, 20);
	activityIndicatorView.hidesWhenStopped = YES;
	[activityIndicatorView stopAnimating];
	[self.view addSubview:activityIndicatorView];
    
      
}

-(void)viewWillAppear:(BOOL)animated{
    [FlurryAnalytics logEvent:@"PAGE_VIEW_MY_FRIENDS" timed:YES];
    needsReload = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"My Friends"];
    if(needsReload){
        _tableView.alpha = 0;
        [activityIndicatorView startAnimating];
        [[DataManager sharedInstance] loadPlayerStatuses];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [FlurryAnalytics endTimedEvent:@"PAGE_VIEW_MY_FRIENDS" withParameters:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"profileStatues"]){
        //NSLog(@"playerProfile:%@",[DataManager sharedInstance].playerProfile);
        [activityIndicatorView stopAnimating];
        [_tableView reloadData];        [_tableView reloadData];
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        _tableView.alpha = 1;
        [UIView commitAnimations];
        needsReload = NO;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier
	MyFriendsTableCellCell *cell = (MyFriendsTableCellCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[MyFriendsTableCellCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }  
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.isFacebookInstructions = NO;
    cell.isContactsInstructions = NO;
    cell.isEmailInstructions = NO;
    NSMutableDictionary *playerData;
    
    if(indexPath.row == [[DataManager sharedInstance].myFriends count]){
        cell.isFacebookInstructions = YES;
        [cell setProfileData:nil];
    }else if(indexPath.row -1 == [[DataManager sharedInstance].myFriends count]){
        cell.isContactsInstructions = YES;
        [cell setProfileData:nil];
    }else if(indexPath.row -2 == [[DataManager sharedInstance].myFriends count]){
        cell.isEmailInstructions = YES;
        [cell setProfileData:nil];
    }else{
        playerData = [[DataManager sharedInstance].myFriends objectAtIndex:indexPath.row];
    }
    
    for (NSMutableDictionary *player in [DataManager sharedInstance].profileStatues) {
        //NSLog(@"player:%@",player);
        if([[player valueForKey:@"userID"] isEqualToString:[playerData valueForKey:@"userID"]]){
            [playerData addEntriesFromDictionary:player];
        }
    }
    //NSLog(@"playerData:%@",playerData);
    [cell setProfileData:playerData];
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row == [[DataManager sharedInstance].myFriends count]){
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //if (![appDel.facebook isSessionValid]) {
            NSArray *permissions = [[NSArray alloc] initWithObjects:
                                    @"user_about_me", 
                                    @"email",
                                    nil];
            [appDel.facebook authorize:permissions];
        //}
    }else{
        NSMutableDictionary *playerData;
        playerData = [[DataManager sharedInstance].myFriends objectAtIndex:indexPath.row];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate pushToPlayersProfile:[playerData valueForKey:@"userID"]];
    }
    
    
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if([[DataManager sharedInstance].favPlayers count] > 0){
            return @"My Friends";
        }else{
            return @"";
        }
    }    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        CellHeaderGeneral *header = [[CellHeaderGeneral alloc] initWithFrame:CGRectMake(0, 0, 320, 30) title:@"My Friends"];
        return header;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [[DataManager sharedInstance].myFriends count]+1;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    CellFooterGeneral *header = [[CellFooterGeneral alloc] initWithFrame:CGRectMake(0, -10, 320, 40) title:@""];
    return header;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 40;
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
