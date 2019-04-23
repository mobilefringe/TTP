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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];

    
    self.playerView = [[UIView alloc] initWithFrame:self.bounds];
    playerView.backgroundColor = [UIColor clearColor];
    [self addSubview:playerView];
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, frame.size.width-10, 17)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    userNameLabel.textAlignment = UITextAlignmentCenter;
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    userNameLabel.minimumFontSize = 8;
    userNameLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:userNameLabel];
    
    self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 17, frame.size.width-10, 15)];
    userStackLabel.backgroundColor = [UIColor clearColor];
    userStackLabel.font = [UIFont systemFontOfSize:14];
    userStackLabel.textAlignment = UITextAlignmentCenter;
    userStackLabel.adjustsFontSizeToFitWidth = YES;
    userStackLabel.minimumFontSize = 8;
    userStackLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:userStackLabel];
    
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height - 17, frame.size.width-10, 15)];
    actionLabel.backgroundColor = [UIColor clearColor];
    actionLabel.font = [UIFont systemFontOfSize:12];
    actionLabel.textAlignment = UITextAlignmentCenter;
    actionLabel.adjustsFontSizeToFitWidth = YES;
    actionLabel.minimumFontSize = 8;
    actionLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:actionLabel];
    
    self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(1, 32, 60-2, 60)];
    [playerView addSubview:avatar];
    
    
    
    self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(27, 70, 15, 23)];
    [playerView addSubview:cardOne];
    self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(43, 70, 15, 23)];
    [playerView addSubview:cardTwo];
    
    self.dealerButton = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 20, 20)];
    [dealerButton setImage:[UIImage imageNamed:@"dealer_button.png"]];
    [self addSubview:dealerButton];
    

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = self.bounds;
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(pressPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return self;
}

-(void)setPlayerData:(NSMutableDictionary *)playerData isCurrentHand:(BOOL)isCurrentHand winners:(NSMutableArray *)winners{
   // NSLog(@"player:%@",playerData);
    isCurrentHandTmp = isCurrentHand;
    self.player = playerData;
    
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
    }
    
    if(isMe){
        //NSLog(@"playerData:%@",playerData);
        xOffSet = 40;
        avatar.frame = CGRectMake(1,1, 33, 33);
        userStackLabel.frame = CGRectMake(35, 17, self.frame.size.width-40, 15);
        userNameLabel.frame = CGRectMake(35, 1, self.frame.size.width-40, 17);
        self.cardOne.frame = CGRectMake(8, 37, 40, 55);
        self.cardTwo.frame = CGRectMake(51, 37, 40, 55);
    }
    
    
    dealerButton.frame = CGRectMake(60+xOffSet, 0+yOffSet, 20, 20);
    
    
    if([[player valueForKey:@"isDealer"] isEqualToString:@"YES"]){
        dealerButton.hidden = NO;
    }else{
        dealerButton.hidden = YES;
    }
            
    if([[player valueForKey:@"action"] isEqualToString:@"fold"] || ![[player valueForKey:@"status"] isEqualToString:@"playing"]){
        playerView.alpha = 0.5;
        if([[player valueForKey:@"status"] isEqualToString:@"playing"]){
            actionLabel.text = NSLocalizedString([player objectForKey:@"action"], nil);
        }else{
            actionLabel.text = NSLocalizedString([player objectForKey:@"status"], nil);
        }
    }else{
        playerView.alpha = 1.0;
        if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[DataManager sharedInstance] isCurrentGameActive] && isCurrentHand){
            if(refreshTimer){
                [refreshTimer invalidate];
            }
            self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLastMoveTimer) userInfo:nil repeats:YES];
            [refreshTimer fire];
        }else{
            if([[player valueForKey:@"action"] isEqualToString:@"raise"]){
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
        userStackLabel.text = [NSString stringWithFormat:@"$%@",[player valueForKey:@"userStack"]];
        if([[player objectForKey:@"userStack"] doubleValue] == 0){
            userStackLabel.text = @"All in";
            userStackLabel.font = [UIFont boldSystemFontOfSize:17];
            userStackLabel.textColor = [UIColor colorWithRed:0.8 green:.7 blue:0.2 alpha:1];
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
    }else{
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
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
