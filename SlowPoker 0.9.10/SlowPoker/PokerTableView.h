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
@class CardView;

@protocol HandSummaryDelegate <NSObject>
@optional
-(void)showHandSummaryForHand:(NSMutableDictionary *)hand;
@end

@interface PokerTableView : UIView{
    UIView *showDownView;
    CardView *communityCardOne;
    CardView *communityCardTwo;
    CardView *communityCardThree;
    CardView *communityCardFour;
    CardView *communityCardFive;
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
    UILabel *betLabel2;
}
@property(nonatomic,retain)UIView *showDownView;
@property(nonatomic,retain)NSMutableArray *players;
@property(nonatomic,retain)NSMutableDictionary *placements;
@property(nonatomic,retain)NSMutableDictionary *dealerButtonPlacements;
@property(nonatomic,retain)UIImageView *background;
@property (nonatomic,retain) CardView *communityCardOne;
@property (nonatomic,retain) CardView *communityCardTwo;
@property (nonatomic,retain) CardView *communityCardThree;
@property (nonatomic,retain) CardView *communityCardFour;
@property (nonatomic,retain) CardView *communityCardFive;
@property (nonatomic,retain) TurnsViewController *delegate;
@property (nonatomic,retain) UILabel *potLabel;
@property (nonatomic,retain)UIButton *betButton;
@property (nonatomic,retain) UIButton *handSummaryButton;
@property (nonatomic,retain)UIButton *dealNewHandButton;
@property (nonatomic,retain)NSMutableDictionary *showHand;
@property (nonatomic,retain) UILabel *winnerType;
@property (nonatomic,retain) NSMutableArray *playerViews;
@property (nonatomic,retain)UIButton *addPlayerButton;
@property (nonatomic,retain)UILabel *betLabel2;
-(void)clearGame;
-(void)loadGame;
-(NSMutableDictionary *)lastRoundPlayer:(NSString *)userID forHand:(NSMutableDictionary *)hand;
-(double)loadGame:(BOOL)currentHand;
-(void)viewHand;
-(void)newHand;
-(void)showGiftForUser:(NSString *)userID animated:(BOOL)animated;
@property (nonatomic,retain) id<HandSummaryDelegate> handSummaryDelegate;
@end
