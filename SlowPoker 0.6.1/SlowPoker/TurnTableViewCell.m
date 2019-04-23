//
//  TurnTableViewCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TurnTableViewCell.h"
#import "DataManager.h"
#import "Button.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation TurnTableViewCell

@synthesize cardOne;
@synthesize cardTwo;
@synthesize userNameLabel;
@synthesize chipStackLabel;
@synthesize actionName;
@synthesize actionAmount;
@synthesize handState;
@synthesize showCards;
@synthesize guiState;
@synthesize position;
@synthesize yourBet;
@synthesize roundView;
@synthesize cellCorner;
@synthesize betButton;
@synthesize nudgeButton;
@synthesize timerLabel;
@synthesize refreshTimer;
@synthesize timerIcon;
@synthesize dateFormatter;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        
        
        self.roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        roundView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:roundView];
        
        self.cellCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_corner.png"]];
        cellCorner.center = CGPointMake(304, 55);
        [roundView addSubview:cellCorner];
        
        self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 50)];
        [roundView addSubview:cardOne];
        self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 35, 50)];
        [roundView addSubview:cardTwo];
        
        
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 140, 30)];
        userNameLabel.font = [UIFont boldSystemFontOfSize:20];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 12;
        userNameLabel.backgroundColor = [UIColor clearColor];
        [roundView addSubview:userNameLabel];
        
        self.chipStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 37, 140, 25)];
        chipStackLabel.font = [UIFont systemFontOfSize:20];
        chipStackLabel.adjustsFontSizeToFitWidth = YES;
        chipStackLabel.minimumFontSize = 13;
        chipStackLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        chipStackLabel.backgroundColor = [UIColor clearColor];
        [roundView addSubview:chipStackLabel];
        
        self.actionName = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 90, 50)];
        actionName.font = [UIFont systemFontOfSize:18];
        actionName.textAlignment = UITextAlignmentCenter;
        actionName.numberOfLines = 2;
        actionName.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        actionName.backgroundColor = [UIColor clearColor];
        [roundView addSubview:actionName];
        
        self.handState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        handState.font = [UIFont boldSystemFontOfSize:15];
        handState.textAlignment = UITextAlignmentCenter;
        handState.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        handState.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
        [self.contentView addSubview:handState];
        
        self.position = [[UILabel alloc] initWithFrame:CGRectMake(303, 52, 20, 18)];
        position.font = [UIFont boldSystemFontOfSize:13];
        position.textAlignment = UITextAlignmentCenter;
        position.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8];
        position.adjustsFontSizeToFitWidth = YES;
        position.minimumFontSize = 8;
        position.backgroundColor = [UIColor clearColor];
        [roundView addSubview:position];
        
        self.yourBet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"your_bet.png"]];
        yourBet.center = CGPointMake(250, 30);
        //[roundView addSubview:yourBet];
        
        self.betButton = [[Button alloc] initWithFrame:CGRectMake(236, 18, 65, 32) title:@"Bet" red:0.2 green:0.5 blue:0.9 alpha:1];
        [roundView addSubview:betButton];
        
        self.nudgeButton = [[Button alloc] initWithFrame:CGRectMake(236, 18, 65, 32) title:@"Nudge" red:0.2 green:0.2 blue:0.2 alpha:1];
        [roundView addSubview:nudgeButton];
        
        self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 302, 15)];
        timerLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        timerLabel.textAlignment = UITextAlignmentRight;
        timerLabel.font = [UIFont systemFontOfSize:12];
        timerLabel.backgroundColor = [UIColor clearColor];
        [roundView addSubview:timerLabel];
        
        self.timerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(305, 2, 12, 12)];
        [timerIcon setImage:[UIImage imageNamed:@"timer_icon.png"]];
        [roundView addSubview:timerIcon];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    return self;
}

