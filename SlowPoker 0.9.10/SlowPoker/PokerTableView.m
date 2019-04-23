//
//  PokerTableView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PokerTableView.h"
#import "PlayerView.h"
#import "DataManager.h"
#import "Button.h"
#import "CardView.h"
#import "TurnsViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation PokerTableView

@synthesize players;
@synthesize showDownView;
@synthesize placements;
@synthesize dealerButtonPlacements;
@synthesize background;
@synthesize communityCardOne;
@synthesize communityCardTwo;
@synthesize communityCardThree;
@synthesize communityCardFour;
@synthesize communityCardFive;
@synthesize potLabel;
@synthesize delegate;
@synthesize betButton;
@synthesize showHand;
@synthesize dealNewHandButton;
@synthesize winnerType;
@synthesize playerViews;
@synthesize handSummaryButton;
@synthesize handSummaryDelegate;
@synthesize addPlayerButton;
@synthesize betLabel2;

static BOOL testPlayers = NO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"buyGift" options:NSKeyValueObservingOptionOld context:nil];
        self.backgroundColor = [UIColor clearColor];
        self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_table_view.png"]];
        background.frame = CGRectMake(0, -25, 320, 480);
        [self addSubview:background];

        
        self.showDownView = [[UIView alloc] initWithFrame:CGRectMake(0, -25, 320, 480)];
        showDownView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:showDownView];
        
        
        
        self.placements = [[NSMutableDictionary alloc] init];
        self.dealerButtonPlacements = [[NSMutableDictionary alloc] init];
        int youPlayerX = 140;
        int xoffset = -13;
        int yOffset = 50;
        //1
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)], nil] forKey:@"1"];
        
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315+yOffset)], nil] forKey:@"1"];
        
        //2
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)],[NSValue valueWithCGPoint:CGPointMake(160, 53+yOffset)], nil] forKey:@"2"];
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(87, 18)],[NSValue valueWithCGPoint:CGPointMake(45,125)],nil] forKey:@"2"];
        
        //3
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(105+xoffset, 53+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(245+xoffset, 53+yOffset)], nil] forKey:@"3"];
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(87, 18)],
                                           [NSValue valueWithCGPoint:CGPointMake(45,125)],[NSValue valueWithCGPoint:CGPointMake(45,125)],
                                           nil] forKey:@"3"];
        
        //4
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(52+xoffset, 175+yOffset)],[NSValue valueWithCGPoint:CGPointMake(160, 53+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(293+xoffset, 175+yOffset)],
                               nil] forKey:@"4"];
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(87, 18)],
                                           [NSValue valueWithCGPoint:CGPointMake(89, 25)],[NSValue valueWithCGPoint:CGPointMake(45,125)],[NSValue valueWithCGPoint:CGPointMake(-3, 25)],
                                           nil] forKey:@"4"];
        
        
        //5
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(52+xoffset, 175+yOffset)],[NSValue valueWithCGPoint:CGPointMake(125+xoffset, 53+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(225+xoffset, 53+yOffset)],[NSValue valueWithCGPoint:CGPointMake(293+xoffset, 175+yOffset)],
                               nil] forKey:@"5"];
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(87, 18)],
                                           [NSValue valueWithCGPoint:CGPointMake(89, 25)],[NSValue valueWithCGPoint:CGPointMake(45,125)],[NSValue valueWithCGPoint:CGPointMake(45, 125)],[NSValue valueWithCGPoint:CGPointMake(-3, 25)],
                                           nil] forKey:@"5"];
        
        //6
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(52+xoffset, 290+yOffset)],[NSValue valueWithCGPoint:CGPointMake(52+xoffset, 85+40+yOffset)],[NSValue valueWithCGPoint:CGPointMake(160, 53+yOffset)],[NSValue valueWithCGPoint:CGPointMake(293+xoffset, 85+40+yOffset)],[NSValue valueWithCGPoint:CGPointMake(293+xoffset, 290+yOffset)],
                               nil] forKey:@"6"];
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(87, 18)],
                                           [NSValue valueWithCGPoint:CGPointMake(87, 18)],[NSValue valueWithCGPoint:CGPointMake(65,125)],[NSValue valueWithCGPoint:CGPointMake(45, 125)],[NSValue valueWithCGPoint:CGPointMake(33, 125)],[NSValue valueWithCGPoint:CGPointMake(-1, 10)],
                                           nil] forKey:@"6"];
        
        //7
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 301+yOffset)],
                               [NSValue valueWithCGPoint:CGPointMake(52+xoffset, 290+yOffset)],[NSValue valueWithCGPoint:CGPointMake(52+xoffset, 85+40+yOffset)],[NSValue valueWithCGPoint:CGPointMake(130+xoffset, 53+yOffset)],[NSValue valueWithCGPoint:CGPointMake(213+xoffset, 53+yOffset)],[NSValue valueWithCGPoint:CGPointMake(293+xoffset, 85+40+yOffset)],[NSValue valueWithCGPoint:CGPointMake(293+xoffset, 290+yOffset)],
                               nil] forKey:@"7"];
        [dealerButtonPlacements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(87, 18)],
                               [NSValue valueWithCGPoint:CGPointMake(87, 18)],[NSValue valueWithCGPoint:CGPointMake(65,125)],[NSValue valueWithCGPoint:CGPointMake(45, 125)],[NSValue valueWithCGPoint:CGPointMake(45, 125)],[NSValue valueWithCGPoint:CGPointMake(12, 128)],[NSValue valueWithCGPoint:CGPointMake(-1, 10)],
                               nil] forKey:@"7"];
        
        int xOffset = 35;
        communityCardsY = 194;
        self.communityCardOne = [[CardView alloc] initWithFrame:CGRectMake(88, communityCardsY, 25, 37)];
        [self addSubview:communityCardOne];
        
        self.communityCardTwo = [[CardView alloc] initWithFrame:CGRectMake(88+29, communityCardsY, 25, 37)];
        [self addSubview:communityCardTwo];
        
        self.communityCardThree = [[CardView alloc] initWithFrame:CGRectMake(88+29*2, communityCardsY, 25, 37)];
        [self addSubview:communityCardThree];
        
        self.communityCardFour = [[CardView alloc] initWithFrame:CGRectMake(88+29*3, communityCardsY, 25, 37)];
        [self addSubview:communityCardFour];
        
        self.communityCardFive = [[CardView alloc] initWithFrame:CGRectMake(88+29*4, communityCardsY, 25, 37)];
        [self addSubview:communityCardFive];
        
        
        
        
        //
        

        
        self.winnerType = [[UILabel alloc] initWithFrame:CGRectMake(80, 235, 160, 15)];
        winnerType.textAlignment = UITextAlignmentCenter;
        winnerType.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        winnerType.font = [UIFont boldSystemFontOfSize:13];
        //potLabel.backgroundColor = [UIColor clearColor];
        winnerType.textColor = [UIColor whiteColor];
        winnerType.text = @"";
        //[self addSubview:winnerType];

        
        self.potLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 174, 120, 15)];
        potLabel.textAlignment = UITextAlignmentCenter;
        potLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        potLabel.font = [UIFont boldSystemFontOfSize:14];
        potLabel.minimumFontSize = 8;
        potLabel.numberOfLines = 1;
        potLabel.adjustsFontSizeToFitWidth = YES;
        //potLabel.backgroundColor = [UIColor clearColor];
        potLabel.textColor = [UIColor whiteColor];
        [self addSubview:potLabel];
        
        
        UIImage *actionButtonImage = [UIImage imageNamed:@"blue_wide.png"];
        self.betButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [betButton setImage:actionButtonImage forState:UIControlStateNormal];
        betButton.frame = CGRectMake(80, 235, actionButtonImage.size.width/2+34, actionButtonImage.size.height/2+12);
        [betButton addTarget:delegate action:@selector(pressBet) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:betButton];
        
        UILabel *betLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, betButton.frame.size.width-20, betButton.frame.size.height-23)];
        betLabel.font = [UIFont boldSystemFontOfSize:20];
        betLabel.textColor = [UIColor whiteColor];
        betLabel.textAlignment = UITextAlignmentCenter;
        betLabel.text = @"Your Turn!";
        betLabel.adjustsFontSizeToFitWidth = YES;
        betLabel.minimumFontSize = 12;
        betLabel.backgroundColor = [UIColor clearColor];
        [betButton addSubview:betLabel];
        
        self.betLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, (betButton.frame.size.height-23)-4, betButton.frame.size.width-20, 18)];
        betLabel2.font = [UIFont boldSystemFontOfSize:15];
        betLabel2.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.90];
        betLabel2.textAlignment = UITextAlignmentCenter;
        betLabel2.text = @"Fold/Check/Reraise";
        betLabel2.adjustsFontSizeToFitWidth = YES;
        betLabel2.minimumFontSize = 8;
        betLabel2.backgroundColor = [UIColor clearColor];
        [betButton addSubview:betLabel2];
        
        self.dealNewHandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dealNewHandButton setImage:actionButtonImage forState:UIControlStateNormal];
        dealNewHandButton.frame = CGRectMake(98.5, 243, actionButtonImage.size.width/2+0.5, actionButtonImage.size.height/2);
        [dealNewHandButton addTarget:self action:@selector(newHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dealNewHandButton];
        
        
        self.handSummaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        handSummaryButton.backgroundColor = [UIColor clearColor];
        handSummaryButton.frame = CGRectMake(100, 167, 120, 67);
        [handSummaryButton addTarget:self action:@selector(pressHandSummary) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:handSummaryButton];

        
        UILabel *newHandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, actionButtonImage.size.width/2-20, actionButtonImage.size.height/2-10)];
        newHandLabel.font = [UIFont boldSystemFontOfSize:18];
        newHandLabel.textColor = [UIColor whiteColor];
        newHandLabel.textAlignment = UITextAlignmentCenter;
        newHandLabel.text = @"New Hand";
        newHandLabel.adjustsFontSizeToFitWidth = YES;
        newHandLabel.minimumFontSize = 12;
        newHandLabel.backgroundColor = [UIColor clearColor];
        [dealNewHandButton addSubview:newHandLabel];

        

    }
    return self;
}


