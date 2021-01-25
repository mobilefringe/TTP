//
//  HandSummaryView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Avatar;

@interface HandSummaryView : UIView{
    Avatar *avatar;
    UILabel *winnerLabel;
    UILabel *winnerName;
    UILabel *amountLabel;
    UILabel *handTypeLabel;
    UILabel *handDetailsLabel;
    UIImageView *cardOne;
    UIImageView *cardTwo;
    UIImageView *cardThree;
    UIImageView *cardFour;
    UIImageView *cardFive;
    UIImageView *playerWinCardOne;
    UIImageView *playerWinCardTwo;
    
    NSMutableArray *players;
    NSMutableDictionary *placements;
    NSMutableArray *playerViews;

}

-(void)setWinnerData:(NSMutableDictionary *)winner hand:(NSMutableDictionary *)hand isSplit:(BOOL)isSplit delay:(double)delay;
-(BOOL)isCardInWinningHand:(NSMutableArray *)winningHand card:(NSString *)card;
@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *winnerLabel;
@property (nonatomic,retain)UILabel *winnerName;
@property (nonatomic,retain)UILabel *amountLabel;
@property (nonatomic,retain)UILabel *handTypeLabel;
@property (nonatomic,retain)UILabel *handDetailsLabel;
@property (nonatomic,retain)UIImageView *cardOne;
@property (nonatomic,retain)UIImageView *cardTwo;
@property (nonatomic,retain)UIImageView *cardThree;
@property (nonatomic,retain)UIImageView *cardFour;
@property (nonatomic,retain)UIImageView *cardFive;
@property (nonatomic,retain)UIImageView *playerWinCardOne;
@property (nonatomic,retain)UIImageView *playerWinCardTwo;

@property(nonatomic,retain)NSMutableArray *players;
@property(nonatomic,retain)NSMutableDictionary *placements;
@property (nonatomic,retain) NSMutableArray *playerViews;
@end
