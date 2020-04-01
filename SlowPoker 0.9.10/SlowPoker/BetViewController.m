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
#import "Avatar.h"
#import "UpdatingPopUp.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

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
@synthesize communityCardOne;
@synthesize communityCardTwo;
@synthesize communityCardThree;
@synthesize communityCardFour;
@synthesize communityCardFive;
@synthesize potLabel;
@synthesize avatar;
@synthesize dealerButton;
@synthesize chipImageView;
@synthesize greenChip;
@synthesize redChip;
@synthesize yellowChip;
@synthesize foldLabel;
@synthesize callLabel;
@synthesize raiseLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bet_view_background.png"]];
    background.frame = CGRectMake(0, 0, 320, 456);
    [self.view addSubview:background];
    self.turnSectionHeader = [[TurnSectionHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    //[self.view addSubview:turnSectionHeader];
    
    self.potLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 320, 20)];
    potLabel.textAlignment = UITextAlignmentCenter;
    potLabel.font = [UIFont boldSystemFontOfSize:18];
    potLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    potLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:potLabel];

    
    int xOffset = 60;
    self.communityCardOne = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 35*1.5, 49*1.5)];
    [self.view addSubview:communityCardOne];
    
    self.communityCardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(15+xOffset, 35, 35*1.5, 49*1.5)];
    [self.view addSubview:communityCardTwo];
    
    self.communityCardThree = [[UIImageView alloc] initWithFrame:CGRectMake(15+xOffset*2, 35, 35*1.5, 49*1.5)];
    [self.view addSubview:communityCardThree];
    
    self.communityCardFour = [[UIImageView alloc] initWithFrame:CGRectMake(15+xOffset*3, 35, 35*1.5, 49*1.5)];
    [self.view addSubview:communityCardFour];
    
    self.communityCardFive = [[UIImageView alloc] initWithFrame:CGRectMake(15+xOffset*4, 35, 35*1.5, 49*1.5)];
    [self.view addSubview:communityCardFive];



    
    self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(105, 320, 35*1.5, 50*1.5)];
    [self.view addSubview:cardOne];
    self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(165, 320, 35*1.5, 50*1.5)];
    [self.view addSubview:cardTwo];
    
    
    
    
    int yoffset = -100;
    
    self.foldButton = [MFButton buttonWithType:UIButtonTypeCustom];
    foldButton.frame = CGRectMake(20, 258+yoffset, 135, 50);
    [foldButton setTitle:@"Fold" forState:UIControlStateNormal];
    [foldButton setImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
    //[foldButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1]];
    [foldButton addTarget:self action:@selector(pressFold) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foldButton];
    
    self.foldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, 50)];
    foldLabel.font = [UIFont boldSystemFontOfSize:18];
    foldLabel.text = @"Fold";
    foldLabel.textAlignment = UITextAlignmentCenter;
    foldLabel.backgroundColor = [UIColor clearColor];
    foldLabel.textColor = [UIColor whiteColor];
    foldLabel.adjustsFontSizeToFitWidth = YES;
    foldLabel.minimumFontSize = 12;
    [foldButton addSubview:foldLabel];
    
    self.checkCallButton = [MFButton buttonWithType:UIButtonTypeCustom];
    checkCallButton.frame = CGRectMake(165, 258+yoffset, 135, 49);
    [checkCallButton setImage:[UIImage imageNamed:@"gray_button.png"] forState:UIControlStateNormal];
    [checkCallButton setTitle:@"Check" forState:UIControlStateNormal];
    //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
    [checkCallButton addTarget:self action:@selector(pressCallCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkCallButton];
    
    self.callLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 115, 49)];
    callLabel.font = [UIFont boldSystemFontOfSize:18];
    callLabel.textAlignment = UITextAlignmentCenter;
    callLabel.backgroundColor = [UIColor clearColor];
    callLabel.textColor = [UIColor whiteColor];
    callLabel.adjustsFontSizeToFitWidth = YES;
    callLabel.minimumFontSize = 12;
    [checkCallButton addSubview:callLabel];
    
    

    self.decreaseBuyIn = [UIButton buttonWithType:UIButtonTypeCustom];
    decreaseBuyIn.frame = CGRectMake(20, 325+yoffset, 40, 40);
    //[decreaseBuyIn setTitle:@"-" forState:UIControlStateNormal];
    [decreaseBuyIn setImage:[UIImage imageNamed:@"blue_minus.png"] forState:UIControlStateNormal];
    decreaseBuyIn.tag = 1;
    [decreaseBuyIn addTarget:self action:@selector(decreaseBuyIn) forControlEvents:UIControlEventTouchUpInside];
    decreaseBuyIn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:decreaseBuyIn];
    
    self.raiseButton = [MFButton buttonWithType:UIButtonTypeCustom];
    raiseButton.frame = CGRectMake(70, 320+yoffset, 180, 50);
    [raiseButton setTitle:@"Raise -" forState:UIControlStateNormal];
    [raiseButton setImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
    //[raiseButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:1]];
    [raiseButton addTarget:self action:@selector(pressRaise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:raiseButton];
    
    self.raiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 160, 50)];
    raiseLabel.font = [UIFont boldSystemFontOfSize:18];
    raiseLabel.adjustsFontSizeToFitWidth = YES;
    raiseLabel.minimumFontSize = 12;
    raiseLabel.textAlignment = UITextAlignmentCenter;
    raiseLabel.backgroundColor = [UIColor clearColor];
    raiseLabel.textColor = [UIColor whiteColor];
    [raiseButton addSubview:raiseLabel];
    

    self.increaseBuyIn = [UIButton buttonWithType:UIButtonTypeCustom];
    increaseBuyIn.frame = CGRectMake(260, 325+yoffset, 40, 40);
    //[increaseBuyIn setTitle:@"+" forState:UIControlStateNormal];
    increaseBuyIn.tag = 4;
    [increaseBuyIn setImage:[UIImage imageNamed:@"blue_plus.png"] forState:UIControlStateNormal];
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
    
    
    
    
    UIImage *userBar = [UIImage imageNamed:@"bet_cell_background.png"];
    UIImageView *userBarView = [[UIImageView alloc] initWithImage:userBar];
    userBarView.frame = CGRectMake(0, 344, userBar.size.width/2, userBar.size.height/2);
    userBarView.userInteractionEnabled = YES;
    [self.view addSubview:userBarView];
    
    self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 280, 30)];
    userStackLabel.textColor = [UIColor blackColor];
    userStackLabel.font = [UIFont boldSystemFontOfSize:21];
    userStackLabel.textAlignment = UITextAlignmentRight;
    userStackLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [userBarView addSubview:userStackLabel];
    
    self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(9, 7, 56, 56)];
    avatar.radius = 150;
    [userBarView addSubview:avatar];
    
    self.dealerButton = [[UIImageView alloc] initWithFrame:CGRectMake(248, 330, 40, 40)];
    [dealerButton setImage:[UIImage imageNamed:@"dealer_button.png"]];
    [self.view addSubview:dealerButton];
    
    self.greenChip = [UIImage imageNamed:@"green_chip.png"];
    self.yellowChip = [UIImage imageNamed:@"yellow_chip.png"];
    self.redChip = [UIImage imageNamed:@"red_chip.png"];
    self.chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(283, 39, 32, 32)];
    chipImageView.image = yellowChip;
    [userBarView addSubview:chipImageView];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateHeaderWithTitle:[NSString stringWithFormat:@"Hand #%@",[[DataManager sharedInstance].currentHand valueForKey:@"number"]]];
    
    [avatar loadAvatar:[DataManager sharedInstance].myUserID];
    //self.title = [NSString stringWithFormat:@"Hand #%@",[[DataManager sharedInstance].currentHand valueForKey:@"number"]];
    NSMutableArray *communityCards = [self.hand objectForKey:@"communityCards"];
    
    
    int chipState = [[DataManager sharedInstance] getChipStackState:[DataManager sharedInstance].myUserID];
        
    if(chipState == 1){
        chipImageView.image = greenChip;
    }else if(chipState == 2){
        chipImageView.image = yellowChip;
    }else if(chipState == 3){
        chipImageView.image = redChip;
    }
    
    potLabel.text = [NSString stringWithFormat:@"Pot $%@",[self.hand objectForKey:@"potSize"]];
    int state = [[self.hand objectForKey:@"state"] intValue];
    if(state > 1){
        [self.communityCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:0]]];
        [self.communityCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:1]]];
        [self.communityCardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:2]]];
        
    }else{
        [self.communityCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.communityCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.communityCardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if(state > 2){
        [self.communityCardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:3]]];
    }else{
        [self.communityCardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if(state > 3){
        [self.communityCardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:4]]];
    }else{
        [self.communityCardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }

    [cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[[DataManager sharedInstance].betRound objectForKey:@"cardOne"]]];
    [cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[[DataManager sharedInstance].betRound objectForKey:@"cardTwo"]]];
    
    
    //raiseSlider.value = 1.0;
    maxVal = [[[[DataManager sharedInstance] getPlayerStateCurrentTurnForCurrentGame] objectForKey:@"userStack"] doubleValue];
    userStackLabel.text = [NSString stringWithFormat:@"%.2f",maxVal];
    raiseValue = [[DataManager sharedInstance] getMinRaiseValue];
    callValue = [[DataManager sharedInstance] getCallValue];
    //NSLog(@"maxVal:%.2f raiseValue:%.2f callValue:%.2f",maxVal,raiseValue,callValue);
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
    
    NSString *raiseString = @"";
    int numberOfRaises = [[DataManager sharedInstance] getNumberOfRaisesforCurrentRound];
    if(numberOfRaises==0){
        raiseString = @"Bet";
    }else if(numberOfRaises == 1){
        raiseString = @"Raise";
    }else{
        raiseString = @"Reraise";
    }

    
    if(maxVal - callValue < raiseValue){
        raiseValue = maxVal - callValue;
        raiseSlider.enabled = NO;
        decreaseBuyIn.enabled = NO;
        increaseBuyIn.enabled = NO;
        raiseLabel.text = [NSString stringWithFormat:@"All In $%.2f",raiseValue];
       // [raiseButton setTitle:[NSString stringWithFormat:@"All In $%.2f",raiseValue] forState:UIControlStateNormal];
    }else{
        raiseSlider.enabled = YES;
        decreaseBuyIn.enabled = YES;
        increaseBuyIn.enabled = YES;
        [raiseButton setTitle:[NSString stringWithFormat:@"%@ $%.2f",raiseString,raiseValue] forState:UIControlStateNormal];
        raiseLabel.text = [NSString stringWithFormat:@"%@ $%.2f",raiseString,raiseValue];
    }
    
    raiseSlider.maximumValue = maxVal-callValue;
    raiseSlider.minimumValue = raiseValue;
    raiseSlider.value = raiseSlider.minimumValue;
    
    if(callValue == 0){
        callLabel.text = @"Check";
        [checkCallButton setTitle:@"Check" forState:UIControlStateNormal];
    }else{
        if(callValue >= maxVal){
            callLabel.text = [NSString stringWithFormat:@"Call $%.2f All In",callValue];
            //[checkCallButton setTitle:[NSString stringWithFormat:@"Call $%.2f All In",callValue] forState:UIControlStateNormal];
        }else{
            callLabel.text = [NSString stringWithFormat:@"Call $%.2f",callValue];
            //[checkCallButton setTitle:[NSString stringWithFormat:@"Call $%.2f",callValue] forState:UIControlStateNormal];
        }
    }
    
    if([[[[DataManager sharedInstance] getPlayerStateCurrentTurnForCurrentGame] valueForKey:@"isDealer"] isEqualToString:@"YES"]){
        dealerButton.hidden = NO;
    }else{
        dealerButton.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
}