-(void)clearGame{
    showDownView.alpha = 0;
    for (UIView *playerView in self.subviews) {
        if(playerView.tag == 123){
            [playerView removeFromSuperview];
        }
    }
    [self.communityCardOne loadCard:@"?" animated:NO delay:0];
    [self.communityCardTwo  loadCard:@"?" animated:NO delay:0];
    [self.communityCardThree  loadCard:@"?" animated:NO delay:0];
    [self.communityCardFour loadCard:@"?" animated:NO delay:0];
    [self.communityCardFive  loadCard:@"?" animated:NO delay:0];
    potLabel.alpha = 0;
    winnerType.alpha = 0;
    betButton.hidden = YES;
    dealNewHandButton.hidden = YES;
    winnerType.hidden = NO;
}


-(double)loadGame:(BOOL)currentHand{
    //NSLog(@"loadGame!!!");
    self.players = [[DataManager sharedInstance] getPlayersInTableArangement];
    [self clearGame];
    
    if(!playerViews){
        self.playerViews = [[NSMutableArray alloc] init];
    }
    [playerViews removeAllObjects];
    
    
    
    if(!currentHand && [[[DataManager sharedInstance] getHandsForCurrentGame] count] > 1 && [[[DataManager sharedInstance] getHandsForCurrentGame] objectAtIndex:1] && [[DataManager sharedInstance] isCurrentGameActive]){
        self.showHand = [[[DataManager sharedInstance] getHandsForCurrentGame] objectAtIndex:1]; 
    }else{
        self.showHand = [DataManager sharedInstance].currentHand;
    }
    
    
    NSMutableArray *communityCards = [showHand objectForKey:@"communityCards"];
    NSMutableDictionary *myLastRound = [self lastRoundPlayer:[DataManager sharedInstance].myUserID forHand:showHand];
    int myLastState = [[myLastRound valueForKey:@"handState"] intValue];
    int state = [[showHand objectForKey:@"state"] intValue];
    
    if(!currentHand){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.1];
        showDownView.alpha = 1;
        [UIView commitAnimations];
        
    }
    double delay = 1;    
    if(state > 1){
        BOOL animated = NO;
        if(myLastState <= 1 && !currentHand){
            animated = YES;
        }
        [self.communityCardOne loadCard:[communityCards objectAtIndex:0] animated:animated delay:delay];
        [self.communityCardTwo loadCard:[communityCards objectAtIndex:1] animated:animated delay:delay];
        [self.communityCardThree loadCard:[communityCards objectAtIndex:2] animated:animated delay:delay];
        if(animated){
            delay = delay + 1.5;
        }
    }else{
        [self.communityCardOne loadCard:@"?" animated:NO delay:0];
        [self.communityCardTwo loadCard:@"?" animated:NO delay:0];
        [self.communityCardThree loadCard:@"?" animated:NO delay:0];
    }
    
    if(state > 2){
        BOOL animated = NO;
        if(myLastState <= 2 && !currentHand){
            animated = YES;
        }
        [self.communityCardFour loadCard:[communityCards objectAtIndex:3] animated:animated delay:delay];
        if(animated){
            delay = delay + 1.5;
        }
    }else{
        [self.communityCardFour loadCard:@"?" animated:NO delay:0];
    }
    
    if(state > 3){
        BOOL animated = NO;
        if(myLastState <= 3 && !currentHand){
            animated = YES;
        }
        [self.communityCardFive loadCard:[communityCards objectAtIndex:4] animated:animated delay:delay];
        if(animated){
            delay = delay + 1.5;
        }
    }else{
        [self.communityCardFive loadCard:@"?" animated:NO delay:0];
    }
    

    if(testPlayers){
        self.players = [[NSMutableArray alloc] init];
        for(int i = 0; i < 6;i++){
            NSMutableDictionary *dummyPlayer = [[NSMutableDictionary alloc] init];
            [dummyPlayer setValue:@"YES" forKey:@"isDealer"];
            [dummyPlayer setValue:@"playing" forKey:@"status"];
            [dummyPlayer setValue:@"100000" forKey:@"userStack"];
            [dummyPlayer setValue:@"call" forKey:@"action"];
            if(i == 0){
                [dummyPlayer setValue:@"YES" forKey:@"isMe"];
            }
            [dummyPlayer setValue:[NSString stringWithFormat:@"Player %d",i+1] forKey:@"userName"];
            [players addObject:dummyPlayer];                                                                     
        }
    }
    NSMutableArray *winners = [showHand valueForKey:@"winners"];
    NSMutableArray *playerPlacements = [placements objectForKey:[NSString stringWithFormat:@"%d",[players count]]];
    NSMutableArray *dealerButtonPlacementsArray = [dealerButtonPlacements objectForKey:[NSString stringWithFormat:@"%d",[players count]]];
    int i = 0;
    
    /*
    for (NSMutableDictionary *player in players) {
        NSLog(@"player:%@",player);
        
        
    }*/
    for (NSMutableDictionary *player in players) {
        PlayerView *playerView;
        CGPoint playerCenter = [[playerPlacements objectAtIndex:i] CGPointValue];
        CGPoint dealerButtonCentre = [[dealerButtonPlacementsArray objectAtIndex:i] CGPointValue];
        playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0, 85, 123)];
        if([[player valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID] || [@"YES" isEqualToString:[player valueForKey:@"isMe"]]){
            playerView.transform = CGAffineTransformScale(playerView.transform, 1.2, 1.2);
            
        }
        playerView.alpha = 0;
        playerView.center = playerCenter;
        playerView.isMe = NO;
        
        /*
        if(playerCenter.x == 140){
            playerView = [[PlayerView alloc] initWithFrame:CGRectMake(110, 260+40, 98, 110)];
            playerView.alpha = 0;
            playerView.isMe = YES;
        }else{
            playerView = [[PlayerView alloc] initWithFrame:CGRectMake(120, 120+40, 60, 110)];
            playerView.alpha = 0;
            playerView.center = playerCenter;
            playerView.isMe = NO;
        }*/
        playerView.delegate = self.delegate;
        
        //NSLog(@"player:%@",player);
        //[UIView beginAnimations:nil context:NULL];
        //[UIView setAnimationDuration:.3];
        playerView.alpha = 1;
        //[UIView commitAnimations];
        NSMutableDictionary *playerRound;
        if(testPlayers){
            playerRound = player;
        }else{
            playerRound = [self lastRoundPlayer:[player valueForKey:@"userID"] forHand:showHand];
            if([playerRound valueForKey:@"action"]){
                [playerRound setValue:@"playing" forKey:@"status"];
            }else{
                [playerRound setValue:[player valueForKey:@"status"] forKey:@"status"];
            }
            [playerRound setValue:[player valueForKey:@"gifts"] forKey:@"gift"];
        }
        
        int chipState = [[DataManager sharedInstance] getChipStackState:[player valueForKey:@"userID"]];
        [playerView setPlayerData:playerRound isCurrentHand:currentHand winners:winners chipStackState:chipState dealerButtonCentre:dealerButtonCentre];
        playerView.tag = 123;
        i++;
        [self addSubview:playerView];
        [playerViews addObject:playerView];
    }
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:.3];
    potLabel.alpha = 1;
    winnerType.alpha = 1;
    betButton.hidden = YES;
    winnerType.text = [NSString stringWithFormat:@"%@ Turn",[[DataManager sharedInstance] getCurrentPlayersTurn]];
    if([winnerType.text isEqualToString:@"Your Turn"]){
        winnerType.alpha = 0;
    }
    if(winners && [winners count] > 0 && currentHand){
        //handDetails.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1];
        handSummaryButton.hidden = NO;
        for (NSMutableDictionary *winnerPlayerData in winners) {
            winnerType.text = NSLocalizedString([winnerPlayerData objectForKey:@"type"], nil);
            double winAmount = [[winnerPlayerData objectForKey:@"amount"] doubleValue] - [[DataManager sharedInstance] getPotEntryForUser:[winnerPlayerData objectForKey:@"userID"] hand:showHand];
            if([[winnerPlayerData valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID] && winAmount > 0){
                potLabel.text = [NSString stringWithFormat:@"You won $%.2f!",winAmount];
                //self.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:0.9];
                break;
            }else{
                potLabel.text = [NSString stringWithFormat:@"%@ won $%.2f",[winnerPlayerData objectForKey:@"userName"],winAmount];
            }
            
        }
        if([winners count] > 1){
            potLabel.text = @"Split Pot";
        }
    }else{
        handSummaryButton.hidden = YES;
        if([showHand objectForKey:@"potSize"]){
            potLabel.text = [NSString stringWithFormat:@"Pot $%@",[showHand objectForKey:@"potSize"]];
        }else{
            potLabel.alpha = 0;
        }
        if([[DataManager sharedInstance] isCurrentGameMyTurn] && currentHand && [[DataManager sharedInstance] isCurrentGameActive]){
            betButton.hidden = NO;
        }
    }
    
    
    if(![[DataManager sharedInstance] hasMoreThanOnePlayerForCurrentGame]){
        betButton.hidden = YES;
        dealNewHandButton.hidden = YES;
    }
    
    double callAmount = [[DataManager sharedInstance] getCallValue];
    NSString *raiseString = @"";
    int numberOfRaises = [[DataManager sharedInstance] getNumberOfRaisesforCurrentRound];
    if(numberOfRaises==0){
        raiseString = @"Bet";
    }else if(numberOfRaises == 1){
        raiseString = @"Raise";
    }else{
        raiseString = @"Reraise";
    }
    NSString *callString = @"";
    
    
    if(callAmount > 0){
        callString =    @"Call";
    }else{
        callString = @"Check";
    }
    betLabel2.text = [NSString stringWithFormat:@"%@/%@/%@",@"Fold",callString,raiseString];
    
    return delay;
}

