//
//  InfoViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-09-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "AppDelegate.h"
#import "Settings.h"


@implementation InfoViewController

@synthesize scrollView;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    background.frame = CGRectMake(0, -20, 320, [UIImage imageNamed:@"home_background.png"].size.height/2);
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        background.frame = CGRectMake(0, 0, 320, [UIImage imageNamed:@"home_background.png"].size.height/2+69);
        
    }
    [self.view addSubview:background];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, 320, 350)];
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        scrollView.frame = CGRectMake(0, 110+55, 320, 350);
    }
    scrollView.contentSize = CGSizeMake(320*3, 330);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(50, 102, 217, 20)];
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f){
        pageControl.frame = CGRectMake(50, 102+415, 217, 20);
    }
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 50)];
    title1.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    title1.textAlignment = UITextAlignmentCenter;
    title1.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:40.0];
    title1.adjustsFontSizeToFitWidth = YES;
    title1.minimumFontSize = 9;
    title1.backgroundColor = [UIColor clearColor];
    title1.text = @"Welcome!";
    [self.scrollView addSubview:title1];
    
    UILabel *description1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 48, 280, 200)];
    description1.textColor = [UIColor whiteColor];
    description1.textAlignment = UITextAlignmentCenter;
    description1.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:14.0];
    description1.adjustsFontSizeToFitWidth = YES;
    description1.numberOfLines = 12;
    description1.minimumFontSize = 9;
    description1.backgroundColor = [UIColor clearColor];
    description1.text = @"TTP is like no other poker game. With TTP the players dictate the pace of the game, fast or slow. TTP's turn based gameplay gives you a poker experience like no other. PUSH NOTIFICATIONS play a HUGE role in this game by letting you know when it's your turn, if someone raised, folded or called you ALL IN! Make sure Push Notifications are ENABLED so you can get the edge on your friends!!";
    [self.scrollView addSubview:description1];
    
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 245, 103, 100)];
    image1.image = [UIImage imageNamed:@"ttp_icon_push.png"];
    [scrollView addSubview:image1];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20+320, 0, 280, 50)];
    title2.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    title2.textAlignment = UITextAlignmentCenter;
    title2.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:40.0];
    title2.adjustsFontSizeToFitWidth = YES;
    title2.minimumFontSize = 9;
    title2.backgroundColor = [UIColor clearColor];
    title2.text = @"Play with Friends!";
    [self.scrollView addSubview:title2];
    
    UILabel *description2 = [[UILabel alloc] initWithFrame:CGRectMake(10+320, 30, 300, 220)];
    description2.textColor = [UIColor whiteColor];
    description2.textAlignment = UITextAlignmentCenter;
    description2.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:14.0];
    description2.adjustsFontSizeToFitWidth = YES;
    description2.numberOfLines = 12;
    description2.minimumFontSize = 9;
    description2.backgroundColor = [UIColor clearColor];
    description2.text = @"TTP is at its best when played with friends. TTP is the perfect addition to your home or office game. With TTP you can continue playing all week and trash talk along the way with in-game chat. Whether you're playing for fun, or for higher stakes, TTP makes playing with your buddies easy and fun.  Signup with Facebook & get 100 FREE ProChips to get the upper hand on your friends with ProStats and more.";
    [self.scrollView addSubview:description2];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(30+320, 240, 260, 110)];
    image2.image = [UIImage imageNamed:@"register_with_facebook.png"];
    [scrollView addSubview:image2];
    
    
    UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectMake(20+320+320, 3, 280, 50)];
    title3.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    title3.textAlignment = UITextAlignmentCenter;
    title3.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:40.0];
    title3.adjustsFontSizeToFitWidth = YES;
    title3.minimumFontSize = 9;
    title3.backgroundColor = [UIColor clearColor];
    title3.text = @"Poker Bracelets";
    [self.scrollView addSubview:title3];
    
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(70+320+320, 30, 180, 115)];
    image3.image = [UIImage imageNamed:@"bracelets-platinum.png"];
    [scrollView addSubview:image3];
    
    UILabel *description3 = [[UILabel alloc] initWithFrame:CGRectMake(10+320+320, 90, 300, 220)];
    description3.textColor = [UIColor whiteColor];
    description3.textAlignment = UITextAlignmentCenter;
    description3.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:13.0];
    description3.adjustsFontSizeToFitWidth = YES;
    description3.numberOfLines = 12;
    description3.minimumFontSize = 9;
    description3.backgroundColor = [UIColor clearColor];
    description3.text = @"Want bragging rights amongst your friends? Check out player profiles in the 'My Friends' section.  See who has the most bracelets and the best stats. Bracelets are earned or purchased with game achievements. TTP 'Pro Stats' tracks all your hands and provides you killer insight to know which players are aggressive, or loose.  See who folds the most and measure your game against your friends.";
    [self.scrollView addSubview:description3];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80+320+320, 285, 160, 60);
    [button setImage:[UIImage imageNamed:@"blue_wide.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    
    UILabel *title4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, button.frame.size.width-10, 45)];
    title4.textColor = [UIColor whiteColor];
    title4.textAlignment = UITextAlignmentCenter;
    title4.font = [UIFont boldSystemFontOfSize:23];
    title4.adjustsFontSizeToFitWidth = YES;
    title4.minimumFontSize = 9;
    title4.backgroundColor = [UIColor clearColor];
    title4.text = @"Let's Play!!!";
    [button addSubview:title4];

    
    
}

-(void)close{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate closeInfo];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
