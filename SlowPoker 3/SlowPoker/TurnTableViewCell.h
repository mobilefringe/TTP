//
//  TurnTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property (readwrite)BOOL showCards;
@property (readwrite)int guiState;


-(void)setCellData:(NSMutableDictionary *)dataDict;


@end
