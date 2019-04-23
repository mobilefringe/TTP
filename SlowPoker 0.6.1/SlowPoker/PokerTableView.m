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
#import "TurnsViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation PokerTableView

@synthesize players;
@synthesize placements;
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

static BOOL testPlayers = NO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poker_table.png"]];
        background.frame = CGRectMake(10, 0, 300, 416-40);
        [self addSubview:background];
        
        self.placements = [[NSMutableDictionary alloc] init];
        int youPlayerX = 140;
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)], nil] forKey:@"1"];
        
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)],[NSValue valueWithCGPoint:CGPointMake(160, 60)], nil] forKey:@"2"];
        
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)],
                               [NSValue valueWithCGPoint:CGPointMake(105, 60)],
                               [NSValue valueWithCGPoint:CGPointMake(220, 60)], nil] forKey:@"3"];
        
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)],
                               [NSValue valueWithCGPoint:CGPointMake(35, 175)],[NSValue valueWithCGPoint:CGPointMake(160, 60)],
                               [NSValue valueWithCGPoint:CGPointMake(285, 175)],
                               nil] forKey:@"4"];
        
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)],
                               [NSValue valueWithCGPoint:CGPointMake(35, 175)],[NSValue valueWithCGPoint:CGPointMake(115, 60)],
                               [NSValue valueWithCGPoint:CGPointMake(210, 60)],[NSValue valueWithCGPoint:CGPointMake(285, 175)],
                               nil] forKey:@"5"];
        
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)],
                               [NSValue valueWithCGPoint:CGPointMake(35, 290)],[NSValue valueWithCGPoint:CGPointMake(35, 85)],[NSValue valueWithCGPoint:CGPointMake(160, 60)],[NSValue valueWithCGPoint:CGPointMake(285, 85)],[NSValue valueWithCGPoint:CGPointMake(285, 290)],
                               nil] forKey:@"6"];
        
        [placements setObject:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(youPlayerX, 315)],
                               [NSValue valueWithCGPoint:CGPointMake(35, 290)],[NSValue valueWithCGPoint:CGPointMake(35, 85+40)],[NSValue valueWithCGPoint:CGPointMake(123, 60)],[NSValue valueWithCGPoint:CGPointMake(202, 60)],[NSValue valueWithCGPoint:CGPointMake(285, 85+40)],[NSValue valueWithCGPoint:CGPointMake(285, 290)],
                               nil] forKey:@"7"];
        
        int xOffset = 35;
        communityCardsY = 152;
        self.communityCardOne = [[UIImageView alloc] initWithFrame:CGRectMake(73, communityCardsY, 33, 50)];
        [self addSubview:communityCardOne];
        
        self.communityCardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(73+35, communityCardsY, 33, 50)];
        [self addSubview:communityCardTwo];
        
        self.communityCardThree = [[UIImageView alloc] initWithFrame:CGRectMake(73+35*2, communityCardsY, 33, 50)];
        [self addSubview:communityCardThree];
        
        self.communityCardFour = [[UIImageView alloc] initWithFrame:CGRectMake(73+35*3, communityCardsY, 33, 50)];
        [self addSubview:communityCardFour];
        
        self.communityCardFive = [[UIImageView alloc] initWithFrame:CGRectMake(73+35*4, communityCardsY, 33, 50)];
        [self addSubview:communityCardFive];
        
        self.winnerType = [[UILabel alloc] initWithFrame:CGRectMake(80, 133, 160, 15)];
        winnerType.textAlignment = UITextAlignmentCenter;
        winnerType.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        winnerType.font = [UIFont boldSystemFontOfSize:13];
        //potLabel.backgroundColor = [UIColor clearColor];
        winnerType.textColor = [UIColor whiteColor];
        winnerType.text = @"";
        [self addSubview:winnerType];

        
        self.potLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 205, 160, 15)];
        potLabel.textAlignment = UITextAlignmentCenter;
        potLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        potLabel.font = [UIFont boldSystemFontOfSize:13];
        //potLabel.backgroundColor = [UIColor clearColor];
        potLabel.textColor = [UIColor whiteColor];
        [self addSubview:potLabel];
        
        
        self.betButton = [[Button alloc] initWithFrame:CGRectMake(110, 222, 100, 35) title:@"Bet" red:0.2 green:0.5 blue:0.9 alpha:1];
        [betButton.button addTarget:delegate action:@selector(pressBet) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:betButton];
        
        self.dealNewHandButton = [[Button alloc] initWithFrame:CGRectMake(110, 222, 100, 35) title:@"New Hand" red:0.5 green:0.5 blue:0.5 alpha:1];
        [dealNewHandButton.button addTarget:self action:@selector(newHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dealNewHandButton];
        

    }
    return self;
}