-(void)pressRaise{
    int numberOfRaises = [[DataManager sharedInstance] getNumberOfRaisesforCurrentRound];
    if(numberOfRaises==0){
        [self doAction:@"bet" callAmount:callValue raiseAmount:raiseValue];
    }else if(numberOfRaises == 1){
        [self doAction:@"raise" callAmount:callValue raiseAmount:raiseValue];
    }else{
        [self doAction:@"reraise" callAmount:callValue raiseAmount:raiseValue];
    }    
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.updatingPopUp showWithMessage:@"Posting move"];
    dispatch_async(kBgQueue, ^{
        NSMutableDictionary *betRound = [[NSMutableDictionary alloc] init];
        [betRound setValue:action forKey:@"action"];
        [betRound setValue:[NSString stringWithFormat:@"%.2f",callAmount] forKey:@"callAmount"];
        [betRound setValue:[NSString stringWithFormat:@"%.2f",raiseAmount] forKey:@"raiseAmount"];
        [betRound setValue:[NSString stringWithFormat:@"%.2f",callAmount+raiseAmount] forKey:@"amount"];
        
        [[DataManager sharedInstance] postRound:betRound];
        [self performSelectorOnMainThread:@selector(donePostingBet) 
                               withObject:nil waitUntilDone:YES];
        
        
    });
}

