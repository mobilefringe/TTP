//
//  PokerTableView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Button;
@class TurnsViewController;

@protocol HandSummaryDelegate <NSObject>
@optional
-(void)showHandSummaryForHand:(NSMutableDictionary *)hand;
@end

@interface PokerTableView : UIView{
    UIImageView *communityCardOne;
    UIImageView *communityCardTwo;
    UIImageView *communityCardThree;
    UIImageView *communityCardFour;
    UIImageView *communityCardFive;
    NSMutableArray *players;
    NSMutableDictionary *placements;
    NSMutableDictionary *dealerButtonPlacements;
    UIImageView *background;
    UILabel *potLabel;
    TurnsViewController *delegate;
    UIButton *betButton;
    UIButton *dealNewHandButton;
    UIButton *handSummaryButton;
    NSMutableDictionary *showHand;
    UILabel *winnerType;
    int communityCardsY;
    NSMutableArray *playerViews;
    id handSummaryDelegate;
    UIButton *addPlayerButton;
}

@property(nonatomic,retain)NSMutableArray *players;
@property(nonatomic,retain)NSMutableDictionary *placements;
@property(nonatomic,retain)NSMutableDictionary *dealerButtonPlacements;
@property(nonatomic,retain)UIImageView *background;
@property (nonatomic,retain) UIImageView *communityCardOne;
@property (nonatomic,retain) UIImageView *communityCardTwo;
@property (nonatomic,retain) UIImageView *communityCardThree;
@property (nonatomic,retain) UIImageView *communityCardFour;
@property (nonatomic,retain) UIImageView *communityCardFive;
@property (nonatomic,retain) TurnsViewController *delegate;
@property (nonatomic,retain) UILabel *potLabel;
@property (nonatomic,retain)UIButton *betButton;
@property (nonatomic,retain) UIButton *handSummaryButton;
@property (nonatomic,retain)UIButton *dealNewHandButton;
@property (nonatomic,retain)NSMutableDictionary *showHand;
@property (nonatomic,retain) UILabel *winnerType;
@property (nonatomic,retain) NSMutableArray *playerViews;
@property (nonatomic,retain)UIButton *addPlayerButton;
-(void)clearGame;
-(void)loadGame;
-(NSMutableDictionary *)lastRoundPlayer:(NSString *)userID forHand:(NSMutableDictionary *)hand;
-(void)loadGame:(BOOL)currentHand;
-(void)viewHand;
-(void)newHand;
-(void)showGiftForUser:(NSString *)userID animated:(BOOL)animated;
@property (nonatomic,retain) id<HandSummaryDelegate> handSummaryDelegate;
@end
