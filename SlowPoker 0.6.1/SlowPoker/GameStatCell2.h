//
//  GameStatCell2.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameStatCell2 : UITableViewCell{UILabel *statTitle;
    UILabel *statCount;
    UILabel *statPercentage;
    UILabel *statSubtitle;
    UIImageView *barGraphBackground;
    UIImageView *barGraph;
    
    UILabel *statPercentage2;
    UILabel *statSubtitle2;
    UIImageView *barGraphBackground2;
    UIImageView *barGraph2;
    
    UIImageView *lockIcon;
    NSString *statCodeTmp;
    BOOL isLocked;
    NSString *userID;
}

@property(nonatomic,retain) UILabel *statTitle;
@property(nonatomic,retain) UILabel *statCount;
@property(nonatomic,retain) UILabel *statPercentage;
@property(nonatomic,retain) UILabel *statSubtitle;
@property(nonatomic,retain) UIImageView *barGraphBackground;
@property(nonatomic,retain) UIImageView *barGraph;
@property(nonatomic,retain) UILabel *statPercentage2;
@property(nonatomic,retain) UILabel *statSubtitle2;
@property(nonatomic,retain) UIImageView *barGraphBackground2;
@property(nonatomic,retain) UIImageView *barGraph2;
@property(nonatomic,retain) UIImageView *lockIcon;
@property(nonatomic,retain) NSString *statCodeTmp;
@property(nonatomic,retain) NSString *userID;
@property(readwrite) BOOL isLocked;

-(void)setPlayerStat:(NSString *)statCode percentage:(double)percentage;
-(void)setPlayerStat:(NSString *)statCode percentage:(double)percentage subtext:(NSString*)subtext;
-(void)setPlayerStat:(NSMutableDictionary *)playerStats statCode:(NSString *)statCode subtext:(NSString*)subtext;
-(void)setPlayerStatWithMaxValue:(NSMutableDictionary *)playerStats statCode:(NSString *)statCode subtext:(NSString*)subtext maxValue:(double)maxValue;
@end

