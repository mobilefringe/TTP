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

@implementation HomeViewController

@synthesize gamesButton;
@synthesize proPointsButton;
@synthesize statsButton;
@synthesize leaderBoardsButton;
@synthesize profileButton;
@synthesize gamesViewController;
@synthesize userLabel;
@synthesize handEvaluatorViewController;

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
    
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
    (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    
    int ySpacing = 70;
    
    [[DataManager sharedInstance] setImageBackground:self.view imageName:@"background_black2.png" topbarHeight:topbarHeight];
    
    self.gamesButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    
    int buttonWidth = 280;
    int xCenterView = (self.view.bounds.size.width-buttonWidth)/2;
    
    gamesButton.frame = CGRectMake(xCenterView, topbarHeight+40, buttonWidth, 50);
    [gamesButton addTarget:self action:@selector(pressMyGames) forControlEvents:UIControlEventTouchUpInside];
    [gamesButton setTitle:@"My Games" forState:UIControlStateNormal];
    [gamesButton.titleLabel setTextAlignment:NSTextAlignmentCenter];

    [self.view addSubview:gamesButton];
    
    self.proPointsButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    proPointsButton.frame = CGRectMake(xCenterView, topbarHeight+40+ySpacing, buttonWidth, 50);
    [proPointsButton addTarget:self action:@selector(pressHandEval) forControlEvents:UIControlEventTouchUpInside];
    [proPointsButton setTitle:@"Hand Evaluator" forState:UIControlStateNormal];
    [self.view addSubview:proPointsButton];
    
    self.statsButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    statsButton.frame = CGRectMake(xCenterView, topbarHeight+40+ySpacing*2, buttonWidth, 50);
    [statsButton setTitle:@"My Win / Loss" forState:UIControlStateNormal];
    [self.view addSubview:statsButton];
    
    self.leaderBoardsButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    leaderBoardsButton.frame = CGRectMake(xCenterView, topbarHeight+40+ySpacing*3, buttonWidth, 50);
    [leaderBoardsButton setTitle:@"Leader Boards" forState:UIControlStateNormal];
    [self.view addSubview:leaderBoardsButton];
    
    self.profileButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    profileButton.frame = CGRectMake(xCenterView, topbarHeight+40+ySpacing*4, buttonWidth, 50);
    [profileButton setTitle:@"My Profile" forState:UIControlStateNormal];
    [self.view addSubview:profileButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = barButton;
            
}

-(void)logout{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressMyGames{
    if(!gamesViewController){
        self.gamesViewController = [[GamesViewController alloc] initWithNibName:nil bundle:nil];    
    }
    [self.navigationController pushViewController:gamesViewController animated:YES];
}

-(void)pressHandEval{
    if(!handEvaluatorViewController){
        self.handEvaluatorViewController = [[HandEvaluatorViewController alloc] initWithNibName:nil bundle:nil];
    }
    [handEvaluatorViewController resetHands];
    [self.navigationController pushViewController:handEvaluatorViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [profileButton setTitle:[NSString stringWithFormat:@"My Profile (%@ / %@)",[DataManager sharedInstance].myUserID,[DataManager sharedInstance].myUserName] forState:UIControlStateNormal];
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