-(void)clearGame{
    
    for (UIView *playerView in self.subviews) {
        if(playerView.tag == 123){
            [playerView removeFromSuperview];
        }
    }
    [self.communityCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    potLabel.alpha = 0;
    winnerType.alpha = 0;
    betButton.hidden = YES;
    dealNewHandButton.hidden = YES;
}


-(void)loadGame:(BOOL)currentHand{
    //NSLog(@"loadGame!!!");
    self.players = [[DataManager sharedInstance] getPlayersInTableArangement];
    [self clearGame];
    
    
    
    
    
    if(!currentHand && [[[DataManager sharedInstance] getHandsForCurrentGame] count] > 1 && [[[DataManager sharedInstance] getHandsForCurrentGame] objectAtIndex:1] && [[DataManager sharedInstance] isCurrentGameActive]){
        self.showHand = [[[DataManager sharedInstance] getHandsForCurrentGame] objectAtIndex:1]; 
    }else{
        self.showHand = [DataManager sharedInstance].currentHand;
    }
    
    
    NSMutableArray *communityCards = [showHand objectForKey:@"communityCards"];
    int state = [[showHand objectForKey:@"state"] intValue];
    
        
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
    
    
   
    
    if(testPlayers){
        self.players = [[NSMutableArray alloc] init];
        for(int i = 0; i < 7;i++){
            NSMutableDictionary *dummyPlayer = [[NSMutableDictionary alloc] init];
            [dummyPlayer setValue:@"YES" forKey:@"isDealer"];
            [dummyPlayer setValue:@"playing" forKey:@"status"];
            [dummyPlayer setValue:@"100000" forKey:@"userStack"];
            [dummyPlayer setValue:@"call" forKey:@"action"];
            [dummyPlayer setValue:[NSString stringWithFormat:@"Player %d",i+1] forKey:@"userName"];
            [players addObject:dummyPlayer];                                                                     
        }
    }
    NSMutableArray *winners = [showHand valueForKey:@"winners"];
    NSMutableArray *playerPlacements = [placements objectForKey:[NSString stringWithFormat:@"%d",[players count]]];
    int i = 0;
    
    for (NSMutableDictionary *player in players) {
        PlayerView *playerView;
        CGPoint playerCenter = [[playerPlacements objectAtIndex:i] CGPointValue];
        if(playerCenter.x == 140){
            playerView = [[PlayerView alloc] initWithFrame:CGRectMake(110, 260, 98, 110)];
            playerView.alpha = 0;
            playerView.isMe = YES;
        }else{
            playerView = [[PlayerView alloc] initWithFrame:CGRectMake(120, 120, 60, 110)];
            playerView.alpha = 0;
            playerView.center = playerCenter;
            playerView.isMe = NO;
        }
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
            [playerRound setValue:[player valueForKey:@"status"] forKey:@"status"];
        }
        [playerView setPlayerData:playerRound isCurrentHand:currentHand winners:winners];
        playerView.tag = 123;
        i++;
        [self addSubview:playerView];
    }
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:.3];
    potLabel.alpha = 1;
    winnerType.alpha = 1;
    //[UIView commitAnimations];
    winnerType.text = [NSString stringWithFormat:@"%@ Turn",[[DataManager sharedInstance] getCurrentPlayersTurn]];
    if(winners && [winners count] > 0){
        //handDetails.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1];
        
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
            potLabel.text = [potLabel.text stringByAppendingString:@" *"];
        }
    }else{
        if([showHand objectForKey:@"potSize"]){
            potLabel.text = [NSString stringWithFormat:@"Pot $%@",[showHand objectForKey:@"potSize"]];
        }else{
            potLabel.alpha = 0;
        }
    }
    
    
    
    
    if([[DataManager sharedInstance] isCurrentGameMyTurn] && currentHand && [[DataManager sharedInstance] isCurrentGameActive]){
        betButton.hidden = NO;
    }else{
        betButton.hidden = YES;
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
    dealNewHandButton.hidden = NO;
    
}
-(void)newHand{
    
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
    self.communityCardOne.frame = CGRectMake(73, communityCardsY, 33, 50);
    self.communityCardTwo.frame = CGRectMake(73, communityCardsY, 33, 50);
    self.communityCardThree.frame = CGRectMake(73, communityCardsY, 33, 50);
    self.communityCardFour.frame = CGRectMake(73, communityCardsY, 33, 50);
    self.communityCardFive.frame = CGRectMake(73, communityCardsY, 33, 50);
    [UIView commitAnimations];
    
}

-(void)resetDeck{
    [self.communityCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [self.communityCardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updateDeck)];
    self.communityCardOne.frame = CGRectMake(73, communityCardsY, 33, 50);
    self.communityCardTwo.frame = CGRectMake(73+35, communityCardsY, 33, 50);
    self.communityCardThree.frame = CGRectMake(73+35*2, communityCardsY, 33, 50);
    self.communityCardFour.frame = CGRectMake(73+35*3, communityCardsY, 33, 50);
    self.communityCardFive.frame = CGRectMake(73+35*4, communityCardsY, 33, 50);

    
    [UIView commitAnimations];
    
}

-(void)updateDeck{
    [delegate updateGameData];
    [delegate viewDidAppear:NO];
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
