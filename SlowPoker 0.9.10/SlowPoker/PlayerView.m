//
//  PlayerView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerView.h"
#import "DataManager.h"
#import "Button.h"
#import "TurnsViewController.h"
#import "Avatar.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation PlayerView
@synthesize backgroundImageView;
@synthesize backgroundBlue;
@synthesize grayBar;
@synthesize userNameLabel;
@synthesize userStackLabel;
@synthesize actionLabel;
@synthesize player;
@synthesize avatar;
@synthesize refreshTimer;
@synthesize dealerButton;
@synthesize cardOne;
@synthesize cardTwo;
@synthesize playerView;
@synthesize isMe;
@synthesize delegate;
@synthesize button;
@synthesize dateFormatter;
@synthesize chipImageView;
@synthesize greenChip;
@synthesize redChip;
@synthesize yellowChip;
@synthesize giftButton;
@synthesize giftUserID;
@synthesize giftIcon;
@synthesize giftFlipView;
@synthesize giftActiveBackground;
@synthesize giftActiveImageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    
    
    
    
    
    self.playerView = [[UIView alloc] initWithFrame:self.bounds];
    playerView.backgroundColor = [UIColor clearColor];
    [self addSubview:playerView];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"player_view_player_background.png"];
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width/2, backgroundImage.size.height/2)];
    backgroundImageView.image = backgroundImage;
    [playerView addSubview:backgroundImageView];
    
    self.backgroundBlue = [UIImage imageNamed:@"player_view_player_background_blue.png"];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd:HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];

    
    
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 61, 13)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont systemFontOfSize:10];
    userNameLabel.textAlignment = UITextAlignmentCenter;
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    userNameLabel.minimumFontSize = 8;
    userNameLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:userNameLabel];
    
        
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 22, 61, 13)];
    actionLabel.backgroundColor = [UIColor clearColor];
    actionLabel.font = [UIFont boldSystemFontOfSize:12];
    actionLabel.textAlignment = UITextAlignmentCenter;
    actionLabel.adjustsFontSizeToFitWidth = YES;
    actionLabel.minimumFontSize = 8;
    actionLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:actionLabel];
    
    self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(10.7, 35, 64.2, 64.2)];
    [playerView addSubview:avatar];
    
    
    
    self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(31, 75, 20, 30)];
    [playerView addSubview:cardOne];
    self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(53, 75, 20, 30)];
    [playerView addSubview:cardTwo];
    
    
    UIImage *grayBarImage = [UIImage imageNamed:@"player_view_gray_bar.png"];
    self.grayBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, grayBarImage.size.width/2, grayBarImage.size.height/2)];
    grayBar.center = CGPointMake(50.4, 103.4);
    grayBar.image = grayBarImage;
    [playerView addSubview:grayBar];
    
    self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 98, 43, 16)];
    userStackLabel.backgroundColor = [UIColor clearColor];
    userStackLabel.font = [UIFont boldSystemFontOfSize:15];
    userStackLabel.textColor = [UIColor blackColor];
    userStackLabel.textAlignment = UITextAlignmentCenter;
    userStackLabel.adjustsFontSizeToFitWidth = YES;
    userStackLabel.minimumFontSize = 8;
    [playerView addSubview:userStackLabel];

    
    
    
    self.greenChip = [UIImage imageNamed:@"green_chip.png"];
    self.yellowChip = [UIImage imageNamed:@"yellow_chip.png"];
    self.redChip = [UIImage imageNamed:@"red_chip.png"];
    self.chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 94, greenChip.size.width/2+2, greenChip.size.height/2+2)];
    [playerView addSubview:chipImageView];
    
    self.dealerButton = [[UIImageView alloc] initWithFrame:CGRectMake(60, 60, 20, 20)];
    [dealerButton setImage:[UIImage imageNamed:@"dealer_button.png"]];
    [self addSubview:dealerButton];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = self.bounds;
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(pressPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    
    self.giftFlipView = [[UIImageView alloc] initWithFrame:CGRectMake(57, 38, 25,25)];
    giftIcon.backgroundColor = [UIColor clearColor];
    [self addSubview:giftFlipView];

    self.giftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25,25)];
    giftIcon.image = [UIImage imageNamed:@"gift_icon.png"];
    [giftFlipView addSubview:giftIcon];
    
    self.giftActiveBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25,25)];
    giftActiveBackground.image = [UIImage imageNamed:@"gift_active_background.png"];
    
    self.giftActiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 20,20)];
    [giftActiveBackground addSubview:giftActiveImageView];
    
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    giftButton.backgroundColor = [UIColor clearColor];
    giftButton.frame = CGRectMake(63, 38, 25,25);
    giftButton.showsTouchWhenHighlighted = YES;
    giftButton.backgroundColor = [UIColor clearColor];
    [giftButton addTarget:self action:@selector(pressGift) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:giftButton];
    
    return self;
}

