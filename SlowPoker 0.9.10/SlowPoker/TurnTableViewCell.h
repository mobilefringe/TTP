//
//  TurnTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NudgeButton;
@class Button;
@class Avatar;

@interface TurnTableViewCell : UITableViewCell{
    UIImageView *cardOne;
    UIImageView *cardTwo;
    UILabel *userNameLabel;
    UILabel *chipStackLabel;
    UILabel *actionName;
    UILabel *actionAmount;
    UILabel *handState;
    UILabel *position;
    BOOL showCards;
    int guiState;
    UIImageView *yourBet;
    UIView *roundView;
    UIImageView *cellCorner;
    UIButton *betButton;
    UIButton *nudgeButton;
    UILabel *timerLabel;
    NSTimer *refreshTimer;
    UIImageView *timerIcon;
    NSDateFormatter *dateFormatter;
    UIImageView *handStateBackground;
    UIImageView *chipImageView;
    UIImage *greenChip;
    UIImage *redChip;
    UIImage *yellowChip;
    UIImageView *dealerButton;
    Avatar *avatar;
    UILabel *betButtonLabel;
}

@property (nonatomic,retain)UIImageView *cardOne;
@property (nonatomic,retain)UIImageView *cardTwo;
@property (nonatomic,retain)UIImageView *dealerButton;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *chipStackLabel;
@property (nonatomic,retain)UILabel *actionName;
@property (nonatomic,retain)UILabel *actionAmount;
@property (nonatomic,retain)UILabel *handState;
@property (nonatomic,retain)UILabel *position;
@property (nonatomic,retain)UIImageView *yourBet;
@property (nonatomic,retain)UIView *roundView;
@property (nonatomic,retain)UIImageView *cellCorner;
@property (nonatomic,retain)UIButton *betButton;
@property (nonatomic,retain)UIButton *nudgeButton;
@property (nonatomic,retain)UILabel *timerLabel;
@property (nonatomic,retain)NSTimer *refreshTimer;
@property (nonatomic,retain)UIImageView *timerIcon;
@property (nonatomic,retain)NSDateFormatter *dateFormatter;
@property (nonatomic,retain)UIImageView *handStateBackground;
@property (readwrite)BOOL showCards;
@property (readwrite)int guiState;
@property (nonatomic,retain)UIImageView *chipImageView;
@property (nonatomic,retain)UIImage *greenChip;
@property (nonatomic,retain)UIImage *redChip;
@property (nonatomic,retain)UIImage *yellowChip;
@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *betButtonLabel;


-(void)setCellData:(NSMutableDictionary *)dataDict chipStackState:(int)chipStackState;


@end
