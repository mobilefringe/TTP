//
//  PlayerView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Button;
@class TurnsViewController;
@class Avatar;

@interface PlayerView : UIView{
    UIImageView *backgroundImageView;
    UIImage *backgroundBlue;
    UIImageView *grayBar;
    UILabel *userNameLabel;
    UILabel *userStackLabel;
    UILabel *actionLabel;
    NSMutableDictionary *player;
    Avatar *avatar;
    NSTimer *refreshTimer;
    
    UIImageView *dealerButton;
    UIView *playerView;
    UIImageView *cardOne;
    UIImageView *cardTwo;
    BOOL isCurrentHandTmp;
    BOOL isWinner;
    BOOL isMe;
    TurnsViewController *delegate;
    UIButton *button;
    NSDateFormatter *dateFormatter;
    UIImageView *chipImageView;
    UIImage *greenChip;
    UIImage *redChip;
    UIImage *yellowChip;
    UIButton *giftButton;
    NSString *giftUserID;
    UIImageView *giftIcon;
    UIImageView *giftFlipView;
    UIImageView *giftActiveBackground;
    UIImageView *giftActiveImageView;
}
@property (nonatomic,retain)UIImageView *backgroundImageView;
@property (nonatomic,retain)UIImage *backgroundBlue;
@property (nonatomic,retain)UIImageView *grayBar;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *userStackLabel;
@property (nonatomic,retain)NSMutableDictionary *player;
@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *actionLabel;
@property (nonatomic,retain)NSTimer *refreshTimer;

@property (nonatomic,retain)UIImageView *dealerButton;
@property (nonatomic,retain)UIView *playerView;
@property (nonatomic,retain)UIImageView *cardOne;
@property (nonatomic,retain)UIImageView *cardTwo;
@property (nonatomic,retain)TurnsViewController *delegate;
@property (nonatomic,retain)UIButton *button;
@property (nonatomic,retain)NSDateFormatter *dateFormatter;
@property (nonatomic,retain)UIImageView *chipImageView;
@property (nonatomic,retain)UIImage *greenChip;
@property (nonatomic,retain)UIImage *redChip;
@property (nonatomic,retain)UIImage *yellowChip;
@property (nonatomic,retain)UIButton *giftButton;
@property (nonatomic,retain)NSString *giftUserID;
@property (nonatomic,retain)UIImageView *giftIcon;
@property (nonatomic,retain)UIImageView *giftFlipView;
@property (nonatomic,retain)UIImageView *giftActiveBackground;
@property (nonatomic,retain)UIImageView *giftActiveImageView;
@property (readwrite)BOOL isMe ;

-(void)setPlayerData:(NSMutableDictionary *)playerData isCurrentHand:(BOOL)isCurrentHand winners:(NSMutableArray *)winners chipStackState:(int)chipStackState dealerButtonCentre:(CGPoint)dealerButtonCentre;
-(void)showGift:(NSMutableDictionary *)gift animated:(BOOL)animated;



@end
