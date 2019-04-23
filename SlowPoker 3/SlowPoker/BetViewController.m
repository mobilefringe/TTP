//
//  BetViewController.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BetViewController.h"
#import "TurnSectionHeader.h"
#import "DataManager.h"
#import "MFButton.h"
#import "AppDelegate.h"

@implementation BetViewController

@synthesize turnSectionHeader;
@synthesize hand;
@synthesize cardOne;
@synthesize cardTwo;
@synthesize raiseButton;
@synthesize checkCallButton;
@synthesize foldButton;
@synthesize raiseSlider;
@synthesize callValue;
@synthesize raiseValue;
@synthesize bugButton;
@synthesize decreaseBuyIn;
@synthesize increaseBuyIn;
@synthesize userStackLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_black2.png"]];
    [self.view addSubview:background];
    self.turnSectionHeader = [[TurnSectionHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    [self.view addSubview:turnSectionHeader];
    
    self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 35, 50)];
    [self.view addSubview:cardOne];
    self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 35, 50)];
    [self.view addSubview:cardTwo];
    
    
    int yoffset = -30;
    self.checkCallButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    checkCallButton.frame = CGRectMake(20, 196+yoffset, 280, 50);
    [checkCallButton setTitle:@"Check" forState:UIControlStateNormal];
    [checkCallButton addTarget:self action:@selector(pressCallCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkCallButton];
    
    self.foldButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    foldButton.frame = CGRectMake(20, 258+yoffset, 280, 50);
    [foldButton setTitle:@"Fold" forState:UIControlStateNormal];
    [foldButton addTarget:self action:@selector(pressFold) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foldButton];

    self.decreaseBuyIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    decreaseBuyIn.frame = CGRectMake(20, 325+yoffset, 40, 40);
    [decreaseBuyIn setTitle:@"-" forState:UIControlStateNormal];
    decreaseBuyIn.tag = 1;
    [decreaseBuyIn addTarget:self action:@selector(decreaseBuyIn) forControlEvents:UIControlEventTouchUpInside];
    decreaseBuyIn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:decreaseBuyIn];
    
    self.raiseButton = [MFButton buttonWithType:UIButtonTypeRoundedRect];
    raiseButton.frame = CGRectMake(70, 320+yoffset, 180, 50);
    [raiseButton setTitle:@"Raise -" forState:UIControlStateNormal];
    [raiseButton addTarget:self action:@selector(pressRaise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:raiseButton];
    
    self.increaseBuyIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    increaseBuyIn.frame = CGRectMake(260, 325+yoffset, 40, 40);
    [increaseBuyIn setTitle:@"+" forState:UIControlStateNormal];
    increaseBuyIn.tag = 4;
    [increaseBuyIn addTarget:self action:@selector(increaseBuyIn) forControlEvents:UIControlEventTouchUpInside];
    increaseBuyIn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:increaseBuyIn];
    
    self.raiseSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 385+yoffset, 280, 20)];
    [self.view addSubview:raiseSlider];
    [raiseSlider addTarget:self action:@selector(sliderValueChanged:) 
          forControlEvents:UIControlEventValueChanged];
    

    
    
        
    
    
        
    bugButton = [[UIBarButtonItem alloc] initWithTitle:@"Report Bug"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(reportBug)];
    
    self.navigationItem.rightBarButtonItem = bugButton;
    
    self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 416-30, 320, 30)];
    userStackLabel.textColor = [UIColor whiteColor];
    userStackLabel.font = [UIFont boldSystemFontOfSize:20];
    userStackLabel.textAlignment = UITextAlignmentCenter;
    userStackLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:userStackLabel];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [turnSectionHeader setHeaderData:self.hand];
    [cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[[DataManager sharedInstance].betRound objectForKey:@"cardOne"]]];
    [cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[[DataManager sharedInstance].betRound objectForKey:@"cardTwo"]]];
    
    
    //raiseSlider.value = 1.0;
    maxVal = [[[[DataManager sharedInstance] getPlayerStateCurrentTurnForCurrentGame] objectForKey:@"userStack"] doubleValue];
    userStackLabel.text = [NSString stringWithFormat:@"$%.2f",maxVal];
    raiseValue = [[DataManager sharedInstance] getMinRaiseValue];
    callValue = [[DataManager sharedInstance] getCallValue];
    if(callValue > maxVal){
        callValue = maxVal;
    }
    if(raiseValue > maxVal){
        raiseValue = maxVal;
    }
    //raiseValue = callValue;
    if(maxVal == callValue){
        raiseSlider.hidden = YES;
        raiseButton.hidden = YES;
        decreaseBuyIn.hidden = YES;
        increaseBuyIn.hidden = YES;
    }else{
        raiseSlider.hidden = NO;
        raiseButton.hidden = NO;
        decreaseBuyIn.hidden = NO;
        increaseBuyIn.hidden = NO;
    }
    
    if(maxVal - callValue < raiseValue){
        raiseValue = maxVal - callValue;
        raiseSlider.enabled = NO;
        decreaseBuyIn.enabled = NO;
        increaseBuyIn.enabled = NO;
        [raiseButton setTitle:[NSString stringWithFormat:@"All In $%.2f",raiseValue] forState:UIControlStateNormal];
    }else{
        raiseSlider.enabled = YES;
        decreaseBuyIn.enabled = YES;
        increaseBuyIn.enabled = YES;
        [raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
    }
    
    raiseSlider.maximumValue = maxVal-callValue;
    raiseSlider.minimumValue = raiseValue;
    raiseSlider.value = raiseSlider.minimumValue;
    
    if(callValue == 0){
        [checkCallButton setTitle:@"Check" forState:UIControlStateNormal];
    }else{
        if(callValue >= maxVal){
            [checkCallButton setTitle:[NSString stringWithFormat:@"Call $%.2f All In",callValue] forState:UIControlStateNormal];
        }else{
            [checkCallButton setTitle:[NSString stringWithFormat:@"Call $%.2f",callValue] forState:UIControlStateNormal];
        }
    }
}