-(void)showGiftForUser:(NSString *)userID animated:(BOOL)animated{
    for (PlayerView *playerView in playerViews) {
        if([[playerView.player valueForKey:@"userID"] isEqualToString:userID] || [@"-1" isEqualToString:userID]){
            [playerView showGift:[DataManager sharedInstance].buyGift animated:YES];
        }
    }
}


-(NSMutableDictionary *)lastRoundPlayer:(NSString *)userID forHand:(NSMutableDictionary *)hand{
    for (NSMutableDictionary *roundPlayer in [hand valueForKey:@"rounds"]) {
        if([[roundPlayer valueForKey:@"userID"] isEqualToString:userID]){
            //NSLog(@"roundPlayer:%@",roundPlayer);
            return roundPlayer;
        }
    }
    NSMutableDictionary *outRound = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *outPlayer = [[DataManager sharedInstance] getPlayerForIDCurrentGame:userID];
    [outRound setValue:[outPlayer valueForKey:@"userID"] forKey:@"userID" ];
    [outRound setValue:[outPlayer valueForKey:@"userName"]forKey:@"userName"];
    [outRound setValue:[outPlayer valueForKey:@"status"] forKey:@"status"];
    [outRound setValue:[outPlayer valueForKey:@"order"] forKey:@"order"];
    [outRound setValue:[[outPlayer valueForKey:@"playerState"] valueForKey:@"action"] forKey:@"action"];
    [outRound setValue:[[outPlayer valueForKey:@"playerState"] valueForKey:@"cardOne"]forKey:@"cardOne"];
    [outRound setValue:[[outPlayer valueForKey:@"playerState"] valueForKey:@"cardTwo"]forKey:@"cardTwo"];
    [outRound setValue:[[outPlayer valueForKey:@"playerState"] valueForKey:@"userStack"] forKey:@"userStack"];
    return outRound;
}

