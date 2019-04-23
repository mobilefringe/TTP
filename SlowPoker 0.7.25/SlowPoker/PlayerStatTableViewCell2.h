//
//  PlayerStatTableViewCell2.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerStatTableViewCell2 : UITableViewCell{
    UILabel *statTitle;
    UILabel *winValue;
    UILabel *lostVale;
    UILabel *betVale;
    UILabel *netTitle;
    UILabel *netValue;
    BOOL isLocked;
    UIImageView *lockIcon1;
    UIImageView *lockIcon2;
    UIImageView *lockIcon3;
    UIImageView *lockIcon4;
    UIImageView *background;
}

@property(nonatomic,retain)UILabel *statTitle;
@property(nonatomic,retain)UILabel *winValue;
@property(nonatomic,retain)UILabel *lostVale;
@property(nonatomic,retain)UILabel *betVale;
@property(nonatomic,retain)UILabel *netTitle;
@property(nonatomic,retain)UILabel *netValue;
@property(nonatomic,retain)UIImageView *lockIcon1;
@property(nonatomic,retain)UIImageView *lockIcon2;
@property(nonatomic,retain)UIImageView *lockIcon3;
@property(nonatomic,retain)UIImageView *lockIcon4;
@property(readwrite) BOOL isLocked;

-(void)setData:(NSString *)statCode winAmount:(double)winAmount loseAmount:(double)loseAmount betAmount:(double)betAmount;

@end
