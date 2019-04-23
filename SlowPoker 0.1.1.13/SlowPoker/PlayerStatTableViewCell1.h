//
//  PlayerStatTableViewCell1.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerStatTableViewCell1 : UITableViewCell{
    UILabel *statTitle;
    UILabel *statCount;
    UILabel *statPercentage;
    UILabel *statSubtitle;
    UIImageView *barGraphBackground;
    UIImageView *barGraph;
    UIImageView *lockIcon;
    NSString *statCodeTmp;
    BOOL isLocked;
    UIImageView *background;
}

@property(nonatomic,retain) UILabel *statTitle;
@property(nonatomic,retain) UILabel *statCount;
@property(nonatomic,retain) UILabel *statPercentage;
@property(nonatomic,retain) UILabel *statSubtitle;
@property(nonatomic,retain) UIImageView *barGraphBackground;
@property(nonatomic,retain) UIImageView *barGraph;
@property(nonatomic,retain) UIImageView *lockIcon;
@property(nonatomic,retain) NSString *statCodeTmp;
@property(readwrite) BOOL isLocked;

-(void)setPlayerStat:(NSString *)statCode percentage:(double)percentage;
-(void)setPlayerStat:(NSString *)statCode percentage:(double)percentage subtext:(NSString*)subtext;
-(void)setPlayerStatValue:(NSString *)statCode value:(double)value subtext:(NSString*)subtext;
@end
