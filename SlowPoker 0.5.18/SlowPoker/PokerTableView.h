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

@interface PokerTableView : UIView{
    UIImageView *communityCardOne;
    UIImageView *communityCardTwo;
    UIImageView *communityCardThree;
    UIImageView *communityCardFour;
    UIImageView *communityCardFive;
    NSMutableArray *players;
    NSMutableDictionary *placements;
    UIImageView *background;
    UILabel *potLabel;
    TurnsViewController *delegate;
    Button *betButton;
    Button *dealNewHandButton;
    NSMutableDictionary *showHand;
    UILabel *winnerType;
    int communityCardsY;
}

@property(nonatomic,retain)NSMutableArray *players;
@property(nonatomic,retain)NSMutableDictionary *placements;
@property(nonatomic,retain)UIImageView *background;
@property (nonatomic,retain) UIImageView *communityCardOne;
@property (nonatomic,retain) UIImageView *communityCardTwo;
@property (nonatomic,retain) UIImageView *communityCardThree;
@property (nonatomic,retain) UIImageView *communityCardFour;
@property (nonatomic,retain) UIImageView *communityCardFive;
@property (nonatomic,retain) TurnsViewController *delegate;
@property (nonatomic,retain) UILabel *potLabel;
@property (nonatomic,retain)Button *betButton;
@property (nonatomic,retain)Button *dealNewHandButton;
@property (nonatomic,retain)NSMutableDictionary *showHand;
@property (nonatomic,retain) UILabel *winnerType;
-(void)clearGame;
-(void)loadGame;
-(NSMutableDictionary *)lastRoundPlayer:(NSString *)userID forHand:(NSMutableDictionary *)hand;
-(void)loadGame:(BOOL)currentHand;
-(void)viewHand;
-(void)newHand;

@end