-(void)donePostingBet{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.updatingPopUp hide];
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
        raiseLabel.text = [NSString stringWithFormat:@"All In $%.2f",raiseValue];
        //[raiseButton setTitle:[NSString stringWithFormat:@"All In $%.2f",raiseValue] forState:UIControlStateNormal];
    }else{
        int numberOfRaises = [[DataManager sharedInstance] getNumberOfRaisesforCurrentRound];
        NSString *raiseString = @"";
        if(numberOfRaises==0){
            raiseString = @"Bet";
        }else if(numberOfRaises == 1){
            raiseString = @"Raise";
        }else{
            raiseString = @"ReRaise";
        }    
        
        raiseLabel.text = [NSString stringWithFormat:@"%@ $%.2f",raiseString,raiseValue];
        //[raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
    }
}

-(void)decreaseBuyIn{
    double smallBlind = [[[[DataManager sharedInstance].currentGame objectForKey:@"gameSettings"] objectForKey:@"smallBlind"] doubleValue];
    if(raiseValue > raiseSlider.minimumValue){
        raiseValue = raiseValue - smallBlind;
    }
    raiseSlider.value = raiseValue;
    raiseLabel.text = [NSString stringWithFormat:@"Raise $%.2f",raiseValue];
   // [raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
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
        raiseLabel.text = [NSString stringWithFormat:@"All In $%.2f",raiseValue];
        //[raiseButton setTitle:[NSString stringWithFormat:@"All In $%.2f",raiseValue] forState:UIControlStateNormal];
    }else{
        raiseLabel.text = [NSString stringWithFormat:@"Raise $%.2f",raiseValue];
        //[raiseButton setTitle:[NSString stringWithFormat:@"Raise $%.2f",raiseValue] forState:UIControlStateNormal];
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
