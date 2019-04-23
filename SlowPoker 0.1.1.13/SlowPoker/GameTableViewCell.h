//
//  GameTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTableViewCell : UITableViewCell{
    UIImageView *card1;
    UIImageView *card2;
    UILabel *vsLabel;
    UILabel *userStackLabel;
    UILabel *gameTypeLabel;
    UILabel *playersTurn;
    UILabel *gameIDLabel;
    UILabel *playNowLabel;
    UILabel *playNowDescriptionLabel;
    UIImageView *chatIndicator;
    UILabel *chatCountLabel;
    BOOL isPlayNow;
    BOOL isCreateGame;
    BOOL isFreeGames;
    BOOL isDeleteGameBlurb;
    BOOL isFeedback;
    UIImageView *chipImageView;
    UIImage *greenChip;
    UIImage *redChip;
    UIImage *yellowChip;
    UIImage *blueChip;
    UIImageView *createGameImageView;
    UIImageView *joinGameImageView;
    UIImageView *swipeGestureImageView;
    UIImageView *proChipImageView;
    UIImageView *cashImageView;
    UIImageView *tournamentImageView;
    UIImageView *feedbackImageView;
    UIImageView *background;
}

@property(nonatomic,retain)UIImageView *card1;
@property(nonatomic,retain)UIImageView *card2;
@property(nonatomic,retain)UILabel *vsLabel;
@property(nonatomic,retain)UILabel *userStackLabel;
@property(nonatomic,retain)UILabel *gameTypeLabel;
@property(nonatomic,retain)UILabel *playersTurn;
@property(nonatomic,retain)UILabel *gameIDLabel;
@property(nonatomic,retain)UILabel *playNowLabel;
@property(nonatomic,retain)UILabel *playNowDescriptionLabel;
@property(nonatomic,retain)UIImageView *chatIndicator;
@property(nonatomic,retain)UILabel *chatCountLabel;
@property(readwrite)BOOL isPlayNow;
@property(readwrite)BOOL isCreateGame;
@property(readwrite)BOOL isFreeGames;
@property(readwrite)BOOL isDeleteGameBlurb;
@property(readwrite)BOOL isFeedback;
@property (nonatomic,retain)UIImageView *chipImageView;
@property (nonatomic,retain)UIImage *greenChip;
@property (nonatomic,retain)UIImage *redChip;
@property (nonatomic,retain)UIImage *yellowChip;
@property (nonatomic,retain)UIImageView *createGameImageView;
@property (nonatomic,retain)UIImageView *joinGameImageView;
@property (nonatomic,retain)UIImageView *cashImageView;
@property (nonatomic,retain)UIImageView *tournamentImageView;
@property (nonatomic,retain)UIImageView *proChipImageView;
@property (nonatomic,retain)UIImageView *swipeGestureImageView;
@property (nonatomic,retain)UIImageView *feedbackImageView;
@property (nonatomic,retain)UIImage *blueChip;

-(void)setCellData:(NSMutableDictionary *)game;

@end
