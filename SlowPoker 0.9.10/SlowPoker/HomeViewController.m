//
//  HomeViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "MFButton.h"
#import "GamesViewController.h"
#import "DataManager.h"
#import "HandEvaluatorViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "MyFriendsViewController.h"
#import "SettingsViewController.h"
#import "ProChipsViewController.h"
#import "NavBarView.h"
#import "UpdatingPopUp.h"

@implementation HomeViewController

@synthesize gamesButton;
@synthesize proPointsButton;
@synthesize statsButton;
@synthesize leaderBoardsButton;
@synthesize profileButton;
@synthesize gamesViewController;
@synthesize userLabel;
@synthesize handEvaluatorViewController;
@synthesize myFriendsViewController;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize settingsViewController;
@synthesize proChipsViewController;
@synthesize proChipsTotal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    BOOL hasNotchedDisplay = [[DataManager sharedInstance] hasNotchedDisplay];
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0)) + 10;
    
    int marginLeft = 20;
    int buttonWidth = self.view.bounds.size.width - (marginLeft*2);
    
    int ySpacing = 65;
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    background.frame = CGRectMake(0, topbarHeight-10, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:background];
    
    
    float xCenterView = (self.view.bounds.size.width-[UIImage imageNamed:@"card_dispenser_back.png"].size.width/2+9)/2;
    UIImageView *background2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_dispenser_back.png"]];
    background2.frame = CGRectMake(xCenterView, topbarHeight, [UIImage imageNamed:@"card_dispenser_back.png"].size.width/2+9, [UIImage imageNamed:@"card_dispenser_back.png"].size.height/2);
    [self.view addSubview:background2];
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height)];
    scroll.backgroundColor = [UIColor clearColor];
    NSLog(@"%f", self.view.bounds.size.height);
    scroll.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height);
    [self.view addSubview:scroll];
    
    self.twitterButton = [MFButton buttonWithType:UIButtonTypeCustom];
    twitterButton.frame = CGRectMake(xCenterView, hasNotchedDisplay ? topbarHeight+284+51-10 : topbarHeight+284+51-20, [UIImage imageNamed:@"home_twitter_button.png"].size.width/2, [UIImage imageNamed:@"home_twitter_button.png"].size.height/2);
    [twitterButton addTarget:self action:@selector(pressTwitter) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setTitle:@"TTP Twitter" forState:UIControlStateNormal];
    [twitterButton setImage:[UIImage imageNamed:@"home_twitter_button.png"] forState:UIControlStateNormal];
    [scroll addSubview:twitterButton];
    
    UILabel *twitterLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, 170, 50)];
    twitterLabel.backgroundColor = [UIColor clearColor];
    twitterLabel.font = [UIFont boldSystemFontOfSize:25];
    twitterLabel.textAlignment = UITextAlignmentLeft;
    twitterLabel.text = @"Twitter";
    twitterLabel.textColor = [UIColor whiteColor];
    [twitterButton addSubview:twitterLabel];
    
    
    self.leaderBoardsButton = [MFButton buttonWithType:UIButtonTypeCustom];
    leaderBoardsButton.frame = CGRectMake(xCenterView, hasNotchedDisplay ? topbarHeight+284-20 : topbarHeight+284-30, [UIImage imageNamed:@"home_leader_board_button.png"].size.width/2, [UIImage imageNamed:@"home_leader_board_button.png"].size.height/2);
    [leaderBoardsButton setTitle:@"Leader Boards" forState:UIControlStateNormal];
    [leaderBoardsButton addTarget:self action:@selector(pressLeaderboards) forControlEvents:UIControlEventTouchUpInside];
    [leaderBoardsButton setImage:[UIImage imageNamed:@"home_leader_board_button.png"] forState:UIControlStateNormal];
    [scroll addSubview:leaderBoardsButton];
    
    UILabel *leaderboardLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, 170, 50)];
    leaderboardLabel.backgroundColor = [UIColor clearColor];
    leaderboardLabel.font = [UIFont boldSystemFontOfSize:25];
    leaderboardLabel.textAlignment = UITextAlignmentLeft;
    leaderboardLabel.text = @"Leaderboards";
    leaderboardLabel.textColor = [UIColor whiteColor];
    [leaderBoardsButton addSubview:leaderboardLabel];
    
    self.profileButton = [MFButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame = CGRectMake(xCenterView, hasNotchedDisplay ? topbarHeight+223-20 : topbarHeight+223-30, [UIImage imageNamed:@"home_my_profile_button.png"].size.width/2, [UIImage imageNamed:@"home_my_profile_button.png"].size.height/2);
    [profileButton setTitle:@"My Profile" forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(pressMyProfile) forControlEvents:UIControlEventTouchUpInside];
    [profileButton setImage:[UIImage imageNamed:@"home_my_profile_button.png"] forState:UIControlStateNormal];
    [scroll addSubview:profileButton];
    
    UILabel *myProfileLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, 170, 50)];
    myProfileLabel.backgroundColor = [UIColor clearColor];
    myProfileLabel.font = [UIFont boldSystemFontOfSize:25];
    myProfileLabel.textAlignment = UITextAlignmentLeft;
    myProfileLabel.text = @"My Stats";
    myProfileLabel.textColor = [UIColor whiteColor];
    [profileButton addSubview:myProfileLabel];
    
    self.statsButton = [MFButton buttonWithType:UIButtonTypeCustom];
    [statsButton addTarget:self action:@selector(pressMyFriends) forControlEvents:UIControlEventTouchUpInside];
    statsButton.frame = CGRectMake(xCenterView, hasNotchedDisplay ? topbarHeight+ 162-20 : topbarHeight+ 162-30, [UIImage imageNamed:@"home_my_friends_button.png"].size.width/2, [UIImage imageNamed:@"home_my_friends_button.png"].size.height/2);
    [statsButton setTitle:@"My Friends" forState:UIControlStateNormal];
    [statsButton setImage:[UIImage imageNamed:@"home_my_friends_button.png"] forState:UIControlStateNormal];
    [scroll addSubview:statsButton];
    
    UILabel *myFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, 170, 50)];
    myFriendsLabel.backgroundColor = [UIColor clearColor];
    myFriendsLabel.font = [UIFont boldSystemFontOfSize:25];
    myFriendsLabel.textAlignment = UITextAlignmentLeft;
    myFriendsLabel.text = @"My Friends";
    myFriendsLabel.textColor = [UIColor whiteColor];
    [statsButton addSubview:myFriendsLabel];
    
    
    
    self.proPointsButton = [MFButton buttonWithType:UIButtonTypeCustom];
    proPointsButton.frame = CGRectMake(xCenterView, hasNotchedDisplay ? topbarHeight+101-20 : topbarHeight+101-30, [UIImage imageNamed:@"home_pro_chips_button.png"].size.width/2, [UIImage imageNamed:@"home_pro_chips_button.png"].size.height/2);
    [proPointsButton addTarget:self action:@selector(pressProChips) forControlEvents:UIControlEventTouchUpInside];
    [proPointsButton setTitle:@"Pro Chips" forState:UIControlStateNormal];
    [proPointsButton setImage:[UIImage imageNamed:@"home_pro_chips_button.png"] forState:UIControlStateNormal];
    [scroll addSubview:proPointsButton];
    
    UILabel *proPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, 170, 50)];
    proPointsLabel.backgroundColor = [UIColor clearColor];
    proPointsLabel.font = [UIFont boldSystemFontOfSize:25];
    proPointsLabel.textAlignment = UITextAlignmentLeft;
    proPointsLabel.text = @"Pro Chips";
    proPointsLabel.textColor = [UIColor whiteColor];
    [proPointsButton addSubview:proPointsLabel];
    
    self.proChipsTotal = [[UILabel alloc] initWithFrame:CGRectMake(205, 139, 22, 15)];
    proChipsTotal.backgroundColor = [UIColor clearColor];
    proChipsTotal.font = [UIFont boldSystemFontOfSize:12];
    proChipsTotal.adjustsFontSizeToFitWidth = YES;
    proChipsTotal.minimumFontSize = 9;
    proChipsTotal.textAlignment = UITextAlignmentCenter;
    proChipsTotal.text = @"123";
    proChipsTotal.textColor = [UIColor blackColor];
    [proPointsButton addSubview:proChipsTotal];
    
    
    
    
    self.gamesButton = [MFButton buttonWithType:UIButtonTypeCustom];
    gamesButton.frame = CGRectMake(xCenterView, hasNotchedDisplay ? topbarHeight + 20 : topbarHeight+10, [UIImage imageNamed:@"my_games_button.png"].size.width/2, [UIImage imageNamed:@"my_games_button.png"].size.height/2);
    [gamesButton addTarget:self action:@selector(pressMyGames) forControlEvents:UIControlEventTouchUpInside];
    //[gamesButton setTitle:@"My Games" forState:UIControlStateNormal];
    [gamesButton setImage:[UIImage imageNamed:@"my_games_button.png"] forState:UIControlStateNormal];
    [scroll addSubview:gamesButton];
    
    
    UILabel *gamesButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, 170, 50)];
    gamesButtonLabel.backgroundColor = [UIColor clearColor];
    gamesButtonLabel.font = [UIFont boldSystemFontOfSize:25];
    gamesButtonLabel.textAlignment = UITextAlignmentLeft;
    gamesButtonLabel.text = @"Play Games!!";
    gamesButtonLabel.textColor = [UIColor whiteColor];
    [gamesButton addSubview:gamesButtonLabel];
    
    float xIconCenterView = (self.view.bounds.size.width - [UIImage imageNamed:@"card_holder.png"].size.width/2 +9)/2;
    UIImageView *iconBig = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_holder.png"]];
    
    iconBig.frame = CGRectMake(xIconCenterView, hasNotchedDisplay ? 50 : 22, [UIImage imageNamed:@"card_holder.png"].size.width/2 +9, [UIImage imageNamed:@"card_holder.png"].size.height/2);
    [self.view addSubview:iconBig];

}

