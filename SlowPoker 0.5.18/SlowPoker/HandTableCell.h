//
//  HandTableCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hand.h"

@interface HandTableCell : UITableViewCell{
    UIImageView *card1;
    UIImageView *card2;
    UIImageView *card3;
    UIImageView *card4;
    UIImageView *card5;
    UILabel *handValue;
    UILabel *handType;
}

@property(nonatomic,retain)UIImageView *card1;
@property(nonatomic,retain)UIImageView *card2;
@property(nonatomic,retain)UIImageView *card3;
@property(nonatomic,retain)UIImageView *card4;
@property(nonatomic,retain)UIImageView *card5;
@property(nonatomic,retain)UILabel *handValue;
@property(nonatomic,retain)UILabel *handType;
-(void)setCards:(NSMutableArray *)cards hand:(Hand *)hand;

@end
