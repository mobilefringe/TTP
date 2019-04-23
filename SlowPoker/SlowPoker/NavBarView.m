//
//  NavBarView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavBarView.h"
#import "ProChip.h"
#import "DataManager.h"
#import "Settings.h"

@implementation NavBarView

@synthesize backButton;
@synthesize header;
@synthesize slider;
@synthesize navTitle;
@synthesize proChip;
@synthesize backImageView;
@synthesize settingsButton;
@synthesize settingsIcon;
@synthesize gameDetailsView;
@synthesize cashImageView;
@synthesize tournamentImageView;
@synthesize cashImageView2;
@synthesize tournamentImageView2;
@synthesize titleLabel;
@synthesize subtitleLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
                
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(50, 0,230 , 40);
        [self addSubview:background];
        
        self.header = [[UILabel alloc] initWithFrame:CGRectMake(75, 13, 170, 30)];
        header.backgroundColor = [UIColor clearColor];
        header.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:24.0];//[UIFont boldSystemFontOfSize:23];
        header.textAlignment = UITextAlignmentCenter;
        header.text = @"TTP";
        header.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [self addSubview:header];
        
        self.gameDetailsView = [[UIView alloc] initWithFrame:CGRectMake(75, 10, 170, 30)];
        gameDetailsView.backgroundColor = [UIColor clearColor];
        [self addSubview:gameDetailsView];
        
        
        self.cashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 25, 25)];
        cashImageView.image = [UIImage imageNamed:@"icon_cashgame.png"];
        [gameDetailsView addSubview:cashImageView];
        
        self.tournamentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 25, 25)];
        tournamentImageView.image = [UIImage imageNamed:@"icon_tournament.png"];
        [gameDetailsView addSubview:tournamentImageView];
        
        self.cashImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(145, 2, 25, 25)];
        cashImageView2.image = [UIImage imageNamed:@"icon_cashgame.png"];
        [gameDetailsView addSubview:cashImageView2];
        
        self.tournamentImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(145, 2, 25, 25)];
        tournamentImageView2.image = [UIImage imageNamed:@"icon_tournament.png"];
        [gameDetailsView addSubview:tournamentImageView2];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 170, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:[Settings sharedInstance].header1Font size:15.0];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"Game 204";
        titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [gameDetailsView addSubview:titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 120, 15)];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.font = [UIFont  fontWithName:[Settings sharedInstance].header1Font size:11];
        subtitleLabel.textAlignment = UITextAlignmentCenter;
        subtitleLabel.text = @"Hand 23 of 50";
        subtitleLabel.minimumFontSize = 7;
        subtitleLabel.adjustsFontSizeToFitWidth = YES;
        subtitleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [gameDetailsView addSubview:subtitleLabel];

        
        sliderImage = [UIImage imageNamed:@"slider.png"];
        self.slider = [[UIImageView alloc] initWithFrame:CGRectMake(63, 10, sliderImage.size.width/2, sliderImage.size.height/2+3)];
        slider.userInteractionEnabled = YES;
        slider.image = sliderImage;
        [self addSubview:slider];
        
        
        UIImage *backgroundImage = [UIImage imageNamed:@"header_background.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        backgroundImageView.userInteractionEnabled = YES;
        backgroundImageView.image = backgroundImage;
        [self addSubview:backgroundImageView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backButtonImage = [UIImage imageNamed:@"back_button.png"];
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 35, 35)];
        backButton.showsTouchWhenHighlighted = YES;
        backImageView.image = backButtonImage;
        backImageView.userInteractionEnabled = YES;
        backButton.frame = CGRectMake(0, 0, 68, 43);
        backButton.backgroundColor = [UIColor clearColor];
        [self addSubview:backImageView];
        //[backButton setImage:backButtonImage forState:UIControlStateNormal];
        [self addSubview:backButton];
        
        self.settingsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 35, 35)];
        settingsIcon.image = [UIImage imageNamed:@"settings-icon2.png"];
        settingsIcon.userInteractionEnabled = YES;
        [self addSubview:settingsIcon];
        settingsIcon.alpha = 0;
        
        self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.showsTouchWhenHighlighted = YES;
        settingsButton.frame = CGRectMake(0, 0, 68, 43);
        settingsButton.backgroundColor = [UIColor clearColor];
        [self addSubview:settingsButton];
        settingsButton.alpha = 0;
        
        self.proChip = [[ProChip alloc] initWithFrame:CGRectMake(263, 3, 42, 42)];
        [self addSubview:proChip];
        
        
        
        
        
    }
    return self;
}



-(void)updateHeaderWithTitle:(NSString *)title showLeft:(BOOL)showLeft showRight:(BOOL)showRight{
    backButton.hidden = !showLeft;
    backImageView.hidden = !showLeft;
    proChip.hidden = !showRight;
    if([self.navTitle isEqualToString:title]){
        return;
    }
    self.navTitle = title;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:.4];
    
    slider.frame = CGRectMake(63, 10, sliderImage.size.width/2, sliderImage.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(openSlider)];
    [UIView commitAnimations];
}

-(void)openSlider{
    header.text = navTitle;
    if([header.text isEqualToString:@"GAME_DETAILS_KEY"]){
        gameDetailsView.hidden = NO;
        header.hidden = YES;
        titleLabel.text = [NSString stringWithFormat:@"Game %@",[DataManager sharedInstance].currentGameID];
        if([[DataManager sharedInstance] isCurrentGameTypeCash]){
            if([[DataManager sharedInstance].currentHand valueForKey:@"number"]){
                subtitleLabel.text = [NSString stringWithFormat:@"Hand %@ of %@",[[DataManager sharedInstance].currentHand valueForKey:@"number"],[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"numOfHands"]];
            }else{
                subtitleLabel.text = [NSString stringWithFormat:@"%@ Hand Max",[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"numOfHands"]];
            }
            
            cashImageView.hidden = NO;
            tournamentImageView.hidden = YES;
            cashImageView2.hidden = NO;
            tournamentImageView2.hidden = YES;
        }else{
            if(![[DataManager sharedInstance].currentHand valueForKey:@"number"]){
                subtitleLabel.text = [NSString stringWithFormat:@"2x Blinds Every %@ Hands",[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"numOfHands"]];
            }else{
                subtitleLabel.text = [NSString stringWithFormat:@"Hand %@ - 2x Blinds every %@",[[DataManager sharedInstance].currentHand valueForKey:@"number"],[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"numOfHands"]];
            }
            cashImageView.hidden = YES;
            tournamentImageView.hidden = NO;
            cashImageView2.hidden = YES;
            tournamentImageView2.hidden = NO;
        }
    }else{
        gameDetailsView.hidden = YES;
        header.hidden = NO;
    }
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:.4];
    
    slider.frame = CGRectMake(-163, 10, sliderImage.size.width/2, sliderImage.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)showSettings{
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    backButton.alpha = 0;
    backImageView.alpha = 0;
    settingsButton.alpha = 1;
    settingsIcon.alpha = 1;
    
    [UIView commitAnimations];
}

-(void)showBackButton{
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    backButton.alpha = 1;
    backImageView.alpha = 1;
    settingsButton.alpha = 0;
    settingsIcon.alpha = 0;
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