-(void)setCellData:(NSMutableDictionary *)dataDict{
    yourBet.hidden = YES;
    betButton.hidden =YES;
    nudgeButton.hidden = YES;
    timerLabel.hidden = YES;
    timerIcon.hidden = YES;
    timerLabel.text = @"00:00:00";
    
    if([dataDict valueForKey:@"HAND_STATE"] && [[dataDict valueForKey:@"HAND_STATE"] length] > 0){
       roundView.frame = CGRectMake(0, 25, 320, 70);
        handState.hidden = NO;
    }else{
       roundView.frame = CGRectMake(0, 0, 320, 70);
        handState.hidden = YES;
    }
    
    if([@"fold" isEqualToString:[dataDict objectForKey:@"action"]]){
        self.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        roundView.alpha = 0.8;
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        roundView.alpha = 1;
    }
    
    
    chipStackLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    chipStackLabel.font = [UIFont systemFontOfSize:20];
    userNameLabel.textColor = [UIColor blackColor];
    if([[dataDict valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        showCards = YES;
    }else{
        showCards = NO;
    }
    if([@"YES" isEqualToString:[dataDict objectForKey:@"showCards"]] || showCards){
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[dataDict objectForKey:@"cardOne"]]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[dataDict objectForKey:@"cardTwo"]]];
    }else{
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    if([[dataDict objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        userNameLabel.text = @"You";
    }else{
        userNameLabel.text = [dataDict objectForKey:@"userName"];
    }
    
    chipStackLabel.text = [NSString stringWithFormat:@"$%@",[dataDict objectForKey:@"userStack"]];
    if([[dataDict objectForKey:@"userStack"] doubleValue] == 0){
        chipStackLabel.text = @"All in";
        chipStackLabel.font = [UIFont boldSystemFontOfSize:20];
        chipStackLabel.textColor = [UIColor colorWithRed:0.7 green:.5 blue:0 alpha:1];
    }
    
    
    actionName.font = [UIFont systemFontOfSize:18];
    if([dataDict objectForKey:@"MY_BET_ROUND"] && [@"YES" isEqualToString:[dataDict objectForKey:@"MY_BET_ROUND"]]){
        actionName.text = @"";
        timerLabel.hidden = NO;
        timerIcon.hidden = NO;
        if(refreshTimer){
            [refreshTimer invalidate];
        }
        
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLastMoveTimer) userInfo:nil repeats:YES];
        [refreshTimer fire];
        
        
        chipStackLabel.textColor = [UIColor whiteColor];
        userNameLabel.textColor = [UIColor whiteColor];
        if([[DataManager sharedInstance] isCurrentGameMyTurn]){

            actionName.text = @"";
            betButton.hidden = NO;
            userNameLabel.text = @"Your turn";
            [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[dataDict objectForKey:@"cardOne"]]];
            [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[dataDict objectForKey:@"cardTwo"]]];
            self.contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1];
        }else{
            nudgeButton.hidden = NO;
            [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
            [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
            userNameLabel.text = [NSString stringWithFormat:@"%@'s turn",[dataDict objectForKey:@"userName"]];
            self.contentView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        }
        
    }else{
        double amount = [[dataDict objectForKey:@"amount"] doubleValue];
        if(amount == 0){
            actionName.text = [NSString stringWithFormat:@"%@",NSLocalizedString([dataDict objectForKey:@"action"], nil)];
        
        }else{
            if([@"raise" isEqualToString:[dataDict objectForKey:@"action"]]){
                actionName.font = [UIFont boldSystemFontOfSize:18];
               // actionName.textColor = [UIColor colorWithRed:0 green:.3 blue:0 alpha:1];
                actionName.text = [NSString stringWithFormat:@"%@ $%@",NSLocalizedString([dataDict objectForKey:@"action"], nil),[dataDict objectForKey:@"raiseAmount"]];
            }else{
                
                //actionName.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
                actionName.text = [NSString stringWithFormat:@"%@ $%@",NSLocalizedString([dataDict objectForKey:@"action"], nil),[dataDict objectForKey:@"amount"]];
            }
        }
    }
    
    
    
    if([dataDict objectForKey:@"HAND_STATE"]){
        handState.text = NSLocalizedString([dataDict objectForKey:@"HAND_STATE"], nil);
    }else{
        handState.text = @"";
    }
    
    cellCorner.hidden = NO;
    position.text = @"";
    if([dataDict valueForKey:@"isDealer"] && [[dataDict valueForKey:@"isDealer"] isEqualToString:@"YES"]){
        position.text = @"D";
    }else{
        cellCorner.hidden = YES;
    }    
    /*else if([playerState valueForKey:@"isSmallBlind"] && [[playerState valueForKey:@"isSmallBlind"] isEqualToString:@"YES"]){
        position.text = @"SB";
    }else if([playerState valueForKey:@"isBigBlind"] && [[playerState valueForKey:@"isBigBlind"] isEqualToString:@"YES"]){
        position.text = @"BB";
    */
}

-(void)updateLastMoveTimer{
    
    dispatch_async(kBgQueue, ^{
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:[DataManager sharedInstance].lastUpdatedDate];
        // NSLog(@"currentDate:%@   lastUpdatedDate:%@",currentDate,[DataManager sharedInstance].lastUpdatedDate);
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSString *timeString=[dateFormatter stringFromDate:timerDate];
        
        [timerLabel performSelectorOnMainThread:@selector(setText:) 
                                     withObject:timeString waitUntilDone:NO];
    });
    
   

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
