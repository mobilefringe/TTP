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
#import "NudgeButton.h"
#import "Avatar.h"

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
@synthesize handStateBackground;
@synthesize chipImageView;
@synthesize greenChip;
@synthesize redChip;
@synthesize yellowChip;
@synthesize dealerButton;
@synthesize avatar;


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
        
        int y = 90;
        self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(y, 3, 35, 50)];
        [roundView addSubview:cardOne];
        self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(y+40, 3, 35, 50)];
        [roundView addSubview:cardTwo];

        
        UIImage *background = [UIImage imageNamed:@"bet_cell_background.png"];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:background];
        backgroundImage.frame = CGRectMake(0, 0, background.size.width/2, background.size.height/2);
        backgroundImage.userInteractionEnabled = YES;
        [roundView addSubview:backgroundImage];
        
        /*
        self.cellCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_corner.png"]];
        cellCorner.center = CGPointMake(304, 55);
        [roundView addSubview:cellCorner];*/
        
                
        
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, 130, 30)];
        userNameLabel.font = [UIFont boldSystemFontOfSize:20];
        userNameLabel.textColor = [UIColor blackColor];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 12;
        userNameLabel.backgroundColor = [UIColor clearColor];
        [roundView addSubview:userNameLabel];
        
        self.chipStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 45, 74, 25)];
        chipStackLabel.font = [UIFont boldSystemFontOfSize:16];
        chipStackLabel.adjustsFontSizeToFitWidth = YES;
        chipStackLabel.minimumFontSize = 10;
        chipStackLabel.textAlignment = UITextAlignmentRight;
        chipStackLabel.textColor = [UIColor blackColor];
        chipStackLabel.backgroundColor = [UIColor clearColor];
        [roundView addSubview:chipStackLabel];
        
        self.greenChip = [UIImage imageNamed:@"green_chip.png"];
        self.yellowChip = [UIImage imageNamed:@"yellow_chip.png"];
        self.redChip = [UIImage imageNamed:@"red_chip.png"];
        self.chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 46, greenChip.size.width/2+2, greenChip.size.height/2+2)];
        chipImageView.image = yellowChip;
        [roundView addSubview:chipImageView];
        
        self.actionName = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 126, 45)];
        actionName.font = [UIFont boldSystemFontOfSize:20];
        actionName.textAlignment = UITextAlignmentRight;
        actionName.numberOfLines = 2;
        actionName.textColor = [UIColor whiteColor];
        actionName.backgroundColor = [UIColor clearColor];
        [roundView addSubview:actionName];
        
        
        
        UIImage *handStateImage = [UIImage imageNamed:@"hand_state_background.png"];
        self.handStateBackground = [[UIImageView alloc] initWithImage:handStateImage];
        handStateBackground.frame = CGRectMake(0, 0, handStateImage.size.width/2, handStateImage.size.height/2);
        [self.contentView addSubview:handStateBackground];
        
        self.handState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        handState.font = [UIFont boldSystemFontOfSize:15];
        handState.textAlignment = UITextAlignmentCenter;
        handState.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        handState.backgroundColor = [UIColor clearColor];
        [handStateBackground addSubview:handState];
        
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
        

        
        self.betButton = [UIButton buttonWithType:UIButtonTypeCustom];
        betButton.frame = CGRectMake(230, 2, 82, 42);
        [betButton setImage:[UIImage imageNamed:@"bet_button.png"] forState:UIControlStateNormal];
        [roundView addSubview:betButton];
        
        self.nudgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nudgeButton.frame = CGRectMake(230, 2, 82, 42);
        [nudgeButton setImage:[UIImage imageNamed:@"nudge_button.png"] forState:UIControlStateNormal];

        [roundView addSubview:nudgeButton];
        
        self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 22, 60, 15)];
        timerLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        timerLabel.textAlignment = UITextAlignmentLeft;
        timerLabel.font = [UIFont systemFontOfSize:11];
        timerLabel.backgroundColor = [UIColor clearColor];
        timerLabel.alpha = 0.8;
        [nudgeButton addSubview:timerLabel];
        [betButton addSubview:timerLabel];
        
        self.timerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 24, 11, 11)];
        timerIcon.userInteractionEnabled = YES;
        timerIcon.alpha = 0.8;
        [timerIcon setImage:[UIImage imageNamed:@"timer_icon.png"]];
        [nudgeButton addSubview:timerIcon];
        [betButton addSubview:timerIcon];
        
        UILabel *nudgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 82, 28)];
        nudgeLabel.font = [UIFont boldSystemFontOfSize:18];
        nudgeLabel.textAlignment = UITextAlignmentCenter;
        nudgeLabel.textColor = [UIColor whiteColor];
        nudgeLabel.adjustsFontSizeToFitWidth = YES;
        nudgeLabel.minimumFontSize = 8;
        nudgeLabel.text = @"Nudge";
        nudgeLabel.backgroundColor = [UIColor clearColor];
        [nudgeButton addSubview:nudgeLabel];
        
        UILabel *betButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 82, 28)];
        betButtonLabel.font = [UIFont boldSystemFontOfSize:20];
        betButtonLabel.textAlignment = UITextAlignmentCenter;
        betButtonLabel.textColor = [UIColor whiteColor];
        betButtonLabel.adjustsFontSizeToFitWidth = YES;
        betButtonLabel.minimumFontSize = 8;
        betButtonLabel.text = @"Bet";
        betButtonLabel.backgroundColor = [UIColor clearColor];
        [betButton addSubview:betButtonLabel];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
                
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(9, 7, 56, 56)];
        avatar.radius = 150;
        [roundView addSubview:avatar];
        
        self.dealerButton = [[UIImageView alloc] initWithFrame:CGRectMake(55, 48, 20, 20)];
        [dealerButton setImage:[UIImage imageNamed:@"dealer_button.png"]];
        [roundView addSubview:dealerButton];

        
        
    }
    return self;
}