-(void)logout{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressSettings{
    if(!settingsViewController){
        self.settingsViewController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)pressMyGames{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:appDelegate.gamesViewController animated:YES];
}

-(void)pressProChips{
    if(!proChipsViewController){
        self.proChipsViewController = [[ProChipsViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:proChipsViewController animated:YES];
}

-(void)pressMyFriends{
    if(!myFriendsViewController){
        self.myFriendsViewController = [[MyFriendsViewController alloc] initWithNibName:nil bundle:nil];
    }
    myFriendsViewController.needsReload = YES;
    [self.navigationController pushViewController:myFriendsViewController animated:YES];

    
}

-(void)pressMyProfile{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate pushToPlayersProfile:[DataManager sharedInstance].myUserID];
}

-(void)pressLeaderboards{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *urlString = [NSString stringWithFormat:@"%@/leaderboards",(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiURL"]];

    [appDelegate goToWebViewControllerWithURL:urlString withTitle:@"Leaderboards"];
    
}

-(void)pressTwitter{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate goToWebViewControllerWithURL:@"https://twitter.com/texasturnpoker" withTitle:@"Twitter"];
}

-(void)pressFaceBook{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate goToWebViewControllerWithURL:@"http://www.facebook.com/TexasTurnPoker" withTitle:@"Facebook"];
}



-(void)viewWillAppear:(BOOL)animated{
    [scroll setContentOffset:CGPointMake(0, 400) animated:NO];
    //scroll.frame = CGRectMake(0, 0, 320, 0);
    [[DataManager sharedInstance] setProfileToMe];
    self.title = @"Home";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:@"TTP Home"];
    [appDelegate.navBar showSettings];
    [appDelegate.navBar.settingsButton addTarget:self action:@selector(pressSettings) forControlEvents:UIControlEventTouchUpInside];
    proChipsTotal.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getMyProChips]];
    
    
}



-(void)viewDidAppear:(BOOL)animated{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [scroll flashScrollIndicators];
    /*
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:.5];
    scroll.frame = CGRectMake(0, 0, 320, 417);
    [UIView commitAnimations];*/
}

-(void)viewWillDisappear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate updateHeaderWithTitle:@"Home"];
    [appDelegate.navBar showBackButton];
    
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
