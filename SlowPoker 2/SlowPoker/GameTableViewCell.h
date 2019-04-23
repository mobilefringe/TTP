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
}

@property(nonatomic,retain)UIImageView *card1;
@property(nonatomic,retain)UIImageView *card2;
@property(nonatomic,retain)UILabel *vsLabel;
@property(nonatomic,retain)UILabel *userStackLabel;
@property(nonatomic,retain)UILabel *gameTypeLabel;
@property(nonatomic,retain)UILabel *playersTurn;
@property(nonatomic,retain)UILabel *gameIDLabel;

-(void)setCellData:(NSMutableDictionary *)game;

@end