-(void)setCellData:(NSMutableDictionary *)dataDict chipStackState:(int)chipStackState{
    yourBet.hidden = YES;
    betButton.hidden =YES;
    nudgeButton.hidden = YES;
    timerLabel.hidden = YES;
    timerIcon.hidden = YES;
    timerLabel.text = @"00:00:00";
    [avatar loadAvatar:[dataDict valueForKey:@"userID"]];
    if(chipStackState == 1){
        chipImageView.image = greenChip;
    }else if(chipStackState == 2){
        chipImageView.image = yellowChip;
    }else if(chipStackState == 3){
        chipImageView.image = redChip;
    }
    
    if([dataDict valueForKey:@"HAND_STATE"] && [[dataDict valueForKey:@"HAND_STATE"] length] > 0){
       roundView.frame = CGRectMake(0, 25, 320, 72);
        handStateBackground.hidden = NO;
    }else{
       roundView.frame = CGRectMake(0, 0, 320, 72);
        handStateBackground.hidden = YES;
    }
    
    if([@"fold" isEqualToString:[dataDict objectForKey:@"action"]]){
        //self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        roundView.alpha = 0.8;
    }else{
        //self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];;
        roundView.alpha = 1;
    }
    
    
    chipStackLabel.textColor = [UIColor blackColor];
    chipStackLabel.font = [UIFont boldSystemFontOfSize:16];
    
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
    
    chipStackLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"userStack"]];
    if([[dataDict objectForKey:@"userStack"] doubleValue] == 0){
        chipStackLabel.text = @"-All in-";
        chipStackLabel.font = [UIFont boldSystemFontOfSize:20];
        chipStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    }
    
    
    //actionName.font = [UIFont systemFontOfSize:18];
    if([dataDict objectForKey:@"MY_BET_ROUND"] && [@"YES" isEqualToString:[dataDict objectForKey:@"MY_BET_ROUND"]]){
        actionName.text = @"";
        timerLabel.hidden = NO;
        timerIcon.hidden = NO;
        if(refreshTimer){
            [refreshTimer invalidate];
        }
        
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLastMoveTimer) userInfo:nil repeats:YES];
        [refreshTimer fire];
        
        
        //chipStackLabel.textColor = [UIColor whiteColor];
        
        if([[DataManager sharedInstance] isCurrentGameMyTurn]){

            actionName.text = @"";
            betButton.hidden = NO;
            
            
            
            [betButton addSubview:timerLabel];
            [betButton addSubview:timerIcon];
            
            
            userNameLabel.text = @"Your turn";
            [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[dataDict objectForKey:@"cardOne"]]];
            [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[dataDict objectForKey:@"cardTwo"]]];
            //self.contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1];
        }else{
            [nudgeButton addSubview:timerLabel];
            [nudgeButton addSubview:timerIcon];
            nudgeButton.hidden = NO;
            [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
            [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
            userNameLabel.text = [NSString stringWithFormat:@"%@'s turn",[dataDict objectForKey:@"userName"]];
            //self.contentView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        }
        
    }else{
        double amount = [[dataDict objectForKey:@"amount"] doubleValue];
        if(amount == 0){
            actionName.text = [NSString stringWithFormat:@"%@",NSLocalizedString([dataDict objectForKey:@"action"], nil)];
        
        }else{
            if([@"raise" isEqualToString:[dataDict objectForKey:@"action"]]){
                //actionName.font = [UIFont boldSystemFontOfSize:18];
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
        dealerButton.hidden = NO;
    }else{
        dealerButton.hidden = YES;
    }    
    /*else if([playerState valueForKey:@"isSmallBlind"] && [[playerState valueForKey:@"isSmallBlind"] isEqualToString:@"YES"]){
        position.text = @"SB";
    }else if([playerState valueForKey:@"isBigBlind"] && [[playerState valueForKey:@"isBigBlind"] isEqualToString:@"YES"]){
        position.text = @"BB";
    */
    
    
    if(![[DataManager sharedInstance] hasMoreThanOnePlayerForCurrentGame]){
        betButton.hidden = YES;
        nudgeButton.hidden = YES;
    }
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