-(void)viewHand{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    showDownView.alpha = 0;
    [UIView commitAnimations];
    dealNewHandButton.hidden = NO;
    winnerType.hidden = YES;
    
}
-(void)newHand{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    showDownView.alpha = 0;
    [UIView commitAnimations];
    NSString *toneFilename = @"shuffle";
    NSURL *toneURLRef = [[NSBundle mainBundle] URLForResource:toneFilename
                                                withExtension:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID( (CFURLRef)objc_unretainedPointer(toneURLRef), &soundID);
    AudioServicesPlaySystemSound(soundID); 
    
    
    /*
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/filename.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID); 
    */

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(resetDeck)];
    communityCardOne.frame = CGRectMake(88, 194, 25, 37);
    communityCardTwo.frame = CGRectMake(88, 194, 25, 37);
    communityCardThree.frame = CGRectMake(88, 194, 25, 37);
    communityCardFour.frame = CGRectMake(88, 194, 25, 37);
    communityCardFive.frame = CGRectMake(88, 194, 25, 37);
    [UIView commitAnimations];
    
}

-(void)resetDeck{
    [self.communityCardOne loadCard:@"?" animated:NO delay:0];
    [self.communityCardTwo  loadCard:@"?" animated:NO delay:0];
    [self.communityCardThree  loadCard:@"?" animated:NO delay:0];
    [self.communityCardFour loadCard:@"?" animated:NO delay:0];
    [self.communityCardFive  loadCard:@"?" animated:NO delay:0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updateDeck)];
    communityCardOne.frame = CGRectMake(88, 194, 25, 37);
    communityCardTwo.frame = CGRectMake(88+29, 194, 25, 37);
    communityCardThree.frame = CGRectMake(88+29*2, 194, 25, 37);
    communityCardFour.frame = CGRectMake(88+29*3, 194, 25, 37);
    communityCardFive.frame = CGRectMake(88+29*4, 194, 25, 37);

    
    [UIView commitAnimations];
    
}

-(void)updateDeck{
    [delegate updateGameData];
    [delegate viewDidAppear:NO];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"buyGift"]){
        [self showGiftForUser:[DataManager sharedInstance].giftUserID animated:YES];
        
    }
}

-(void)pressHandSummary{
    if(!betButton.hidden){
        [delegate pressBet];
        return;
    }    
    [handSummaryDelegate showHandSummaryForHand:self.showHand];
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
