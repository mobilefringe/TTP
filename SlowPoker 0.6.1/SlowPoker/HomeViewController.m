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
    
    int ySpacing = 65;
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_black2.png"]];
    background.frame = CGRectMake(0, -80, 320, 500);
    [self.view addSubview:background];
    
    
    self.gamesButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    gamesButton.frame = CGRectMake(20, 20, 280, 50);
    [gamesButton addTarget:self action:@selector(pressMyGames) forControlEvents:UIControlEventTouchUpInside];
    [gamesButton setTitle:@"My Games" forState:UIControlStateNormal];
    [self.view addSubview:gamesButton];
    
    self.proPointsButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    proPointsButton.frame = CGRectMake(20, 20+ySpacing, 280, 50);
    [proPointsButton addTarget:self action:@selector(pressProChips) forControlEvents:UIControlEventTouchUpInside];
    [proPointsButton setTitle:@"Pro Chips" forState:UIControlStateNormal];
    [self.view addSubview:proPointsButton];
    
    self.statsButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    [statsButton addTarget:self action:@selector(pressMyFriends) forControlEvents:UIControlEventTouchUpInside];
    statsButton.frame = CGRectMake(20, 20+ySpacing*2, 280, 50);
    [statsButton setTitle:@"My Friends" forState:UIControlStateNormal];
    [self.view addSubview:statsButton];
    
    self.leaderBoardsButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    leaderBoardsButton.frame = CGRectMake(20, 20+ySpacing*4, 280, 50);
    [leaderBoardsButton setTitle:@"Leader Boards" forState:UIControlStateNormal];
    [leaderBoardsButton addTarget:self action:@selector(pressLeaderboards) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaderBoardsButton];
    
    self.profileButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    profileButton.frame = CGRectMake(20, 20+ySpacing*3, 280, 50);
    [profileButton setTitle:@"My Profile" forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(pressMyProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:profileButton];
    
    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logOutButton;
    
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(pressSettings)];
    self.navigationItem.rightBarButtonItem = settingButton;

    
    
    self.twitterButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    twitterButton.frame = CGRectMake(20, 20+ySpacing*5, 130, 50);
    [twitterButton addTarget:self action:@selector(pressTwitter) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setTitle:@"TTP Twitter" forState:UIControlStateNormal];
    [self.view addSubview:twitterButton];
    
    self.facebookButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    facebookButton.frame = CGRectMake(170, 20+ySpacing*5, 130, 50);
    [facebookButton addTarget:self action:@selector(pressFaceBook) forControlEvents:UIControlEventTouchUpInside];
    [facebookButton setTitle:@"TTP Facebook" forState:UIControlStateNormal];
    [self.view addSubview:facebookButton];
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
    if(!gamesViewController){
        self.gamesViewController = [[GamesViewController alloc] initWithNibName:nil bundle:nil];    
    }
    [self.navigationController pushViewController:gamesViewController animated:YES];
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
    [appDelegate goToWebViewControllerWithURL:@"http://www.mobilefringe.com" withTitle:@"Leaderboards TBD"];
    
}

-(void)pressTwitter{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate goToWebViewControllerWithURL:@"http://twitter.com/#!/Mobilefringe" withTitle:@"Twitter TBD"];
    
}

-(void)pressFaceBook{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate goToWebViewControllerWithURL:@"http://www.facebook.com" withTitle:@"Facebook TBD"];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [[DataManager sharedInstance] setProfileToMe];
    self.title = @"Home";
    //[profileButton setTitle:[NSString stringWithFormat:@"My Profile (%@ / %@)",[DataManager sharedInstance].myUserID,[DataManager sharedInstance].myUserName] forState:UIControlStateNormal];
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
