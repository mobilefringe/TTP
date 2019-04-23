//
//  MyFriendsTableCellCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Avatar;
@class TTTTimeIntervalFormatter;
@class AchievementIcon;

@interface MyFriendsTableCellCell : UITableViewCell{
    Avatar *avatar;
    UILabel *userNameLabel;
    UILabel *activeGamesLabel;
    UILabel *activeGamesValue;
    UILabel *lastLoggedInLabel;
    NSDateFormatter *utcFormatter;
    NSDateFormatter *localFormatter;
    TTTTimeIntervalFormatter *timeIntervalFormatter;
    BOOL isInstructions;
    UILabel *instructions;
    UIImageView *background;
    UIImageView *bestPrimaryAchievement;
    
}

@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *activeGamesLabel;
@property (nonatomic,retain)UILabel *activeGamesValue;
@property (nonatomic,retain)UILabel *lastLoggedInLabel;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
@property (nonatomic,retain)NSDateFormatter *localFormatter;
@property (nonatomic, retain) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property (readwrite) BOOL isInstructions;
@property (nonatomic,retain)UILabel *instructions;
@property (nonatomic,retain)UIImageView *bestPrimaryAchievement;

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict;
-(BOOL)hasAchievement:(NSString *)code achievements:(NSMutableArray *)achievements;

@end
