//
//  TurnSectionHeader.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BetViewController;

@protocol HandSummaryDelegate <NSObject>
@optional
-(void)showHandSummaryForHand:(NSMutableDictionary *)hand;
@end

@interface TurnSectionHeader : UIView{
    UIImageView *communityCardOne;
    UIImageView *communityCardTwo;
    UIImageView *communityCardThree;
    UIImageView *communityCardFour;
    UIImageView *communityCardFive;
    UILabel *handNumberLabel;
    UILabel *potLabel;
    UILabel *winnerLabel;
    UILabel *winnerType;
    int guiState;
    UIView *whiteBlock;
    UIView *handDetails;
    UIActivityIndicatorView *activityIndicatorView;
    UIButton *handSummaryButton;
    NSMutableDictionary *handData;
    id delegate;
    
    
}

@property (nonatomic,retain) UIImageView *communityCardOne;
@property (nonatomic,retain) UIImageView *communityCardTwo;
@property (nonatomic,retain) UIImageView *communityCardThree;
@property (nonatomic,retain) UIImageView *communityCardFour;
@property (nonatomic,retain) UIImageView *communityCardFive;
@property (nonatomic,retain) UILabel *handNumberLabel;
@property (nonatomic,retain) UILabel *potLabel;
@property (nonatomic,retain) UILabel *winnerLabel;
@property (nonatomic,retain) UILabel *winnerType;
@property (nonatomic,retain) UIView *whiteBlock;
@property (nonatomic,retain) UIView *handDetails;
@property (nonatomic,retain) BetViewController *betViewController;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,retain) UIButton *handSummaryButton;
@property (nonatomic,retain) NSMutableDictionary *handData;
@property (nonatomic,retain) id<HandSummaryDelegate> delegate;
@property (readwrite)int guiState;
-(void)setHeaderData:(NSMutableDictionary *)data;
     

@end