-(void)pressRaise{
    [self doAction:@"raise" callAmount:callValue raiseAmount:raiseValue];
    
}

-(void)pressFold{
    [self doAction:@"fold" callAmount:0 raiseAmount:0];
}


-(void)pressCallCheck{
    if(callValue == 0){
        [self doAction:@"check"  callAmount:0 raiseAmount:0];
    }else{
        [self doAction:@"call"  callAmount:callValue raiseAmount:0];
    }
}


-(void)doAction:(NSString *)action callAmount:(double)callAmount raiseAmount:(double)raiseAmount{
    
    NSMutableDictionary *betRound = [[NSMutableDictionary alloc] init];
    [betRound setValue:action forKey:@"action"];
    [betRound setValue:[NSString stringWithFormat:@"%.2f",callAmount] forKey:@"callAmount"];
    [betRound setValue:[NSString stringWithFormat:@"%.2f",raiseAmount] forKey:@"raiseAmount"];
    [betRound setValue:[NSString stringWithFormat:@"%.2f",callAmount+raiseAmount] forKey:@"amount"];
    
    [[DataManager sharedInstance] postRound:betRound];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)sliderValueChanged:(UISlider *)sender
{
   
    double smallBlind = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    
    int multipier = sender.value/smallBlind;
    
    sender.value = multipier * smallBlind;
    if( (sender.value + callValue + 0.0001) >= maxVal){
        raiseValue = maxVal-callValue;
    }else{
        raiseValue = sender.value;
    }
    raiseSlider.value = raiseValue;
    if(raiseValue == raiseSlider.maximumValue){
        [raiseButton setTitle:[NSString stringWithFormat:@"All In $%.2f",raiseValue] forState:UIControlStateNormal];
    }else{
        [raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
    }
}

-(void)decreaseBuyIn{
    double smallBlind = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    if(raiseValue > raiseSlider.minimumValue){
        raiseValue = raiseValue - smallBlind;
    }
    raiseSlider.value = raiseValue;
    [raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
}

-(void)increaseBuyIn{
    double smallBlind = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    if(raiseValue < raiseSlider.maximumValue){
        raiseValue = raiseValue + smallBlind;
    }
    
    if(raiseValue > raiseSlider.maximumValue){
        raiseValue =  raiseSlider.maximumValue;
    }
    raiseSlider.value = raiseValue;
    if(raiseValue == raiseSlider.maximumValue){
        [raiseButton setTitle:[NSString stringWithFormat:@"All In $%.2f",raiseValue] forState:UIControlStateNormal];
    }else{
        [raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
    }
    
       
}

-(void)reportBug{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] emailBug:self];
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