-(void)showGift:(NSMutableDictionary *)gift animated:(BOOL)animated{
    giftActiveImageView.image = [UIImage imageNamed:[gift valueForKey:@"image"]];
    //NSLog(@"buyGift:%@",[DataManager sharedInstance].buyGift);
    
    BOOL isGiftExpired = [[DataManager sharedInstance] currentHandInt] - [[gift valueForKey:@"handNumber"] intValue] > 3;
    if([[gift valueForKey:@"handNumber"] intValue] == 0){
        isGiftExpired = NO;
    }
    
    if ([giftIcon superview] && !isGiftExpired) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.6];
        [UIView setAnimationDuration:.5];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:giftFlipView
                                 cache:YES]; 
        [giftIcon removeFromSuperview];
        [giftFlipView  addSubview:giftActiveBackground];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];

        
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.6];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:giftFlipView
                                 cache:YES]; 
        [giftActiveBackground removeFromSuperview];
        [giftFlipView  addSubview:giftActiveBackground];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];

        
    }
}

-(void)setPlayerData:(NSMutableDictionary *)playerData isCurrentHand:(BOOL)isCurrentHand winners:(NSMutableArray *)winners chipStackState:(int)chipStackState dealerButtonCentre:(CGPoint)dealerButtonCentre{
    //NSLog(@"player:%@",playerData);
    isCurrentHandTmp = isCurrentHand;
    self.player = playerData;
    if(chipStackState == 1){
        chipImageView.image = greenChip;
    }else if(chipStackState == 2){
        chipImageView.image = yellowChip;
    }else if(chipStackState == 3){
        chipImageView.image = redChip;
    }
    
    /*
    betButton.hidden = YES;
    if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[player valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID] && [[DataManager sharedInstance] isCurrentGameActive]){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-20, self.frame.size.width, self.frame.size.height+20);
        [self setNeedsDisplay];
        betButton.hidden = NO;
    }*/
    
    isWinner = NO;
    for (NSMutableDictionary *winnerPlayerData in winners) {
        if([[winnerPlayerData valueForKey:@"userID"] isEqualToString:[player valueForKey:@"userID"]]){
            isWinner = YES;
        }
    }
    
    /*
    int yOffSet = 0;
    int xOffSet = 0;
    if(self.frame.origin.y < 40){
        yOffSet = 110;
    }else if(self.center.y == 315){
        xOffSet = -21;
    }
    if(self.frame.origin.x > 250){
        xOffSet = -80;
    }else if(self.frame.origin.x > 70){
        xOffSet = -40;
    }
    if(self.center.x == 160){
        xOffSet = 0;
    }*/
    
    if(isMe){
        //NSLog(@"playerData:%@",playerData);
        /*
        xOffSet = 40;
        avatar.frame = CGRectMake(1,1, 33, 33);
        userStackLabel.frame = CGRectMake(35, 17, self.frame.size.width-40, 15);
        userNameLabel.frame = CGRectMake(35, 1, self.frame.size.width-40, 17);
        self.cardOne.frame = CGRectMake(8, 37, 40, 55);
        self.cardTwo.frame = CGRectMake(51, 37, 40, 55);*/
    }
    
    
    dealerButton.center = dealerButtonCentre;
    
    
    if([[player valueForKey:@"isDealer"] isEqualToString:@"YES"]){
        dealerButton.hidden = NO;
    }else{
        dealerButton.hidden = YES;
    }
            
    if(([[player valueForKey:@"status"] isEqualToString:@"pending"] || [[player valueForKey:@"status"] isEqualToString:@"buyin"])){
        playerView.alpha = 0.6;
        cardOne.alpha = 0;
        cardTwo.alpha = 0;
        
        
        if([[player valueForKey:@"status"] isEqualToString:@"playing"]){
            actionLabel.text = NSLocalizedString([player objectForKey:@"action"], nil);
        }else{
            actionLabel.text = NSLocalizedString([player objectForKey:@"status"], nil);
        }
    }else{
        cardOne.alpha = 1;
        cardTwo.alpha = 1;
        playerView.alpha = 1.0;
        if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[DataManager sharedInstance] isCurrentGameActive] && isCurrentHand){
            if(refreshTimer){
                [refreshTimer invalidate];
            }
            self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLastMoveTimer) userInfo:nil repeats:YES];
            [refreshTimer fire];
        }else{
            if([[player valueForKey:@"action"] isEqualToString:@"raise"] || [[player valueForKey:@"action"] isEqualToString:@"bet"] || [[player valueForKey:@"action"] isEqualToString:@"reraise"]){
                actionLabel.font = [UIFont boldSystemFontOfSize:14];
                actionLabel.textColor = [UIColor colorWithRed:0.8 green:.7 blue:0.2 alpha:1];
                actionLabel.text = [NSString stringWithFormat:@"+ $%@",[player valueForKey:@"raiseAmount"]];
            }else{
                if([[player valueForKey:@"status"] isEqualToString:@"playing"]){
                    actionLabel.text = NSLocalizedString([player objectForKey:@"action"], nil);
                }else{
                    actionLabel.text = NSLocalizedString([player objectForKey:@"status"], nil);
                }
                
            }
        }
    }
    
    if([[playerData valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        userNameLabel.text = @"You";
    }else{
        userNameLabel.text = [playerData valueForKey:@"userName"];
    }
    if([player valueForKey:@"userStack"]){
        userStackLabel.text = [NSString stringWithFormat:@"%@",[player valueForKey:@"userStack"]];
        if([[player objectForKey:@"userStack"] doubleValue] == 0){
            userStackLabel.text = @"-All in-";
            userStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        }
    }else{
        userStackLabel.text = @"";
    }
    [avatar loadAvatar:[playerData valueForKey:@"userID"]];
    
    BOOL showCards = NO;
    if([[player valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        showCards = YES;
    }else{
        showCards = NO;
    }
    if([@"YES" isEqualToString:[player objectForKey:@"showCards"]] || showCards){
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[player objectForKey:@"cardOne"]]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[player objectForKey:@"cardTwo"]]];
        
        cardOne.frame = CGRectMake(26, 68, 24, 36);
        cardTwo.frame = CGRectMake(50, 68, 24, 36);
    }else{
        
        cardOne.frame = CGRectMake(43, 82, 15, 30);
        cardTwo.frame = CGRectMake(59, 82, 15, 30);
        
        
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[DataManager sharedInstance] isCurrentGameActive] && isCurrentHandTmp){
        backgroundImageView.image = backgroundBlue;
    }
    
    //NSLog(@"playerData:%@",playerData);
    if([playerData valueForKey:@"gift"]){
        [self showGift:[playerData valueForKey:@"gift"] animated:NO];
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    if([[player valueForKey:@"action"] isEqualToString:@"fold"] || ![[player valueForKey:@"status"] isEqualToString:@"playing"]){
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5].CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.85].CGColor);
    }
    if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[DataManager sharedInstance] isCurrentGameActive] && isCurrentHandTmp){
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.6 blue:0.9 alpha:0.95].CGColor);
    }else if(isWinner){
         CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:0.9].CGColor);
    }
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 8;
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;    
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if(isMe){
        CGContextSetRGBFillColor(context, 1.0,1.0,1.0,0.6);
        CGContextFillRect(context, CGRectMake(1, 34, self.frame.size.width-2, 60));
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    */
    
}

-(void)pressGift{
    [DataManager sharedInstance].giftUserID = [player valueForKey:@"userID"];
    [DataManager sharedInstance].giftUserName = [player valueForKey:@"userName"];
}

-(void)updateLastMoveTimer{
    
    dispatch_async(kBgQueue, ^{
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:[DataManager sharedInstance].lastUpdatedDate];
        // NSLog(@"currentDate:%@   lastUpdatedDate:%@",currentDate,[DataManager sharedInstance].lastUpdatedDate);
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSString *timeString=[dateFormatter stringFromDate:timerDate];
        
        [actionLabel performSelectorOnMainThread:@selector(setText:) 
                                     withObject:timeString waitUntilDone:NO];
    });    
}

-(void)pressPlayer{
    BOOL isPlayersTurn = NO;
    if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[DataManager sharedInstance] isCurrentGameActive] && isCurrentHandTmp && ![[player valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        isPlayersTurn = YES;
    }
    
    [delegate pressPlayer:player isPlayersTurn:isPlayersTurn];
    
}


@end
